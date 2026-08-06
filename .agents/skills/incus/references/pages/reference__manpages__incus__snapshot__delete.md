# incus snapshot delete

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/snapshot/delete/
Fetched: 2026-08-07

incus
snapshot
delete
¶
Delete instance snapshots
Synopsis
¶
Description:
Delete instance snapshots
```
incus snapshot delete [<remote>:]<instance> <snapshot> [flags]

```
Options
¶
```
  -i, --interactive   Require user confirmation

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
