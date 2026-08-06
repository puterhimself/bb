# incus network create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/create/
Fetched: 2026-08-07

incus
network
create
¶
Create new networks
Synopsis
¶
Description:
Create new networks
```
incus network create [<remote>:]<new network name> [<key>=<value>...] [flags]

```
Examples
¶
```
  incus network create foo
      Create a new network called foo

  incus network create foo < config.yaml
      Create a new network called foo using the content of config.yaml.

  incus network create bar network=baz --type ovn
      Create a new OVN network called bar using baz as its uplink network

```
Options
¶
```
      --description   Network description
      --target        Cluster member name
  -t, --type          Network type

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
incus network
- Manage and attach instances to networks
