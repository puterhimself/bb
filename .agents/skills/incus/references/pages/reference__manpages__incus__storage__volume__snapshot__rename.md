# incus storage volume snapshot rename

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/snapshot/rename/
Fetched: 2026-08-07

incus
storage
volume
snapshot
rename
¶
Rename storage volume snapshots
Synopsis
¶
Description:
Rename storage volume snapshots
```
incus storage volume snapshot rename [<remote>:]<pool> <volume> <snapshot> <new snapshot name> [flags]

```
Options
¶
```
      --target   Cluster member name

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
