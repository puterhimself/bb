#!/usr/bin/env bash
#
# build-bb-golden-image.sh
#
# Build a BB golden image: a minimal Debian system container with everything
# needed to run a BB host daemon preinstalled, so per-user provisioning is
# just copy-from-image + inject-config + start. No apt/npm/downloads during
# user provisioning.
#
# Usage:
#   ./scripts/build-bb-golden-image.sh [options]
#
# Options:
#   --bb-server-url   BB server URL (for downloading bb-app.tgz)  [required]
#   --storage-pool    Incus storage pool to build on              [btrfs-fast]
#   --incus-project   Incus project                               [default]
#   --builder-name    Builder container name                      [bb-image-builder]
#   --base-image      Base OS image                               [debian/12]
#   --pi-version      Pi npm version spec                         [latest]
#   --node-major      Node.js major version                       [22]
#   --tag             Image tag (default: auto git-sha + date)
#   --no-clean        Skip cleanup before publish (debugging)
#   --no-publish      Skip publish (debugging, leaves builder running)
#   -h|--help         Show help
#
set -euo pipefail

# ─── Defaults ────────────────────────────────────────────────────────────────
BB_SERVER_URL=""
STORAGE_POOL="btrfs-fast"
INCUS_PROJECT="default"
BUILDER_NAME="bb-image-builder"
BASE_IMAGE="debian/12"
PI_VERSION="latest"
NODE_MAJOR="22"
TAG=""
CLEAN=1
PUBLISH=1

usage() {
  sed -n '2,/^$/p' "$0" | sed 's/^# \?//' >&2
  exit 2
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --bb-server-url)  BB_SERVER_URL="${2:?}"; shift 2 ;;
    --storage-pool)   STORAGE_POOL="${2:?}"; shift 2 ;;
    --incus-project)  INCUS_PROJECT="${2:?}"; shift 2 ;;
    --builder-name)   BUILDER_NAME="${2:?}"; shift 2 ;;
    --base-image)     BASE_IMAGE="${2:?}"; shift 2 ;;
    --pi-version)     PI_VERSION="${2:?}"; shift 2 ;;
    --node-major)     NODE_MAJOR="${2:?}"; shift 2 ;;
    --tag)            TAG="${2:?}"; shift 2 ;;
    --no-clean)       CLEAN=0; shift ;;
    --no-publish)     PUBLISH=0; shift ;;
    -h|--help)        usage ;;
    *) echo "Unknown option: $1" >&2; usage ;;
  esac
done

[ -n "$BB_SERVER_URL" ] || { echo "ERROR: --bb-server-url is required" >&2; usage; }

# ─── Helpers ─────────────────────────────────────────────────────────────────
log()  { printf '\033[32m●\033[0m %s\n' "$*"; }
warn() { printf '\033[33m●\033[0m %s\n' "$*" >&2; }

incus_exec() {
  incus exec "$BUILDER_NAME" --project "$INCUS_PROJECT" -- "$@"
}

# ─── Step 0: Resolve tag ─────────────────────────────────────────────────────
if [ -z "$TAG" ]; then
  DATE_TAG=$(date +%Y%m%d-%H%M%S)
  GIT_SHA=$(git rev-parse --short=10 HEAD 2>/dev/null || echo "nogit")
  TAG="${GIT_SHA}-${DATE_TAG}"
fi
log "Building golden image → bb-runtime:${TAG} (and :latest)"

# ─── Step 1: Create builder container ────────────────────────────────────────
# Clean up any existing builder first
if incus list "$BUILDER_NAME" --project "$INCUS_PROJECT" -f csv -c n 2>/dev/null | grep -q "^${BUILDER_NAME}$"; then
  warn "Removing existing builder container"
  incus delete "$BUILDER_NAME" --project "$INCUS_PROJECT" --force
fi

log "Creating builder container from ${BASE_IMAGE} on pool ${STORAGE_POOL}"
incus init "images:${BASE_IMAGE}" "$BUILDER_NAME" \
  --project "$INCUS_PROJECT" -s "$STORAGE_POOL" \
  -c limits.cpu=4 -c limits.memory=4GiB

incus start "$BUILDER_NAME" --project "$INCUS_PROJECT"
log "Waiting for network..."
for i in $(seq 1 30); do
  incus_exec ip -4 addr show eth0 2>/dev/null | grep -q "inet " && break
  sleep 1
  [ "$i" -eq 30 ] && { echo "ERROR: builder did not get network" >&2; exit 1; }
done
log "Network up"

# ─── Step 2: Install base packages ───────────────────────────────────────────
log "Installing base packages (apt)..."
incus_exec bash -c '
  export DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a
  apt-get update -qq
  apt-get install -y -qq git curl ca-certificates build-essential unzip jq systemd-sysv dbus
'

# ─── Step 3: Install Node.js ─────────────────────────────────────────────────
log "Installing Node.js ${NODE_MAJOR}.x..."
incus_exec bash -c "
  curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash -
  apt-get install -y -qq nodejs
"
NODE_VER=$(incus_exec node --version 2>/dev/null)
log "Node installed: ${NODE_VER}"

# ─── Step 4: Install pnpm ────────────────────────────────────────────────────
log "Installing pnpm..."
incus_exec npm install -g pnpm@11 2>&1 | tail -1

# ─── Step 5: Install Pi ──────────────────────────────────────────────────────
log "Installing Pi..."
incus_exec npm install -g "@earendil-works/pi-coding-agent@${PI_VERSION}" 2>&1 | tail -1
PI_VER=$(incus_exec pi --version 2>/dev/null || echo "unknown")
log "Pi installed: ${PI_VER}"

# ─── Step 6: Install bb-app from server artifact ─────────────────────────────
# Resolve the Incus bridge gateway — the container can't reach the host's
# localhost; the gateway IP (e.g. 10.46.168.1) is directly reachable.
GATEWAY_IP=$(incus_exec bash -c "ip route show default | awk '{print \$3}'" 2>/dev/null | head -1)
BB_PORT=$(echo "$BB_SERVER_URL" | sed -n 's|.*:\([0-9]*\).*|\1|p')
BB_PORT="${BB_PORT:-38886}"
if [ -n "$GATEWAY_IP" ]; then
  INTERNAL_URL="http://${GATEWAY_IP}:${BB_PORT}"
  log "Using gateway URL for bb-app download: ${INTERNAL_URL}"
else
  INTERNAL_URL="$BB_SERVER_URL"
fi
log "Installing bb-app from ${INTERNAL_URL}/install/bb-app.tgz..."
incus_exec bash -c "
  curl -fsSL '${INTERNAL_URL}/install/bb-app.tgz' -o /tmp/bb-app.tgz
  npm install -g /tmp/bb-app.tgz
  rm -f /tmp/bb-app.tgz
"
BB_VER=$(incus_exec bash -c 'node -e "console.log(require(\"/usr/lib/node_modules/bb-app/package.json\").version)"' 2>/dev/null)
log "bb-app installed: ${BB_VER}"

# ─── Step 7: Create workspace directory ──────────────────────────────────────
incus_exec mkdir -p /workspace
incus_exec chmod 1777 /workspace

# ─── Step 8: Install the workspace startup script and systemd service ──────
#
# The self-contained wrapper (bb-workspace-start.sh) runs bb-app start
# (full stack: server + web UI + auto-enrolled daemon), waits for server
# health, then auto-pairs Connect using the injected first-boot.env.
#
# first-boot.env (injected per-workspace at spawn time) contains:
#   BB_CONNECT_CODE=<connect-pair-code>
#   BB_CONNECT_SERVER_URL=https://<subdomain>.<base_domain>

log "Installing workspace startup script and systemd service..."

incus_exec bash -c 'mkdir -p /etc/bb'

incus_exec bash -c 'cat > /usr/local/sbin/bb-workspace-start.sh <<'\''SCRIPT'\''
#!/usr/bin/env bash
# bb-workspace-start.sh — self-contained workspace: bb-app start + auto-connect
set -euo pipefail

CONFIG=/etc/bb/first-boot.env

# Start bb-app (server + daemon, auto-enrolls locally)
bb-app start &
BB_PID=$!

# Wait for server health (port 38886)
for i in $(seq 1 120); do
  if curl -sf http://localhost:38886 >/dev/null 2>&1; then
    echo "bb server is healthy"
    break
  fi
  sleep 0.5
done

# Auto-pair Connect if configured
if [ -f "$CONFIG" ]; then
  source "$CONFIG"
  if [ -n "${BB_CONNECT_CODE:-}" ] && [ -n "${BB_CONNECT_SERVER_URL:-}" ]; then
    echo "Auto-pairing connect: ${BB_CONNECT_SERVER_URL}"
    bb connect --code "$BB_CONNECT_CODE" --server "$BB_CONNECT_SERVER_URL" 2>&1 || \
      echo "WARNING: connect auto-pair failed (will need manual pairing)"
  fi
fi

# Wait for bb-app process
wait $BB_PID
SCRIPT
chmod +x /usr/local/sbin/bb-workspace-start.sh'

incus_exec bash -c 'cat > /etc/systemd/system/bb-workspace.service <<'\''UNIT'\''
[Unit]
Description=bb workspace (server + daemon + connect)
After=network.target
Wants=network.target
ConditionPathExists=/etc/bb/first-boot.env

[Service]
ExecStart=/usr/local/sbin/bb-workspace-start.sh
Restart=always
RestartSec=2
WorkingDirectory=/workspace

[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable bb-workspace.service'

# ─── Step 9: Cleanup (if enabled) ────────────────────────────────────────────
if [ "$CLEAN" -eq 1 ]; then
  log "Cleaning image (caches, identity, runtime state)..."

  incus_exec bash -c '
    # Package caches
    apt-get clean
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb

    # npm caches
    npm cache clean --force 2>/dev/null || true
    rm -rf /root/.npm /root/.cache/pnpm /root/.pnpm-store

    # Logs
    find /var/log -type f -delete 2>/dev/null || true
    journalctl --rotate 2>/dev/null || true
    journalctl --vacuum-time=1s 2>/dev/null || true

    # Machine identity / SSH host keys
    rm -f /etc/ssh/ssh_host_*_key* /etc/machine-id
    [ -f /etc/machine-id ] || touch /etc/machine-id

    # BB runtime state (must be fresh per user)
    rm -rf /root/.bb-machines /root/.bb /tmp/*

    # Pi temp
    rm -rf /tmp/.pi* 2>/dev/null || true

    # Shell history
    rm -f /root/.bash_history /root/.node_repl_history

    # Cloud-init leftovers (if any)
    rm -rf /var/lib/cloud /var/log/cloud-init* 2>/dev/null || true
  '
  log "Cleanup complete"
fi

# ─── Step 10: Publish ────────────────────────────────────────────────────────
if [ "$PUBLISH" -eq 1 ]; then
  log "Stopping builder for publish..."
  incus stop "$BUILDER_NAME" --project "$INCUS_PROJECT" --force

  # Note: Incus alias names cannot contain ":" (parsed as remote:alias).
  # Use hyphenated names: bbruntime-latest, bbruntime-<tag>
  log "Publishing as bbruntime-${TAG} and bbruntime-latest..."
  incus publish "$BUILDER_NAME" --project "$INCUS_PROJECT" \
    --alias "bbruntime-${TAG}" \
    --alias "bbruntime-latest" --reuse \
    --compression zstd 2>&1 | tail -5

  log "Published. Cleaning up builder..."
  incus delete "$BUILDER_NAME" --project "$INCUS_PROJECT" --force

  echo ""
  echo "═════════════════════════════════════════════════════════"
  echo "  Golden image built"
  echo "═════════════════════════════════════════════════════════"
  incus image list "bbruntime" --project "$INCUS_PROJECT"
  echo ""
  echo "  Aliases: bbruntime-${TAG}, bbruntime-latest"
  echo ""
  echo "  Size:"
  incus image info "bbruntime-latest" --project "$INCUS_PROJECT" | grep -E "Size|Fingerprint" | head -2
  echo "═════════════════════════════════════════════════════════"
else
  warn "Skipping publish (--no-publish). Builder left running for inspection."
  warn "  incus exec ${BUILDER_NAME} --project ${INCUS_PROJECT} -- bash"
fi
