# incus cluster set

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/cluster/set/
Fetched: 2026-08-07

incus
cluster
set
¶
Set a cluster member’s configuration keys
Synopsis
¶
Description:
Set a cluster member’s configuration keys
```
incus cluster set [<remote>:]<member> <key>=<value>... [flags]

```
Options
¶
```
  -p, --property   Set the key as a cluster property

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
