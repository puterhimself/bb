# incus network list

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/list/
Fetched: 2026-08-07

incus
network
list
¶
List available networks
Synopsis
¶
Description:
List available networks
Filters may be of the
=
form for property based filtering,
or part of the network name. Filters must be delimited by a ‘,’.
Examples:
- “foo” lists all networks that start with the name foo
- “name=foo” lists all networks that exactly have the name foo
- “type=bridge” lists all networks with the type bridge
The -c option takes a (optionally comma-separated) list of arguments
that control which networks attributes to output when displaying in table
or csv format.
Default column layout is: ntm46dus
Column shorthand chars:
4 - IPv4 address
6 - IPv6 address
d - Description
e - Project name
m - Managed status
n - Network Interface Name
s - State
t - Interface type
u - Used by (count)
```
incus network list [<remote>:] [<filter>...] [flags]

```
Options
¶
```
      --all-projects   List networks in all projects
  -c, --columns        Columns (default "ntm46dus")
  -f, --format         Format (csv|json|table|yaml|compact|markdown), use suffix ",noheader" to disable headers and ",header" to enable it if missing, e.g. csv,header (default "table")
      --target         Cluster member name

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
incus network
- Manage and attach instances to networks
