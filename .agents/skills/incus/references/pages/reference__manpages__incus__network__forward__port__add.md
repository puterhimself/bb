# incus network forward port add

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/forward/port/add/
Fetched: 2026-08-07

incus
network
forward
port
add
¶
Add ports to a forward
Synopsis
¶
Description:
Add ports to a forward
```
incus network forward port add [<remote>:]<network> <listen address> <protocol> <listen port>[,<listen port>...] <target address> [<target port>[,<target port>...]] [flags]

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
incus network forward port
- Manage network forward ports
