---
name: incus
description: Incus operations and reference for this project. Use when creating, cloning, starting, stopping, configuring, networking, storing, snapshotting, benchmarking, debugging, or securing Incus containers and VMs; when investigating BB spawn performance on contabo-vds; or when an Incus CLI/API/configuration detail needs verification against the cached upstream docs.
---

# Incus

Use this project-local reference for Incus work. It contains a complete cached snapshot of the Incus documentation tree plus BB-specific operating guidance.

## Operating loop

1. Inspect before mutating:
   ```bash
   incus version
   incus list
   incus storage list
   incus network list
   incus profile list
   ```
2. Read [`references/incus-quick-reference.md`](references/incus-quick-reference.md) for this repository's pool, template, bridge, readiness, performance, and safety conventions.
3. Find the relevant upstream page in [`references/manifest.json`](references/manifest.json), then read the matching file under `references/pages/`.
4. Observe effective state after every change:
   ```bash
   incus config show INSTANCE --expanded
   incus info INSTANCE
   incus network show NETWORK
   incus storage show POOL
   ```
5. Measure the real outcome. For BB provisioning, readiness is an HTTP 200 from the daemon health endpoint, not merely `RUNNING`, an assigned IP, or a systemd unit state.
6. Record rollback and side effects before keeping a host-level change.

## Reference map

- Installation, initialization, client, remotes: `installing`, `howto/initialize`, `client`, `remotes`
- Instances and lifecycle: `explanation/instances`, `howto/instances_create`, `howto/instances_manage`, `howto/instances_configure`, `instance-exec`
- Configuration and devices: `explanation/instance_config`, `reference/instance_options`, `reference/devices*`, `reference/standard_devices`
- Storage: `explanation/storage`, `reference/storage_drivers`, `reference/storage_btrfs`, `howto/storage_pools`, `howto/storage_volumes`
- Networking: `explanation/networks`, `reference/network_bridge`, `reference/devices_nic`, `howto/network_*`
- Images and copy/import: `images`, `image-handling`, `howto/images_*`, `howto/images_copy`, `howto/import_machines_to_instances`
- Performance and observability: `explanation/performance_tuning`, `howto/benchmark_performance`, `metrics`, `reference/provided_metrics`, `debugging`
- Security and access: `security`, `explanation/security`, `authentication`, `authorization`, `howto/server_expose`
- API and events: `rest-api`, `rest-api-spec`, `api`, `events`
- Clustering and migration: `explanation/clustering`, `clustering`, `migration`, `howto/move_instances`

## Freshness

The cached pages are a source snapshot, not a promise that upstream is unchanged. Refresh with:

```bash
cd .prime/agent/skills/incus
python3 scripts/update-docs.py
```

The updater crawls same-site pages below `https://linuxcontainers.org/incus/docs/main/`, rewrites `references/pages/`, and updates `references/manifest.json`.
