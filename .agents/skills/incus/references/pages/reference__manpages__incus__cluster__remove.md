# incus cluster remove

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/cluster/remove/
Fetched: 2026-08-07

incus
cluster
remove
¶
Remove a member from the cluster
Synopsis
¶
Description:
Remove a member from the cluster
```
incus cluster remove [<remote>:]<member> [flags]

```
Options
¶
```
  -f, --force   Force removing a member, even if degraded
      --yes     Don't require user confirmation for using --force

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
