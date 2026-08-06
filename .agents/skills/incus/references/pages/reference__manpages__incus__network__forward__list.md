# incus network forward list

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/forward/list/
Fetched: 2026-08-07

incus
network
forward
list
¶
List available network forwards
Synopsis
¶
Description:
List available network forwards
Default column layout: ldDp
== Columns ==
The -c option takes a comma separated list of arguments that control
which network forward attributes to output when displaying
in table or csv format.
Column arguments are either pre-defined shorthand chars (see below),
or (extended) config keys.
Commas between consecutive shorthand chars are optional.
Pre-defined column shorthand chars:
l - Listen Address
d - Description
D - Default Target Address
p - Port
L - Location of the network zone (e.g. its cluster member)
```
incus network forward list [<remote>:]<network> [flags]

```
Options
¶
```
  -c, --columns   Columns (default "ldDp")
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
incus network forward
- Manage network forwards
