# incus network peer set

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/peer/set/
Fetched: 2026-08-07

incus
network
peer
set
¶
Set network peer keys
Synopsis
¶
Description:
Set network peer keys
For backward compatibility, a single configuration key may still be set with:
incus network set [
:]
<peer_name>
```
incus network peer set [<remote>:]<network> <peer> <key>=<value>... [flags]

```
Options
¶
```
  -p, --property   Set the key as a network peer property

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
