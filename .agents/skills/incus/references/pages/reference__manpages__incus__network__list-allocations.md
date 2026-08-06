# incus network list-allocations

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/list-allocations/
Fetched: 2026-08-07

incus
network
list-allocations
¶
List network allocations in use
Synopsis
¶
Description:
List network allocations in use
Default column layout: uatnm
== Columns ==
The -c option takes a comma separated list of arguments that control
which network allocations attribute attributes to output when
displaying in table or csv format.
Column arguments are either pre-defined shorthand chars (see below),
or (extended) config keys.
Commas between consecutive shorthand chars are optional.
Pre-defined column shorthand chars:
u - Used by
a - Address
t - Type
n - NAT
N - Network
m - Mac Address
```
incus network list-allocations [<remote>:] [flags]

```
Options
¶
```
      --all-projects   Run against all projects
  -c, --columns        Columns (default "uaNtnm")
  -f, --format         Format (csv|json|table|yaml|compact|markdown), use suffix ",noheader" to disable headers and ",header" to enable it if missing, e.g. csv,header (default "table")
  -p, --project        Run again a specific project (default "default")
      --summary        Show a summary of used IP ranges per subnet

```
Options inherited from parent commands
¶
```
      --debug          Show all debug messages
      --explain        If the command is valid, explain its parsed arguments instead of running it
      --force-local    Force using the local unix socket
  -h, --help           Print help
  -q, --quiet          Don't show progress information
      --sub-commands   Use with help or --help to view sub-commands
  -v, --verbose        Show all information messages
      --version        Print version number

```
SEE ALSO
¶
incus network
- Manage and attach instances to networks
