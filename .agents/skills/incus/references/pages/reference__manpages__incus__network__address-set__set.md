# incus network address-set set

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/address-set/set/
Fetched: 2026-08-07

incus
network
address-set
set
¶
Set network address set configuration keys
Synopsis
¶
Description:
Set network address set configuration keys
```
incus network address-set set [<remote>:]<address set> <key>=<value>... [flags]

```
Options
¶
```
  -p, --property   Set the key as a network address set property

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
incus network address-set
- Manage network address sets
