# incus admin os debug log

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/admin/os/debug/log/
Fetched: 2026-08-07

incus
admin
os
debug
log
¶
Get debug log
Synopsis
¶
Description
Get debug log
```
incus admin os debug log [flags]

```
Options
¶
```
  -b, --boot      Boot number
  -n, --entries   Number of entries
  -S, --since     Since date/time
      --target    Cluster member name
  -u, --unit      Unit name
  -U, --until     Until date/time

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
incus admin os debug
- Debug IncusOS systems
