# incus network load-balancer list

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/load-balancer/list/
Fetched: 2026-08-07

incus
network
load-balancer
list
¶
List available network load balancers
Synopsis
¶
Description:
List available network load balancers
Default column layout: ldp
== Columns ==
The -c option takes a comma separated list of arguments that control
which network load balancer attributes to output when displaying
in table or csv format.
Column arguments are either pre-defined shorthand chars (see below),
or (extended) config keys.
Commas between consecutive shorthand chars are optional.
Pre-defined column shorthand chars:
l - Listen Address
d - Description
p - Ports
L - Location of the operation (e.g. its cluster member)
```
incus network load-balancer list [<remote>:]<network> [flags]

```
Options
¶
```
  -c, --columns   Columns (default "ldp")
  -f, --format    Format (csv|json|table|yaml|compact|markdown), use suffix ",noheader" to disable headers and ",header" to enable it if missing, e.g. csv,header (default "table")

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
incus network load-balancer
- Manage network load balancers
