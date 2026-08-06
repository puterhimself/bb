# incus cluster restore

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/cluster/restore/
Fetched: 2026-08-07

incus
cluster
restore
¶
Restore cluster member
Synopsis
¶
Description:
Restore cluster member
The action flag allows overriding the default behavior of moving and starting back all instances.
The only supported value at the moment is “skip” which brings the cluster member online without relocating any instances.
```
incus cluster restore [<remote>:]<member> [flags]

```
Options
¶
```
      --action   Force a particular restoration action
  -f, --force    Force evacuation without user confirmation

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
incus cluster
- Manage cluster members
