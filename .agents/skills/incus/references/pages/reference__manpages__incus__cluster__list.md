# incus cluster list

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/cluster/list/
Fetched: 2026-08-07

incus
cluster
list
¶
List all the cluster members
Synopsis
¶
Description:
List all the cluster members
The -c option takes a (optionally comma-separated) list of arguments
that control which cluster members attributes to output when displaying in table
or csv format.
Default column layout is: nurafdsm
Column shorthand chars:
n - Server name
u - URL
r - Roles
a - Architecture
f - Failure Domain
d - Description
s - Status
m - Message
```
incus cluster list [<remote>:] [<filter>...] [flags]

```
Options
¶
```
      --all-projects   Display clusters from all projects
  -c, --columns        Columns (default "nurafdsm")
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
incus cluster
- Manage cluster members
