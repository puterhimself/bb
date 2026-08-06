#!/usr/bin/env bash
#
# create-bb-warm-pool.sh — pre-create a pool of stopped containers
#
# A warm pool eliminates the incus copy time (~0.5s) from the spawn path.
# Containers are pre-cloned from the template with resource limits set,
# ready for config injection + start.
#
# Trade-offs:
#   + Eliminates ~0.5s copy time per spawn
#   + Eliminates config set overhead (limits baked in)
#   - Requires disk space for each pre-cloned container (~440MB CoW each)
#   - Requires monitoring pool depth and replenishing
#   - Pre-cloned containers must be cleaned up when stale
#
# Usage:
#   ./scripts/create-bb-warm-pool.sh [options]
#
# Options:
#   --pool-size       Number of containers to pre-create  [3]
#   --template        Template container to copy from     [bb-template]
#   --storage-pool    Incus storage pool                  [btrfs-fast]
#   --incus-project   Incus project                       [default]
#   --prefix          Container name prefix               [bb-warm]
#   --cpu-limit       CPU limit                           [2]
#   --memory-limit    Memory limit                        [2GiB]
#   --process-limit   Process limit                       [512]
#   --clean           Remove all existing pool containers first
#
set -euo pipefail

# ─── Defaults ────────────────────────────────────────────────────────────────
POOL_SIZE=3
TEMPLATE="bb-template"
STORAGE_POOL="btrfs-fast"
INCUS_PROJECT="default"
PREFIX="bb-warm"
CPU_LIMIT="2"
MEMORY_LIMIT="2GiB"
PROCESS_LIMIT="512"
CLEAN=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --pool-size)      POOL_SIZE="${2:?}"; shift 2 ;;
    --template)       TEMPLATE="${2:?}"; shift 2 ;;
    --storage-pool)   STORAGE_POOL="${2:?}"; shift 2 ;;
    --incus-project)  INCUS_PROJECT="${2:?}"; shift 2 ;;
    --prefix)         PREFIX="${2:?}"; shift 2 ;;
    --cpu-limit)      CPU_LIMIT="${2:?}"; shift 2 ;;
    --memory-limit)   MEMORY_LIMIT="${2:?}"; shift 2 ;;
    --process-limit)  PROCESS_LIMIT="${2:?}"; shift 2 ;;
    --clean)          CLEAN=1; shift ;;
    -h|--help)        sed -n '2,/^$/p' "$0" | sed 's/^# \?//'; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done

log() { printf '\033[32m●\033[0m %s\n' "$*"; }

# ─── Clean existing pool ─────────────────────────────────────────────────────
if [ "$CLEAN" -eq 1 ]; then
  log "Cleaning existing pool containers..."
  EXISTING=$(incus list "$PREFIX-" --project "$INCUS_PROJECT" -c n -f csv 2>/dev/null | grep "^${PREFIX}-" || true)
  if [ -n "$EXISTING" ]; then
    echo "$EXISTING" | while read -r name; do
      incus delete "$name" --project "$INCUS_PROJECT" --force 2>/dev/null || true
      printf "  deleted %s\n" "$name"
    done
  fi
fi

# ─── Count current pool size ─────────────────────────────────────────────────
CURRENT=$(incus list "$PREFIX-" --project "$INCUS_PROJECT" -f csv -c ns 2>/dev/null | grep "^${PREFIX}-.*STOPPED" | wc -l | tr -d ' ')
NEEDED=$((POOL_SIZE - CURRENT))

if [ "$NEEDED" -le 0 ]; then
  log "Pool already has $CURRENT stopped containers (target: $POOL_SIZE)"
  exit 0
fi

log "Pool has $CURRENT stopped containers, creating $NEEDED more..."

for i in $(seq 1 "$NEEDED"); do
  NAME="${PREFIX}-$(date +%s)-${i}-$$"
  incus copy "$TEMPLATE" "$NAME" \
    --project "$INCUS_PROJECT" -s "$STORAGE_POOL" \
    -c limits.cpu="$CPU_LIMIT" \
    -c limits.memory="$MEMORY_LIMIT" \
    -c limits.processes="$PROCESS_LIMIT" \
    -c boot.autostart=true >&2 2>/dev/null
  printf "  created %s\n" "$NAME"
done

TOTAL=$(incus list "$PREFIX-" --project "$INCUS_PROJECT" -f csv -c ns 2>/dev/null | grep "^${PREFIX}-.*STOPPED" | wc -l | tr -d ' ')
log "Pool ready: $TOTAL stopped containers available"
