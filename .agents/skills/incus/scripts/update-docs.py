#!/usr/bin/env python3
"""Refresh the project-local Incus documentation snapshot."""
from __future__ import annotations
import datetime as dt, hashlib, html, json, re, sys
from collections import deque
from pathlib import Path
from urllib.parse import urldefrag, urljoin, urlparse
from urllib.request import Request, urlopen

BASE = "https://linuxcontainers.org/incus/docs/main/"
ROOT = Path(__file__).resolve().parent.parent
PAGES = ROOT / "references/pages"
MANIFEST = ROOT / "references/manifest.json"

def fetch(url: str) -> str:
    req = Request(url, headers={"User-Agent": "bb-incus-local-skill/1.0"})
    with urlopen(req, timeout=30) as r:
        return r.read().decode("utf-8", "replace")

def clean_page(raw: str) -> tuple[str, str, set[str]]:
    title = re.search(r"<h1[^>]*>(.*?)</h1>", raw, re.S | re.I)
    title_text = re.sub(r"<[^>]+>", "", title.group(1) if title else "Incus")
    title_text = html.unescape(re.sub(r"\s+", " ", title_text)).strip().replace(" ¶", "")
    article = re.search(r"<article[^>]*>(.*)</article>", raw, re.S | re.I)
    body = article.group(1) if article else raw
    links = set()
    for href in re.findall(r'href=["\']([^"\']+)', raw, re.I):
        u = urldefrag(urljoin(BASE, html.unescape(href)))[0]
        if u.startswith(BASE) and not urlparse(u).query and (u.endswith("/") or u.endswith(".html")):
            links.add(u)
    body = re.sub(r"<(script|style|nav|header|footer)\b[^>]*>.*?</\1>", "", body, flags=re.S|re.I)
    body = re.sub(r"<pre[^>]*>(.*?)</pre>", lambda m: "\n```\n" + html.unescape(re.sub(r"<[^>]+>", "", m.group(1))) + "\n```\n", body, flags=re.S|re.I)
    body = re.sub(r"<br\s*/?>", "\n", body, flags=re.I)
    body = re.sub(r"</(p|div|section|li|h[1-6])>", "\n", body, flags=re.I)
    text = html.unescape(re.sub(r"<[^>]+>", "", body))
    text = re.sub(r"[ \t]+", " ", text)
    text = re.sub(r"\n{3,}", "\n\n", text).strip()
    return title_text, text, links

def main() -> int:
    queue, seen, pages = deque([BASE]), set(), []
    while queue:
        url = queue.popleft()
        if url in seen: continue
        seen.add(url)
        try: raw = fetch(url)
        except Exception as exc:
            print(f"warning: {url}: {exc}", file=sys.stderr); continue
        title, text, links = clean_page(raw)
        pages.append((url, title, text))
        for link in links:
            if link not in seen: queue.append(link)
        print(f"{len(pages):4d} {url}")
    PAGES.mkdir(parents=True, exist_ok=True)
    now=dt.datetime.now(dt.timezone.utc).isoformat()
    entries=[]
    for url,title,text in sorted(pages):
        rel=url[len(BASE):].strip("/") or "index"
        filename=re.sub(r"[^A-Za-z0-9._-]+", "__", rel)+".md"
        (PAGES/filename).write_text(f"# {title}\n\nSource: {url}\nFetched: {now[:10]}\n\n{text}\n")
        entries.append({"path":rel,"title":title,"url":url,"file":f"references/pages/{filename}"})
    MANIFEST.write_text(json.dumps({"source":BASE,"fetched":now,"page_count":len(entries),"pages":entries},indent=2)+"\n")
    print(f"Wrote {len(entries)} pages to {PAGES}")
    return 0
if __name__ == "__main__": raise SystemExit(main())
