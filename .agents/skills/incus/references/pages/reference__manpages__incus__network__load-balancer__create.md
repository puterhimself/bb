# incus network load-balancer create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/load-balancer/create/
Fetched: 2026-08-07

incus
network
load-balancer
create
¶
Create new network load balancers
Synopsis
¶
Description:
Create new network load balancers
```
incus network load-balancer create [<remote>:]<network> <listen address> [<key>=<value>...] [flags]

```
Examples
¶
```
  incus network load-balancer create n1 127.0.0.1
      Create network load-balancer for network n1

  incus network load-balancer create n1 127.0.0.1 < config.yaml
      Create network load-balancer for network n1 with configuration from config.yaml

```
Options
¶
```
      --description   Load balancer description
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
incus network load-balancer
- Manage network load balancers
