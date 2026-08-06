# incus network peer unset

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/peer/unset/
Fetched: 2026-08-07

incus
network
peer
unset
¶
Unset network peer configuration keys
Synopsis
¶
Description:
Unset network peer keys
```
incus network peer unset [<remote>:]<network> <peer> <key>... [flags]

```
Options
¶
```
  -p, --property   Unset the keys as network peer properties

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
