# incus cluster edit

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/cluster/edit/
Fetched: 2026-08-07

incus
cluster
edit
¶
Edit cluster member configurations as YAML
Synopsis
¶
Description:
Edit cluster member configurations as YAML
```
incus cluster edit [<remote>:]<member> [flags]

```
Examples
¶
```
  incus cluster edit <cluster member> < member.yaml
      Update a cluster member using the content of member.yaml

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
