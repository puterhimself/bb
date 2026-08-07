#!/usr/bin/env bash
#
# Wizard: GitHub OAuth setup for BB Connect local dev
# Walks you through creating a GitHub OAuth App and captures the values
# into apps/web/.dev.vars
#
# Run: bash scripts/setup-github-oauth.sh

set -euo pipefail

# ──────────────────────────────────────────────────────────────────────────
# Wizard library
# ──────────────────────────────────────────────────────────────────────────

if [[ -t 1 ]] && command -v tput >/dev/null 2>&1 && [[ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]]; then
  BOLD=$(tput bold); DIM=$(tput dim); RESET=$(tput sgr0)
  BLUE=$(tput setaf 4); GREEN=$(tput setaf 2); YELLOW=$(tput setaf 3); RED=$(tput setaf 1)
else
  BOLD=""; DIM=""; RESET=""; BLUE=""; GREEN=""; YELLOW=""; RED=""
fi

TOTAL_STAGES=3
TOTAL_MINUTES=5
_STAGE_INDEX=0
_MINUTES_ELAPSED=0
ENV_FILE="apps/web/.dev.vars"
WRITTEN_ENV=()

_clear() {
  [[ -t 1 ]] || return 0
  if command -v tput >/dev/null 2>&1; then tput clear; else printf '\033[2J\033[3J\033[H'; fi
}

banner() {
  _clear
  printf '\n%s%s  %s%s\n' "$BOLD" "$BLUE" "$1" "$RESET"
  printf '%s  %s stages · about %s minutes%s\n\n' \
    "$DIM" "$TOTAL_STAGES" "$TOTAL_MINUTES" "$RESET"
  pause "Ready to start?"
}

stage() {
  _clear
  _STAGE_INDEX=$((_STAGE_INDEX + 1))
  local remaining=$((TOTAL_MINUTES - _MINUTES_ELAPSED))
  (( remaining < 0 )) && remaining=0
  _MINUTES_ELAPSED=$((_MINUTES_ELAPSED + ${2:-0}))
  printf '\n%s%s▸ Stage %s/%s · %s%s  %s(~%s min left)%s\n' \
    "$BOLD" "$BLUE" "$_STAGE_INDEX" "$TOTAL_STAGES" "$1" "$RESET" "$DIM" "$remaining" "$RESET"
}

say()  { printf '  %s\n' "$1"; }
step() { printf '  %s•%s %s\n' "$BLUE" "$RESET" "$1"; }
note() { printf '  %s%s%s\n' "$DIM" "$1" "$RESET"; }
warn() { printf '  %s⚠ %s%s\n' "$YELLOW" "$1" "$RESET"; }

open_url() {
  local url="$1"
  printf '  %s↗ opening%s %s\n' "$GREEN" "$RESET" "$url"
  { command -v open >/dev/null 2>&1 && open "$url"; } >/dev/null 2>&1 || warn "visit manually: $url"
}

pause() {
  printf '  %s%s%s ' "$DIM" "${1:-Press Enter to continue}" "$RESET"
  read -r _ || true
}

_existing() {
  [[ -f "$ENV_FILE" ]] || return 1
  local line; line=$(grep -E "^${1}=" "$ENV_FILE" | tail -n1) || return 1
  printf '%s' "${line#*=}"
}

ask() {
  local key="$1" prompt="$2" current input
  current=$(_existing "$key" || true)
  if [[ -n "$current" ]]; then
    printf '  %s%s%s %s[Enter keeps current]%s ' "$BOLD" "$prompt" "$RESET" "$DIM" "$RESET"
  else
    printf '  %s%s%s ' "$BOLD" "$prompt" "$RESET"
  fi
  read -r input || true
  [[ -z "$input" && -n "$current" ]] && input="$current"
  printf -v "$key" '%s' "$input"
}

ask_secret() {
  local key="$1" prompt="$2" current input
  current=$(_existing "$key" || true)
  if [[ -n "$current" ]]; then
    printf '  %s%s%s %s[Enter keeps current]%s ' "$BOLD" "$prompt" "$RESET" "$DIM" "$RESET"
  else
    printf '  %s%s%s ' "$BOLD" "$prompt" "$RESET"
  fi
  read -rs input || true
  printf '\n'
  [[ -z "$input" && -n "$current" ]] && input="$current"
  printf -v "$key" '%s' "$input"
}

write_env() {
  local key="$1" value="$2" tmp
  touch "$ENV_FILE"
  tmp=$(mktemp)
  grep -vE "^${key}=" "$ENV_FILE" > "$tmp" || true
  printf '%s=%s\n' "$key" "$value" >> "$tmp"
  mv "$tmp" "$ENV_FILE"
  WRITTEN_ENV+=("$key")
  printf '  %s✓ wrote%s %s → %s\n' "$GREEN" "$RESET" "$key" "$ENV_FILE"
}

finish() {
  _clear
  printf '\n%s%s  ✓ Setup complete%s\n' "$BOLD" "$GREEN" "$RESET"
  (( ${#WRITTEN_ENV[@]} )) && note "wrote ${#WRITTEN_ENV[@]} value(s) to $ENV_FILE: ${WRITTEN_ENV[*]}"
  printf '\n'
}

# ──────────────────────────────────────────────────────────────────────────
# STAGES
# ──────────────────────────────────────────────────────────────────────────

banner "GitHub OAuth for BB Connect (local dev)"

# ── Stage 1: Create GitHub OAuth App ──────────────────────────────────────
stage "Create GitHub OAuth App" 3
say "You'll create a GitHub OAuth App for local development."
say ""
step "Open the GitHub OAuth Apps settings page:"
open_url "https://github.com/settings/applications/new"
say ""
step "Fill in the form:"
note "  Application name:  BB Connect (local dev)"
note "  Homepage URL:      http://localhost:5173"
note "  Authorization callback URL: http://localhost:5173/api/auth/callback/github"
say ""
step "Click 'Register application'"
pause "Click Register, then press Enter"

# ── Stage 2: Capture Client ID ────────────────────────────────────────────
stage "Copy Client ID" 1
say "On the app settings page, your Client ID is shown at the top."
step "Copy the Client ID (looks like Iv1.abc123...)"
ask GITHUB_CLIENT_ID "Paste the Client ID:"
write_env GITHUB_CLIENT_ID "$GITHUB_CLIENT_ID"

# ── Stage 3: Generate and copy Client Secret ──────────────────────────────
stage "Generate Client Secret" 1
say "Now generate a client secret."
step "Click 'Generate a new client secret'"
step "Copy the secret value (starts with a random hex string)"
note "  You won't be able to see it again after leaving the page!"
ask_secret GITHUB_CLIENT_SECRET "Paste the Client Secret:"
write_env GITHUB_CLIENT_SECRET "$GITHUB_CLIENT_SECRET"

# ──────────────────────────────────────────────────────────────────────────
finish
say "All done! Restart the web dev server to pick up the new secrets:"
note "  kill $(cat /tmp/bb-dev-web.pid) 2>/dev/null; cd apps/web && pnpm dev"
