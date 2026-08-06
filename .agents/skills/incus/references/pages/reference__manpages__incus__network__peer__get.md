# incus network peer get

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/peer/get/
Fetched: 2026-08-07

incus
network
peer
get
¶
Get values for network peer configuration keys
Synopsis
¶
Description:
Get values for network peer configuration keys
```
incus network peer get [<remote>:]<network> <peer> <key> [flags]

```
Options
¶
```
  -p, --property   Get the key as a network peer property

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
incus network peer
- Manage network peerings
