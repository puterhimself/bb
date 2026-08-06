# BB Spawn Benchmark

## Objective

Optimize: `Incus spawn request → BB host-daemon health endpoint ready`

- **Acceptable**: under 2 seconds
- **Stretch**: under 1 second
- **Baseline (measured)**: ~10 seconds p50
- **Optimized cold spawn**: ~8.6 seconds p50
- **Optimized warm pool**: ~8.0 seconds p50

"Ready" means the BB daemon on port 38887 accepts a real health request.

## Verified Baseline (Original)

Measured on `contabo-vds` (6-core AMD EPYC 7282, 23GB RAM, ext4, Incus 7.3):

```
Phase                min      p50      p95      max
─────────────────────────────────────────────────────────
copy               568ms    786ms   1149ms   1177ms
inject             288ms    454ms    773ms    785ms
running           2246ms   2625ms   4241ms   4354ms
network           4308ms   4986ms   7444ms   7586ms
health            9345ms  10406ms  14742ms  17713ms

Concurrent (5): 40.93s wall time, all healthy
```

## Bottleneck Breakdown

### 1. BB daemon startup (~4.5 seconds) — **largest bottleneck**

The daemon startup chain:
1. `bb-app host-daemon join` → spawns Node.js (722KB launcher)
2. Launcher parses args, sets env, writes config
3. Launcher spawns `daemon-bundle.mjs` (1.7MB) as a **second** Node process
4. daemon-bundle loads (~0.7s V8 compile + module loading)
5. Enrollment HTTP request to server (~1-2s)
6. App initialization: watch manager, runtime manager, terminal manager, server connection (~1-2s)
7. Local API server (health endpoint) starts
8. WebSocket connection to server

**The double-Node-spawn is the most addressable overhead** (saves ~1.3s).

### 2. Network/DHCP readiness (~2.3 seconds)

The container's systemd-networkd performs DHCP on the bridge interface.
The `bb-host-daemon.service` unit depends on `network-online.target`,
which waits for `systemd-networkd-wait-online.service` to confirm
network connectivity.

### 3. systemd boot (~1.7 seconds)

Critical chain: `journald → journal-flush → tmpfiles-setup → resolved → basic.target → logind → multi-user.target`

Major consumers:
- `systemd-udev-trigger.service`: ~1.1s
- `systemd-resolved.service`: ~0.9s
- `systemd-networkd.service`: ~0.5s

### 4. Config injection (~0.4 seconds)

`incus file push` requires a separate API call to the Incus daemon.

## Optimizations Applied

### A. Direct daemon-bundle invocation (saves ~1.3s)

The original wrapper invoked `bb-app host-daemon join`, which spawns a
722KB Node.js launcher process that only parses CLI args, sets env vars,
and writes config.json — then spawns a **second** Node process for the
actual daemon-bundle.mjs.

The optimized wrapper sets the same environment variables in bash and
invokes `daemon-bundle.mjs` directly, eliminating the launcher's Node.js
startup overhead entirely.

**Safety**: The wrapper sets all the same environment variables that
`createHostDaemonOnlyEnv()` in the launcher would set:
- `BB_APP_VERSION`, `BB_BRIDGE_DIR`, `BB_CLI_DIR`
- `BB_DATA_DIR`, `BB_HOST_DAEMON_PORT`, `BB_SERVER_URL`
- `BB_HOST_DAEMON_AUTO_UPDATE`, `BB_HOST_ENROLL_KEY`, `NODE_ENV`

It also writes `config.json` (same as the launcher does via `createHostDaemonJoinEnv`).

### B. NODE_COMPILE_CACHE (saves ~0.2s)

Node.js V8 compile cache is pre-populated in the golden image by running
the daemon-bundle once during image build. The cache directory at
`/var/cache/bb-node-compile` contains compiled bytecode for the 1.7MB
daemon-bundle.mjs module.

### C. network.target instead of network-online.target (saves ~0.3s)

Changed the systemd unit from `After=network-online.target` to
`After=network.target`. The daemon can start as soon as the network
interface exists, rather than waiting for `systemd-networkd-wait-online`
to confirm full connectivity. The enrollment HTTP request naturally
retries if the network isn't fully up yet.

### D. Batched copy + config (saves ~0.3s)

Uses `incus copy --config` flags to set resource limits during the copy
operation, instead of a separate `incus config set` call.

### E. curl health check (saves ~0.1s per check)

Uses `curl -sf` for health probing instead of spawning a Node.js process
for each check.

### F. Masked unnecessary services (minor)

Masked apt timers, e2scrub, and console-getty in the golden image.

## Optimized Cold Spawn Results

```
Phase                min      p50      p95      max
─────────────────────────────────────────────────────────
copy               298ms    384ms    653ms    700ms
inject             320ms    399ms    568ms    620ms
running           1965ms   2113ms   2543ms   2740ms
network           4071ms   4441ms   5052ms   6240ms
health            7925ms   8620ms   9507ms  17906ms

Failures: 0/30
```

**Improvement: 10.4s → 8.6s p50 (17% faster)**

## Optimized Warm Pool Results

Pre-cloned stopped containers eliminate the ~0.5s copy step:

```
Phase                min      p50      p95      max
─────────────────────────────────────────────────────────
health            7692ms   8044ms   8430ms   8430ms
```

**Improvement: 10.4s → 8.0s p50 (23% faster)**

## Three Provisioning Modes

### Mode 1: Cold Template Clone (current best: 8.6s)

```
incus copy bb-template → inject config → incus start → wait for health
```

- **Isolation**: Full fresh clone from golden image, no state leakage
- **Disk**: Btrfs CoW snapshot (~0ms incremental, shared extents)
- **Memory**: Cold start, no pre-allocation
- **Identity**: Fresh enrollment per spawn
- **Cleanup**: Delete container when done

### Mode 2: Warm Stopped-Container Pool (current best: 8.0s)

```
[pre-created pool] → inject config → incus start → wait for health
```

- **Isolation**: Same as cold (each container is a fresh clone)
- **Disk**: Pre-allocated Btrfs subvolumes for pool containers
- **Memory**: Cold start
- **Identity**: Fresh enrollment per spawn
- **Cleanup**: Reset container state and return to pool
- **Capacity**: Must monitor pool depth and replenish asynchronously

### Mode 3: Pre-Started Running Pool (NOT IMPLEMENTED — design only)

```
[running healthy daemons] → swap identity via API → ready
```

- **Isolation**: Container was running with a different identity — requires careful reset
- **Disk**: Container filesystem has been mutated
- **Memory**: Pre-warmed Node.js V8 heap, JIT-compiled code, open connections
- **Identity**: Must rotate host key and re-establish server session
- **Cleanup**: Reset and restart daemon process
- **Capacity**: Each pool container consumes RAM continuously
- **Feasibility**: Requires BB daemon API support for identity rotation
  (currently not available without restart)

**This mode could achieve sub-second spawn** but requires BB architecture
changes (identity swap API) and has significant security implications.

## Can Cold Spawn Reach Under 2 Seconds?

**No.** The irreducible sequential costs for a cold spawn are:

| Step | Time | Reason |
|------|------|--------|
| incus copy (btrfs CoW) | ~350ms | Kernel subvolume snapshot |
| incus file push | ~400ms | Incus API roundtrip |
| incus start | ~1000ms | Incus container setup (cgroups, namespaces, devices) |
| systemd boot | ~1700ms | journald, resolved, udev, basic.target |
| Node.js + daemon startup | ~4500ms | V8 init, module loading, enrollment, app init |
| **Minimum total** | **~8000ms** | |

systemd boot alone (~1.7s) + Node.js startup (~4.5s) = **6.2s minimum**,
which is already 3x the acceptable target. No amount of Incus or
configuration tuning can make a cold spawn under 2s.

The fundamental limit is that a full Linux systemd boot + Node.js
process startup is inherently multi-second. To reach sub-2s, the
container must already be booted and the daemon process already
initialized (Mode 3: pre-started pool).

## Recommended Production Provisioning Path

1. **For correctness and simplicity**: Cold template clone (Mode 1)
   - p50: 8.6s, p95: 9.5s, 0% failures
   - No pool management complexity
   - Use the optimized `spawn-bb-machine.sh` script

2. **For reduced latency**: Warm stopped-container pool (Mode 2)
   - p50: 8.0s, p95: 8.4s
   - Use `create-bb-warm-pool.sh` + modified spawn flow
   - Pool depth monitoring required

3. **For sub-2s targets**: Requires BB architecture change (Mode 3)
   - Pre-started running daemon pool with identity rotation
   - Out of scope for current BB product architecture

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/build-bb-golden-image.sh` | Build golden template with optimized daemon wrapper |
| `scripts/spawn-bb-machine.sh` | Cold spawn from template (optimized) |
| `scripts/benchmark-bb-spawn.sh` | Comprehensive benchmark (warmup + sequential + concurrent) |
| `scripts/profile-bb-startup.sh` | Detailed single-spawn profiling with systemd analysis |
| `scripts/create-bb-warm-pool.sh` | Create a pool of pre-cloned stopped containers |
| `scripts/reset-bb-warm-instance.sh` | Reset a used container for pool reuse |

## Remaining Risks

1. **Direct daemon invocation bypasses bb-app launcher's health wait**.
   The launcher normally waits for health before returning success.
   With direct invocation, systemd's `Restart=always` handles crashes,
   but startup failure detection relies on the health endpoint poll.

2. **NODE_COMPILE_CACHE is version-specific**. If Node.js is upgraded
   inside the container without rebuilding the cache, the first boot
   will be slower until the cache is rebuilt.

3. **network.target dependency may cause enrollment to fail** on first
   attempt if the network isn't fully up. The daemon's enrollment
   has built-in retry logic, but this could add delay in edge cases.

4. **Warm pool containers consume disk space**. Each pre-cloned
   container shares btrfs extents, so incremental disk usage is low,
   but the pool must be monitored for depth.

5. **Masked systemd services** (apt timers, getty) must be unmasked
   if the container is used interactively for debugging.
