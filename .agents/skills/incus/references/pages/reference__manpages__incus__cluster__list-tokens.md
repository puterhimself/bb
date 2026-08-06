# incus cluster list-tokens

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/cluster/list-tokens/
Fetched: 2026-08-07

incus
cluster
list-tokens
¶
List all active cluster member join tokens
Synopsis
¶
Description:
List all active cluster member join tokens
Default column layout: ntE
== Columns ==
The -c option takes a comma separated list of arguments that control
which join tokens attributes to output when displaying in table or csv
format.
Column arguments are either pre-defined shorthand chars (see below),
or (extended) config keys.
Commas between consecutive shorthand chars are optional.
Pre-defined column shorthand chars:
n - Name
t - Token
E - Expires At
```
incus cluster list-tokens [<remote>:] [flags]

```
Options
¶
```
  -c, --columns   Columns (default "ntE")
  -f, --format    Format (csv|json|table|yaml|compact|markdown), use suffix ",noheader" to disable headers and ",header" to enable if demanded, e.g. csv,header (default "table")

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
incus cluster
- Manage cluster members
