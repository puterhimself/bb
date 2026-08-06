# incus project list

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/project/list/
Fetched: 2026-08-07

incus
project
list
¶
List projects
Synopsis
¶
Description:
List projects
The -c option takes a (optionally comma-separated) list of arguments
that control which project attributes to output when displaying in table
or csv format.
Default column layout is: nipvbwzdu
Column shorthand chars:
n - Project Name
i - Images
p - Profiles
v - Storage Volumes
b - Storage Buckets
w - Networks
z - Network Zones
d - Description
u - Used By
```
incus project list [<remote>:] [<filter>...] [flags]

```
Options
¶
```
  -c, --columns   Columns (default "nipvbwzdu")
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
incus project
- Manage projects
