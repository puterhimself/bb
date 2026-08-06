# incus storage volume snapshot create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/snapshot/create/
Fetched: 2026-08-07

incus
storage
volume
snapshot
create
¶
Snapshot storage volumes
Synopsis
¶
Description:
Snapshot storage volumes
```
incus storage volume snapshot create [<remote>:]<pool> <volume> [<new snapshot name>] [flags]

```
Examples
¶
```
  incus storage volume snapshot create default foo snap0
      Create a snapshot of "foo" in pool "default" called "snap0"

  incus storage volume snapshot create default vol1 snap0 < config.yaml
      Create a snapshot of "foo" in pool "default" called "snap0" with the configuration from "config.yaml"

```
Options
¶
```
      --description   Snapshot description
      --expiry        Expiry for the new snapshot (either a time span like `1d 3H` or a date in `2006/01/02 15:04 MST` format)
      --no-expiry     Ignore any configured auto-expiry for the storage volume
      --reuse         If the snapshot name already exists, delete and create a new one
      --target        Cluster member name

```
Options inherited from parent commands
¶
```
      --debug          Show all debug messages
      --explain        If the command is valid, explain its parsed arguments instead of running it
      --force-local    Force using the local unix socket
  -h, --help           Print help
      --project        Override the source project
  -q, --quiet          Don't show progress information
      --sub-commands   Use with help or --help to view sub-commands
  -v, --verbose        Show all information messages
      --version        Print version number

```
SEE ALSO
¶
incus storage volume snapshot
- Manage storage volume snapshots
