# Incus Quick Reference for BB

This project uses Incus for BB host-daemon machine provisioning. The authoritative upstream documentation is cached under `pages/`; use the page manifest to locate a topic.

## Local investigation defaults

- Host: `contabo-vds`
- Incus: 7.3
- Primary pool: `btrfs-fast` (Btrfs loopback pool)
- Preserve: the existing `default` dir pool
- Golden template: `bb-template`
- Main managed bridge: `incusbr0` (`10.46.168.1/24`)
- BB server from containers: `http://10.46.168.1:38886`

## Spawn and clone

```bash
incus list
incus info NAME
incus config show NAME --expanded
incus copy bb-template NAME --storage btrfs-fast   --config limits.cpu=2   --config limits.memory=2GiB   --config limits.processes=512
incus start NAME
incus stop NAME --force
incus delete NAME --force
```

For a stopped template on Btrfs, `incus copy` creates a Btrfs snapshot/subvolume clone. It is distinct from launching and unpacking a published image.

## Configuration and devices

```bash
incus config set NAME limits.cpu=2 limits.memory=2GiB
incus config show NAME --expanded
incus config device show NAME
incus config device override NAME eth0 ipv4.address=10.46.168.200
incus config device add NAME data disk pool=btrfs-fast source=... path=/workspace/data
```

When a device comes from a profile, override it before setting per-instance device options. Check the effective expanded configuration rather than assuming profile changes applied.

Relevant NIC concepts:

- `network=incusbr0` / bridged NIC: managed bridge, usually DHCP-backed.
- `ipv4.address` on a bridged NIC: selects a DHCP address/reservation; it does not necessarily remove network-online delays.
- `nictype=routed`: static address and routes, no DHCP inside the guest; requires deliberate gateway, routing, and isolation validation.
- `nictype=p2p`: direct host/guest virtual pair; useful only when the required host-side network plumbing is explicitly provided.

## Files, exec, and lifecycle

```bash
incus file push ./first-boot.env NAME/etc/bb/first-boot.env --mode 0600
incus file pull NAME/var/log/... -
incus exec NAME -- systemd-analyze
incus exec NAME -- systemd-analyze blame
incus exec NAME -- systemd-analyze critical-chain
incus exec NAME -- journalctl -b --no-pager
incus events
incus monitor --type=logging
```

A health benchmark must probe the actual application endpoint, not only `RUNNING`, an IP address, or a systemd state.

## Storage

```bash
incus storage list
incus storage show btrfs-fast
incus storage volume list btrfs-fast
incus snapshot create NAME SNAPSHOT
incus snapshot list NAME
incus snapshot restore NAME SNAPSHOT
```

Incus' Btrfs driver uses a subvolume per instance, image, and snapshot. Btrfs CoW makes template clones fast, but quotas and extent accounting need explicit capacity monitoring. Do not replace or remove the existing `default` pool for this project.

## Networking and IPAM

```bash
incus network list
incus network show incusbr0
incus network get incusbr0 ipv4.address
incus network get incusbr0 ipv4.dhcp
incus network get incusbr0 ipv4.dhcp.ranges
incus network list-leases incusbr0
```

Validate gateway reachability and DNS from inside a running instance:

```bash
incus exec NAME -- ip addr
incus exec NAME -- ip route
incus exec NAME -- getent hosts example.com
incus exec NAME -- curl -fsS http://10.46.168.1:38886/health
```

Do not expose the Incus API publicly while tuning networks.

## Performance methodology

Use `incus-benchmark` for Incus-only measurements, but keep it separate from BB application readiness measurements:

```bash
incus-benchmark init --count 10 --parallel 4 IMAGE
incus-benchmark launch --count 10 IMAGE
incus-benchmark launch --count 10 --freeze IMAGE
incus-benchmark delete
```

For BB provisioning, record at least:

1. request/T0
2. clone complete
3. config injection complete
4. `incus start` return
5. `RUNNING`
6. network/IP available
7. real BB health endpoint returns HTTP 200

Report cold clone, warm stopped pool, and already-running/resume modes separately. Never use `RUNNING` or an IP as a substitute for application readiness.

## Safety

- Check `incus list` before mutating anything.
- Snapshot or back up a template before host-level experiments.
- Do not touch production-like `bb-spike` instances.
- Keep changes isolated and record rollback commands.
- Use unprivileged containers unless a requirement proves otherwise.
- Treat Incus Unix-socket access as root-equivalent.

## Source and freshness

The full snapshot was fetched from `https://linuxcontainers.org/incus/docs/main/`. See `manifest.json` for all cached pages and `../scripts/update-docs.py` to refresh the snapshot.
