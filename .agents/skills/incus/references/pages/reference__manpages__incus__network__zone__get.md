# incus network zone get

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/zone/get/
Fetched: 2026-08-07

incus
network
zone
get
¶
Get values for network zone configuration keys
Synopsis
¶
Description:
Get values for network zone configuration keys
```
incus network zone get [<remote>:]<zone> <key> [flags]

```
Options
¶
```
  -p, --property   Get the key as a network zone property

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
incus network zone
- Manage network zones
