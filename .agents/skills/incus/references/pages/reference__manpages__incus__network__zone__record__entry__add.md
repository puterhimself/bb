# incus network zone record entry add

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/zone/record/entry/add/
Fetched: 2026-08-07

incus
network
zone
record
entry
add
¶
Add a network zone record entry
Synopsis
¶
Description:
Add entries to a network zone record
```
incus network zone record entry add [<remote>:]<zone> <record> <type> <value> [flags]

```
Options
¶
```
      --ttl   Entry TTL

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
incus network zone record entry
- Manage network zone record entries
