# incus operation list

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/operation/list/
Fetched: 2026-08-07

incus
operation
list
¶
List background operations
Synopsis
¶
Description:
List background operations
Default column layout: itdscCL
== Columns ==
The -c option takes a comma separated list of arguments that control
which attributes of background operations to output when displaying
in table or csv format.
Column arguments are either pre-defined shorthand chars (see below),
or (extended) config keys.
Commas between consecutive shorthand chars are optional.
Pre-defined column shorthand chars:
i - ID
t - Type
d - Description
s - State
c - Cancelable
C - Created
L - Location of the operation (e.g. its cluster member)
```
incus operation list [<remote>:] [flags]

```
Options
¶
```
      --all-projects   List operations from all projects
  -c, --columns        Columns (default "itdscC")
  -f, --format         Format (csv|json|table|yaml|compact|markdown), use suffix ",noheader" to disable headers and ",header" to enable it if missing, e.g. csv,header (default "table")

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
incus operation
- List, show and delete background operations
