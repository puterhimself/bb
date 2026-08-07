#!/usr/bin/env bash
#
# Wizard: Add wildcard DNS for *.bb.zopu.live
# One step — add a DNS record in Cloudflare dashboard
#
# Run: bash scripts/setup-dns-wildcard.sh

set -euo pipefail

if [[ -t 1 ]] && command -v tput >/dev/null 2>&1 && [[ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]]; then
  BOLD=$(tput bold); DIM=$(tput dim); RESET=$(tput sgr0)
  BLUE=$(tput setaf 4); GREEN=$(tput setaf 2); YELLOW=$(tput setaf 3)
else
  BOLD=""; DIM=""; RESET=""; BLUE=""; GREEN=""; YELLOW=""
fi

_clear() {
  [[ -t 1 ]] || return 0
  if command -v tput >/dev/null 2>&1; then tput clear; else printf '\033[2J\033[3J\033[H'; fi
}

say()  { printf '  %s\n' "$1"; }
step() { printf '  %s•%s %s\n' "$BLUE" "$RESET" "$1"; }
note() { printf '  %s%s%s\n' "$DIM" "$1" "$RESET"; }
warn() { printf '  %s⚠ %s%s\n' "$YELLOW" "$1" "$RESET"; }
pause() {
  printf '  %s%s%s ' "$DIM" "${1:-Press Enter to continue}" "$RESET"
  read -r _ || true
}

open_url() {
  local url="$1"
  printf '  %s↗ opening%s %s\n' "$GREEN" "$RESET" "$url"
  { command -v open >/dev/null 2>&1 && open "$url"; } >/dev/null 2>&1 || warn "visit manually: $url"
}

_clear
printf '\n%s%s  Add wildcard DNS for *.bb.zopu.live%s\n\n' "$BOLD" "$BLUE" "$RESET"

say "User workspace URLs (puter.bb.zopu.live etc.) need a wildcard DNS record."
say ""
step "Open the Cloudflare DNS dashboard for zopu.live:"
open_url "https://dash.cloudflare.com/?to=/:zone/dns/records"
say ""
step "Click 'Add record' and fill in:"
note "  Type:     A"
note "  Name:     *.bb"
note "  IPv4:     192.0.2.1"
note "  Proxy:    🟧 Proxied (ON)"
note "  TTL:      Auto"
say ""
step "Click 'Save'"
say ""
note "Then add a second record (for the dashboard itself, if not auto-created):"
step "Click 'Add record' again:"
note "  Type:     AAAA"
note "  Name:     bb"
note "  IPv6:     100::"
note "  Proxy:    🟧 Proxied (ON)"
note "  TTL:      Auto"
say ""
step "Click 'Save'"
say ""
pause "Press Enter when both records are added"

# Verify
printf '\n  %sVerifying DNS...%s\n' "$DIM" "$RESET"
sleep 3

if command -v dig >/dev/null 2>&1; then
  for host in "bb.zopu.live" "puter.bb.zopu.live"; do
    result=$(dig "$host" +short 2>/dev/null | head -1)
    if [ -n "$result" ]; then
      printf '  %s✓ %s resolves to %s%s\n' "$GREEN" "$host" "$result" "$RESET"
    else
      printf '  %s⚠ %s not resolving yet (may take a minute)%s\n' "$YELLOW" "$host" "$RESET"
    fi
  done
fi

printf '\n%s%s  Done! Go to https://bb.zopu.live/dashboard%s\n' "$BOLD" "$GREEN" "$RESET"
