# incus cluster get

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/cluster/get/
Fetched: 2026-08-07

incus
cluster
get
¶
Get values for cluster member configuration keys
Synopsis
¶
Description:
Get values for cluster member configuration keys
```
incus cluster get [<remote>:]<member> <key> [flags]

```
Options
¶
```
  -p, --property   Get the key as a cluster property

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
