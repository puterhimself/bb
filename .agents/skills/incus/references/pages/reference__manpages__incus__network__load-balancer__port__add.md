# incus network load-balancer port add

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/load-balancer/port/add/
Fetched: 2026-08-07

incus
network
load-balancer
port
add
¶
Add ports to a load balancer
Synopsis
¶
Description:
Add ports to a load balancer
```
incus network load-balancer port add [<remote>:]<network> <listen address> <protocol> <listen port>[,<listen port>...] <backend>[,<backend>...] [flags]

```
Options
¶
```
      --description   Port description
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
incus network load-balancer port
- Manage network load balancer ports
