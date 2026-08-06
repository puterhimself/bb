#!/usr/bin/env bash
#
# benchmark-bb-spawn.sh
#
# Benchmark BB machine spawn from golden image via copy-from-template.
# Measures: T0 → copy complete, → RUNNING, → network, → BB HTTP health.
#
# Usage:
#   ./scripts/benchmark-bb-spawn.sh [options]
#
# Required:
#   --bb-server-url   BB server URL
#   --join-code       bb machine join code (initial; each run mints its own)
#   --host-id         bb host ID
#
# Options:
#   --warmups         Number of warmup runs               [5]
#   --sequential      Number of sequential measured runs  [30]
#   --concurrent      Number of concurrent runs           [5]
#   --template        Template container to copy from     [bb-template]
#   --storage-pool    Incus storage pool                  [btrfs-fast]
#   --incus-project   Incus project                       [default]
#   --prefix          Container name prefix               [bench]
#
set -euo pipefail

# ─── Defaults ────────────────────────────────────────────────────────────────
BB_SERVER_URL=""
JOIN_CODE=""
HOST_ID=""
WARMUPS=5
SEQUENTIAL=30
CONCURRENT=5
TEMPLATE="bb-template"
STORAGE_POOL="btrfs-fast"
INCUS_PROJECT="default"
PREFIX="bench"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --bb-server-url)  BB_SERVER_URL="${2:?}"; shift 2 ;;
    --join-code)      JOIN_CODE="${2:?}"; shift 2 ;;
    --host-id)        HOST_ID="${2:?}"; shift 2 ;;
    --warmups)        WARMUPS="${2:?}"; shift 2 ;;
    --sequential)     SEQUENTIAL="${2:?}"; shift 2 ;;
    --concurrent)     CONCURRENT="${2:?}"; shift 2 ;;
    --template)       TEMPLATE="${2:?}"; shift 2 ;;
    --storage-pool)   STORAGE_POOL="${2:?}"; shift 2 ;;
    --incus-project)  INCUS_PROJECT="${2:?}"; shift 2 ;;
    --prefix)         PREFIX="${2:?}"; shift 2 ;;
    -h|--help)        sed -n '2,/^$/p' "$0" | sed 's/^# \?//'; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done

[ -n "$BB_SERVER_URL" ] || { echo "ERROR: --bb-server-url required" >&2; exit 2; }
[ -n "$JOIN_CODE" ]     || { echo "ERROR: --join-code required" >&2; exit 2; }
[ -n "$HOST_ID" ]       || { echo "ERROR: --host-id required" >&2; exit 2; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SPAWN_SCRIPT="${SCRIPT_DIR}/spawn-bb-machine.sh"
RESULTS_DIR=$(mktemp -d)

log()  { printf '\033[32m●\033[0m %s\n' "$*"; }

mint_join_code() {
  BB_SERVER_URL="$BB_SERVER_URL" bb machine join-code --json 2>/dev/null \
    | jq -r '.joinCode + " " + .hostId'
}

delete_container() {
  incus delete "$1" --project "$INCUS_PROJECT" --force 2>/dev/null || true
}

# ─── Header ──────────────────────────────────────────────────────────────────
echo "═════════════════════════════════════════════════════════"
echo "  BB Spawn Benchmark"
echo "═════════════════════════════════════════════════════════"
echo "  Template:    ${TEMPLATE}"
echo "  Storage:     ${STORAGE_POOL} ($(incus storage show "$STORAGE_POOL" 2>/dev/null | grep '^  driver' | awk '{print $2}'))"
echo "  Warmups:     ${WARMUPS}"
echo "  Sequential:  ${SEQUENTIAL}"
echo "  Concurrent:  ${CONCURRENT}"
echo "  Server:      ${BB_SERVER_URL}"
echo "  CPU:         $(nproc) cores"
echo "  Mem:         $(free -h | awk '/^Mem:/{print $2}')"
echo "  Disk:        $(df -h / | awk 'NR==2{print $2" total, "$4" free"}')"
echo "  Image size:  $(incus image info bbruntime-latest --project "$INCUS_PROJECT" 2>/dev/null | grep '^Size:' | awk '{print $2, $3}')"
echo "═════════════════════════════════════════════════════════"
echo ""

# ─── Warmup runs ─────────────────────────────────────────────────────────────
log "Phase 1: ${WARMUPS} warmup runs..."
for i in $(seq 1 "$WARMUPS"); do
  NAME="${PREFIX}-warm-${i}"
  read -r JC HID <<< "$(mint_join_code)"
  "$SPAWN_SCRIPT" \
    --bb-server-url "$BB_SERVER_URL" \
    --join-code "$JC" --host-id "$HID" \
    --template "$TEMPLATE" --storage-pool "$STORAGE_POOL" \
    --incus-project "$INCUS_PROJECT" --name "$NAME" \
    --json > /dev/null 2>&1 || true
  delete_container "$NAME"
  printf "\r  warmup %d/%d" "$i" "$WARMUPS"
done
echo " done"
echo ""

# ─── Sequential measured runs ────────────────────────────────────────────────
log "Phase 2: ${SEQUENTIAL} sequential measured runs..."
SEQ_FILE="${RESULTS_DIR}/sequential.jsonl"
> "$SEQ_FILE"

for i in $(seq 1 "$SEQUENTIAL"); do
  NAME="${PREFIX}-seq-${i}"
  read -r JC HID <<< "$(mint_join_code)"
  RESULT=$("$SPAWN_SCRIPT" \
    --bb-server-url "$BB_SERVER_URL" \
    --join-code "$JC" --host-id "$HID" \
    --template "$TEMPLATE" --storage-pool "$STORAGE_POOL" \
    --incus-project "$INCUS_PROJECT" --name "$NAME" \
    --json 2>/dev/null || true)
  # Ensure valid JSON even on failure
  RESULT=$(echo "$RESULT" | jq -c '.' 2>/dev/null || echo '{"health_ok":0,"health_ms":99999}')
  echo "$RESULT" >> "$SEQ_FILE"
  delete_container "$NAME"
  HEALTH=$(echo "$RESULT" | jq -r '.health_ok // 0')
  H_MS=$(echo "$RESULT" | jq -r '.health_ms // 99999')
  printf "\r  run %2d/%d  health=%ss  %s" "$i" "$SEQUENTIAL" \
    "$(awk "BEGIN{printf \"%.2f\", ${H_MS:-99999}/1000}")" \
    "$([ "$HEALTH" = "1" ] && echo "✅" || echo "❌")"
done
echo ""
echo ""

# ─── Concurrent runs ─────────────────────────────────────────────────────────
log "Phase 3: ${CONCURRENT} concurrent runs..."
CONC_FILE="${RESULTS_DIR}/concurrent.jsonl"
CONC_PIDS=()

CONC_T0=$(date +%s%3N)
for i in $(seq 1 "$CONCURRENT"); do
  NAME="${PREFIX}-conc-${i}"
  read -r JC HID <<< "$(mint_join_code)"
  (
    RESULT=$("$SPAWN_SCRIPT" \
      --bb-server-url "$BB_SERVER_URL" \
      --join-code "$JC" --host-id "$HID" \
      --template "$TEMPLATE" --storage-pool "$STORAGE_POOL" \
      --incus-project "$INCUS_PROJECT" --name "$NAME" \
      --json 2>/dev/null || echo '{}')
    echo "$RESULT" >> "${CONC_FILE}.tmp.${i}"
  ) &
  CONC_PIDS+=($!)
done
for pid in "${CONC_PIDS[@]}"; do wait "$pid"; done
CONC_T1=$(date +%s%3N)

for i in $(seq 1 "$CONCURRENT"); do
  [ -f "${CONC_FILE}.tmp.${i}" ] && cat "${CONC_FILE}.tmp.${i}" >> "$CONC_FILE"
done
for i in $(seq 1 "$CONCURRENT"); do
  delete_container "${PREFIX}-conc-${i}"
done

CONC_WALL=$(awk "BEGIN{printf \"%.2f\", (${CONC_T1}-${CONC_T0})/1000}")
CONC_OK=$(jq -r 'select(.health_ok==1)' "$CONC_FILE" 2>/dev/null | wc -l | tr -d ' ')
echo "  concurrent wall time: ${CONC_WALL}s  (${CONC_OK}/${CONCURRENT} healthy)"
echo ""

# ─── Compute statistics ──────────────────────────────────────────────────────
compute_stats() {
  local file="$1" field="$2"
  jq -r ".${field} | numbers" "$file" 2>/dev/null | \
  sort -n | awk -v f="$field" '
    { vals[NR]=$1; sum+=$1 }
    END {
      n=NR; if(n==0){printf "  %-22s n=0\n",f; exit}
      min=vals[1]; max=vals[n]
      if(n%2==1) p50=vals[int(n/2)+1]; else p50=(vals[n/2]+vals[n/2+1])/2
      p95idx=int(n*0.95+0.5); if(p95idx<1)p95idx=1; if(p95idx>n)p95idx=n
      p95=vals[p95idx]
      mean=sum/n
      printf "  %-22s min=%.0fms  p50=%.0fms  p95=%.0fms  max=%.0fms  mean=%.0fms  n=%d\n", f, min, p50, p95, max, mean, n
    }'
}

echo "═════════════════════════════════════════════════════════"
echo "  RESULTS — Sequential (${SEQUENTIAL} runs)"
echo "═════════════════════════════════════════════════════════"
echo ""
echo "Breakdown (ms from T0):"
compute_stats "$SEQ_FILE" "copy_ms"
compute_stats "$SEQ_FILE" "inject_ms"
compute_stats "$SEQ_FILE" "running_ms"
compute_stats "$SEQ_FILE" "network_ms"
compute_stats "$SEQ_FILE" "health_ms"
echo ""
FAILURES=$(jq -r 'select(.health_ok!=1)' "$SEQ_FILE" 2>/dev/null | wc -l | tr -d ' ')
echo "  Failures: ${FAILURES}/${SEQUENTIAL}"
echo ""

echo "═════════════════════════════════════════════════════════"
echo "  RESULTS — Concurrent (${CONCURRENT} parallel)"
echo "═════════════════════════════════════════════════════════"
echo ""
echo "  Wall time (all ${CONCURRENT} ready): ${CONC_WALL}s"
compute_stats "$CONC_FILE" "health_ms"
echo ""

echo "═════════════════════════════════════════════════════════"
echo "  Raw data: ${SEQ_FILE}"
echo "═════════════════════════════════════════════════════════"
