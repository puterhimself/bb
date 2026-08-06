# incus cluster group assign

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/cluster/group/assign/
Fetched: 2026-08-07

incus
cluster
group
assign
¶
Assign sets of groups to cluster members
Synopsis
¶
Description:
Assign sets of groups to cluster members
```
incus cluster group assign [<remote>:]<member> <group>... [flags]

```
Examples
¶
```
  incus cluster group assign foo default bar
      Set the groups for "foo" to "default" and "bar".

  incus cluster group assign foo default
      Reset "foo" to only using the "default" cluster group.

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
incus cluster group
- Manage cluster groups
