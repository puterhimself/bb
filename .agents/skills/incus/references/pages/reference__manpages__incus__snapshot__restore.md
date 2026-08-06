# incus snapshot restore

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/snapshot/restore/
Fetched: 2026-08-07

incus
snapshot
restore
¶
Restore instance snapshots
Synopsis
¶
Description:
Restore instance from snapshots
If –stateful is passed, then the running state will be restored too.
If –diskonly is passed, then only the disk will be restored.
```
incus snapshot restore [<remote>:]<instance> <snapshot> [flags]

```
Examples
¶
```
  incus snapshot restore u1 snap0
      Restore instance u1 to snapshot snap0

```
Options
¶
```
      --diskonly   Whether or not to restore the instance's disk only
      --stateful   Whether or not to restore the instance's running state from snapshot (if available)

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
incus snapshot
- Manage instance snapshots
