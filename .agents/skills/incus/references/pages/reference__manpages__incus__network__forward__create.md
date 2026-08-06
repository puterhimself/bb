# incus network forward create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/forward/create/
Fetched: 2026-08-07

incus
network
forward
create
¶
Create new network forwards
Synopsis
¶
Description:
Create new network forwards
```
incus network forward create [<remote>:]<network> <listen address> [<key>=<value>...] [flags]

```
Examples
¶
```
  incus network forward create n1 127.0.0.1

  incus network forward create n1 127.0.0.1 < config.yaml
      Create a new network forward for network n1 from config.yaml

```
Options
¶
```
      --description   Network forward description
      --target        Cluster member name

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
incus network forward
- Manage network forwards
