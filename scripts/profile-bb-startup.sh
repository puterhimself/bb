#!/usr/bin/env bash
#
# profile-bb-startup.sh — detailed startup profiling for BB container spawn.
#
# Spawns a container and instruments systemd journal + daemon logs to find
# exactly where time goes during the spawn → health-ready path.
#
# Usage:
#   ./scripts/profile-bb-startup.sh [options]
#
# Required:
#   --bb-server-url   BB server URL
#   --join-code       bb machine join code
#   --host-id         bb host ID
#
# Options:
#   --template        Template container           [bb-template]
#   --storage-pool    Incus storage pool           [btrfs-fast]
#   --keep            Keep the container for inspection
#
set -euo pipefail

# ─── Defaults ────────────────────────────────────────────────────────────────
BB_SERVER_URL=""
JOIN_CODE=""
HOST_ID=""
TEMPLATE="bb-template"
STORAGE_POOL="btrfs-fast"
KEEP=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --bb-server-url)  BB_SERVER_URL="${2:?}"; shift 2 ;;
    --join-code)      JOIN_CODE="${2:?}"; shift 2 ;;
    --host-id)        HOST_ID="${2:?}"; shift 2 ;;
    --template)       TEMPLATE="${2:?}"; shift 2 ;;
    --storage-pool)   STORAGE_POOL="${2:?}"; shift 2 ;;
    --keep)           KEEP=1; shift ;;
    -h|--help)        sed -n '2,/^$/p' "$0" | sed 's/^# \?//'; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done

[ -n "$BB_SERVER_URL" ] || { echo "ERROR: --bb-server-url is required" >&2; exit 2; }
[ -n "$JOIN_CODE" ]     || { echo "ERROR: --join-code is required" >&2; exit 2; }
[ -n "$HOST_ID" ]       || { echo "ERROR: --host-id is required" >&2; exit 2; }

CONTAINER_NAME="prof-$(date +%s)-$$"

now_ms() { date +%s%3N; }

printf '\033[32m●\033[0m Profiling spawn of %s from %s\n' "$CONTAINER_NAME" "$TEMPLATE"

T0=$(now_ms)

# ─── Step 1: Copy ────────────────────────────────────────────────────────────
incus copy "$TEMPLATE" "$CONTAINER_NAME" -s "$STORAGE_POOL" \
  -c limits.cpu=2 -c limits.memory=2GiB -c limits.processes=512 \
  -c boot.autostart=true >&2
T_COPY=$(now_ms)

# ─── Step 2: Inject config ───────────────────────────────────────────────────
CONFIG_DIR=$(mktemp -d)
cat > "${CONFIG_DIR}/first-boot.env" <<EOF
BB_SERVER_URL=${BB_SERVER_URL}
BB_JOIN_CODE=${JOIN_CODE}
BB_HOST_ID=${HOST_ID}
EOF
incus file push "${CONFIG_DIR}/first-boot.env" \
  "${CONTAINER_NAME}/etc/bb/first-boot.env" --mode 0600 >&2
rm -rf "$CONFIG_DIR"
T_INJECT=$(now_ms)

# ─── Step 3: Start ───────────────────────────────────────────────────────────
incus start "$CONTAINER_NAME" >&2
T_START=$(now_ms)

# ─── Step 4: Wait for RUNNING ────────────────────────────────────────────────
for i in $(seq 1 60); do
  STATUS=$(incus list "$CONTAINER_NAME" -f csv -c s 2>/dev/null || echo "")
  [ "$STATUS" = "RUNNING" ] && break
  sleep 0.05
done
T_RUNNING=$(now_ms)

# ─── Step 5: Wait for network ────────────────────────────────────────────────
for i in $(seq 1 60); do
  IP=$(incus list "$CONTAINER_NAME" -f csv -c 4 2>/dev/null | head -1 || echo "")
  [ -n "$IP" ] && [ "$IP" != "0.0.0.0" ] && break
  sleep 0.05
done
T_NETWORK=$(now_ms)

# ─── Step 6: Wait for health ─────────────────────────────────────────────────
HEALTH_OK=0
for i in $(seq 1 120); do
  if incus exec "$CONTAINER_NAME" -- bash -c "curl -sf http://localhost:38887/health >/dev/null 2>&1"; then
    HEALTH_OK=1
    break
  fi
  sleep 0.05
done
T_HEALTH=$(now_ms)

# ─── Report ──────────────────────────────────────────────────────────────────
echo ""
echo "═════════════════════════════════════════════════════════"
echo "  External Timing (from host)"
echo "═════════════════════════════════════════════════════════"
printf "  copy:       %5d ms\n" $((T_COPY - T0))
printf "  inject:     %5d ms\n" $((T_INJECT - T_COPY))
printf "  start cmd:  %5d ms\n" $((T_START - T_INJECT))
printf "  RUNNING:    %5d ms (from T0)\n" $((T_RUNNING - T0))
printf "  network:    %5d ms (from T0)\n" $((T_NETWORK - T0))
printf "  health:     %5d ms (from T0)\n" $((T_HEALTH - T0))
printf "  health_ok:  %s\n" "$([ $HEALTH_OK -eq 1 ] && echo YES || echo NO)"
echo ""

echo "═════════════════════════════════════════════════════════"
echo "  systemd-analyze"
echo "═════════════════════════════════════════════════════════"
incus exec "$CONTAINER_NAME" -- systemd-analyze 2>/dev/null
echo ""

echo "═════════════════════════════════════════════════════════"
echo "  systemd critical-chain"
echo "═════════════════════════════════════════════════════════"
incus exec "$CONTAINER_NAME" -- systemd-analyze critical-chain 2>/dev/null
echo ""

echo "═════════════════════════════════════════════════════════"
echo "  systemd-analyze blame (top 15)"
echo "═════════════════════════════════════════════════════════"
incus exec "$CONTAINER_NAME" -- systemd-analyze blame 2>/dev/null | head -15
echo ""

echo "═════════════════════════════════════════════════════════"
echo "  bb-host-daemon Journal"
echo "═════════════════════════════════════════════════════════"
incus exec "$CONTAINER_NAME" -- journalctl -u bb-host-daemon.service -b --no-pager -o short-precise 2>/dev/null
echo ""

if [ "$KEEP" -eq 0 ]; then
  incus delete "$CONTAINER_NAME" --force 2>/dev/null || true
  echo "Container deleted (use --keep to retain)"
else
  echo "Container retained: $CONTAINER_NAME"
fi
