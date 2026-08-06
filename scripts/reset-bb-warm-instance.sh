#!/usr/bin/env bash
#
# reset-bb-warm-instance.sh — reset a used BB container for pool reuse
#
# After a BB container has been used (started, daemon enrolled, data written),
# it must be reset before it can be returned to the warm pool for another user.
# This script:
#   1. Stops the container (if running)
#   2. Removes per-user state (auth.json, data dir, first-boot.env)
#   3. The container is now clean and stopped, ready for pool reuse
#
# Usage:
#   ./scripts/reset-bb-warm-instance.sh <container-name>
#
set -euo pipefail

CONTAINER="${1:?Usage: $0 <container-name>}"
INCUS_PROJECT="${2:-default}"

log() { printf '\033[32m●\033[0m %s\n' "$*"; }

# ─── Verify container exists ─────────────────────────────────────────────────
if ! incus list "$CONTAINER" --project "$INCUS_PROJECT" -c n -f csv 2>/dev/null | grep -q "^${CONTAINER}$"; then
  echo "ERROR: Container '$CONTAINER' not found" >&2
  exit 1
fi

# ─── Stop if running ─────────────────────────────────────────────────────────
STATUS=$(incus list "$CONTAINER" --project "$INCUS_PROJECT" -f csv -c s 2>/dev/null)
if [ "$STATUS" = "RUNNING" ]; then
  log "Stopping $CONTAINER..."
  incus stop "$CONTAINER" --project "$INCUS_PROJECT" --force >&2
fi

# ─── Remove per-user state ───────────────────────────────────────────────────
log "Removing per-user state..."

# Remove first-boot config
incus exec "$CONTAINER" --project "$INCUS_PROJECT" -- rm -f /etc/bb/first-boot.env 2>/dev/null || true

# Remove BB machine data directories
incus exec "$CONTAINER" --project "$INCUS_PROJECT" -- rm -rf /root/.bb-machines 2>/dev/null || true

# Remove any host-id persistence
incus exec "$CONTAINER" --project "$INCUS_PROJECT" -- rm -f /root/.bb/host-id 2>/dev/null || true

# Clear /tmp
incus exec "$CONTAINER" --project "$INCUS_PROJECT" -- bash -c 'rm -rf /tmp/* 2>/dev/null || true' 2>/dev/null || true

# Clear workspace
incus exec "$CONTAINER" --project "$INCUS_PROJECT" -- bash -c 'rm -rf /workspace/* 2>/dev/null || true' 2>/dev/null || true

log "Container $CONTAINER reset — ready for pool reuse"
