# incus cluster group create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/cluster/group/create/
Fetched: 2026-08-07

incus
cluster
group
create
¶
Create a cluster group
Synopsis
¶
Description:
Create a cluster group
```
incus cluster group create [<remote>:]<new group name> [flags]

```
Examples
¶
```
  incus cluster group create g1
      Create a cluster group named g1

  incus cluster group create g1 < config.yaml
      Create a cluster group named g1 with configuration from config.yaml

```
Options
¶
```
      --description   Cluster group description

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
