#!/usr/bin/env bash
#
# contabo-vds cleanup functions — BB machines, Docker, Zopu/Rivet, Incus
# Idempotent. Default: DRY_RUN=1 (preview). Set DRY_RUN=0 to execute.
#
# Usage:
#   ssh contabo-vds 'bash -s' < vds-cleanup.sh    # dry-run overview
#   ssh contabo-vds 'DRY_RUN=0 bash -s' < vds-cleanup.sh  # execute all
#
# Or source on the VDS:
#   source vds-cleanup.sh
#   vds_cleanup_overview          # preview everything
#   DRY_RUN=0 vds_cleanup_all     # execute everything

set -euo pipefail

DRY_RUN="${DRY_RUN:-1}"
export BB_SERVER_URL="${BB_SERVER_URL:-http://localhost:38886}"

# ═══ Internal helper ════════════════════════════════════════════════════════
_run() {
  echo "  >> $*"
  if [ "$DRY_RUN" = "0" ]; then "$@"; fi
}

# ═══ PHASE 1: BB MACHINES & INSTANCES ═══════════════════════════════════════

# List all disconnected BB machine IDs (read-only)
bb_list_orphan_machines() {
  bb machine list --json 2>/dev/null \
    | jq -r '.[] | select(.status=="disconnected") | .id' 2>/dev/null || true
}

# Delete all disconnected BB machines
bb_delete_orphan_machines() {
  local ids count
  ids=$(bb_list_orphan_machines)
  count=$(echo "$ids" | grep -c . 2>/dev/null || echo 0)
  if [ "$count" -eq 0 ]; then echo "No orphaned machines."; return 0; fi
  echo "Found $count orphaned machines."
  if [ "$DRY_RUN" = "1" ]; then
    echo "[DRY RUN] Would remove $count machines."
    return 0
  fi
  local id removed=0
  for id in $ids; do
    bb machine remove "$id" --yes 2>/dev/null && removed=$((removed+1)) || true
  done
  echo "Removed $removed / $count machines."
}

# List ALL BB-related Incus instances across all projects (read-only)
bb_list_incus_instances() {
  incus list --all-projects --format csv -c pnst 2>/dev/null || true
}

# Stop and delete ALL BB-related Incus instances + projects
bb_delete_incus_instances() {
  local instances
  instances=$(incus list --all-projects --format csv -c pnst 2>/dev/null || true)
  if [ -z "$instances" ]; then echo "No Incus instances."; return 0; fi
  echo "Incus instances to delete:"
  echo "$instances" | sed 's/^/  /'
  if [ "$DRY_RUN" = "1" ]; then echo "[DRY RUN]"; return 0; fi
  # Stop + delete each instance
  while IFS=, read -r project name state type; do
    echo "Stopping $project/$name..."
    incus stop --project "$project" "$name" 2>/dev/null || true
    incus delete --project "$project" "$name" --force 2>/dev/null || true
  done <<< "$instances"
  # Delete empty non-default projects
  for proj in bb-spike zopu-5d8641e37a3be7a5; do
    if incus project list --format csv 2>/dev/null | grep -q "^$proj,"; then
      local cnt
      cnt=$(incus list --project "$proj" --format csv -c n 2>/dev/null | grep -c . || echo 0)
      if [ "$cnt" -eq 0 ]; then
        echo "Deleting empty project $proj..."
        incus project delete "$proj" 2>/dev/null || true
      fi
    fi
  done
}

# Kill all host-level BB processes
bb_stop_processes() {
  local pids
  pids=$(pgrep -f 'bb-app start|bb-app/server/dist/index.js|daemon-bundle.mjs|bb-parcel-watcher-child.mjs|bb-acp-bridge.mjs' 2>/dev/null || true)
  if [ -z "$pids" ]; then echo "No BB processes."; return 0; fi
  echo "BB process PIDs: $pids"
  if [ "$DRY_RUN" = "1" ]; then echo "[DRY RUN]"; return 0; fi
  echo "$pids" | xargs kill -TERM 2>/dev/null || true
  sleep 2
  echo "$pids" | xargs kill -KILL 2>/dev/null || true
}

# Uninstall bb-app npm global
bb_uninstall() {
  echo "Uninstalling bb-app..."
  _run npm uninstall -g bb-app 2>/dev/null || true
}

# ═══ PHASE 2: DOCKER CLEANUP ════════════════════════════════════════════════

docker_disk_usage() {
  docker system df -v 2>/dev/null || true
}

docker_list_all() {
  echo "=== CONTAINERS ==="
  docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" 2>/dev/null || true
  echo -e "\n=== IMAGES ==="
  docker images 2>/dev/null || true
  echo -e "\n=== NETWORKS ==="
  docker network ls 2>/dev/null || true
}

docker_full_nuke() {
  echo "=== Docker Full Nuke ==="
  # Stop + remove all containers
  local containers
  containers=$(docker ps -aq 2>/dev/null || true)
  if [ -n "$containers" ]; then
    echo "Stopping + removing containers..."
    _run docker stop $containers
    _run docker rm -f $containers
  fi
  # Remove all images
  _run docker rmi -f $(docker images -aq 2>/dev/null) 2>/dev/null || true
  # Remove custom networks
  _run docker network rm $(docker network ls --filter type=custom -q 2>/dev/null) 2>/dev/null || true
  # Prune build cache
  echo "Pruning build cache..."
  _run docker builder prune -a -f
  # Final prune
  _run docker system prune -a -f --volumes
  echo "=== Docker cleanup complete ==="
  docker system df 2>/dev/null || true
}

# ═══ PHASE 3: ZOPU + RIVET REMOVAL ══════════════════════════════════════════

zopu_stop_service() {
  echo "Stopping zopu-agents service..."
  _run systemctl stop zopu-agents 2>/dev/null || true
  _run systemctl disable zopu-agents 2>/dev/null || true
}

zopu_remove_dirs() {
  echo "Removing Zopu directories..."
  _run rm -rf /srv/zopu
  _run rm -rf /opt/zopu
  _run rm -f /etc/zopu/agents.env
  _run rm -f /etc/systemd/system/zopu-agents.service
  _run systemctl daemon-reload
}

zopu_remove_user() {
  echo "Removing zopu user..."
  _run userdel -r zopu 2>/dev/null || true
}

# ═══ PHASE 4: INCUS STORAGE CLEANUP ═════════════════════════════════════════

incus_clean_storage() {
  echo "Cleaning Incus storage..."
  # Remove orphaned images
  _run incus image prune 2>/dev/null || true
  # Remove storage pools if empty
  for pool in btrfs-fast default; do
    local used
    used=$(incus storage volume list "$pool" --format csv 2>/dev/null | grep -c . || echo 0)
    if [ "$used" -eq 0 ]; then
      echo "Removing empty pool $pool..."
      _run incus storage delete "$pool"
    else
      echo "Pool $pool still has $used volumes — keeping."
    fi
  done
}

# ═══ OVERVIEW & FULL CLEANUP ════════════════════════════════════════════════

vds_cleanup_overview() {
  local saved="$DRY_RUN"
  DRY_RUN=1
  echo "╔══════════════════════════════════════════════════╗"
  echo "║     contabo-vds CLEANUP OVERVIEW (DRY RUN)       ║"
  echo "╚══════════════════════════════════════════════════╝"
  echo ""
  echo "── Phase 1: BB Machines ──"
  local orphan_count
  orphan_count=$(bb_list_orphan_machines | grep -c . 2>/dev/null || echo 0)
  echo "  Orphaned machines: $orphan_count"
  echo ""
  echo "── Phase 1: Incus Instances ──"
  bb_list_incus_instances | sed 's/^/  /'
  echo ""
  echo "── Phase 2: Docker ──"
  docker system df 2>/dev/null | sed 's/^/  /' || true
  echo ""
  echo "── Phase 3: Zopu/Rivet ──"
  systemctl is-active zopu-agents 2>/dev/null && echo "  zopu-agents: active" || echo "  zopu-agents: inactive"
  du -sh /srv/zopu /opt/zopu 2>/dev/null | sed 's/^/  /' || true
  echo ""
  echo "── Disk Overview ──"
  du -sh /root /srv /opt /var/lib/docker /var/lib/incus 2>/dev/null | sed 's/^/  /' || true
  echo ""
  DRY_RUN="$saved"
}

vds_cleanup_all() {
  echo "╔══════════════════════════════════════════════════╗"
  echo "║  contabo-vds FULL CLEANUP  DRY_RUN=$DRY_RUN              ║"
  echo "╚══════════════════════════════════════════════════╝"
  echo ""
  echo "══ Phase 1: BB ══"
  bb_delete_orphan_machines
  bb_delete_incus_instances
  bb_stop_processes
  echo ""
  echo "══ Phase 2: Docker ══"
  docker_full_nuke
  echo ""
  echo "══ Phase 3: Zopu + Rivet ══"
  zopu_stop_service
  zopu_remove_dirs
  echo ""
  echo "══ Phase 4: Incus Storage ══"
  incus_clean_storage
  echo ""
  echo "╔══════════════════════════════════════════════════╗"
  echo "║              CLEANUP COMPLETE                    ║"
  echo "╚══════════════════════════════════════════════════╝"
  df -h /
}

# If script is executed (not sourced), run overview
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  vds_cleanup_overview
fi
