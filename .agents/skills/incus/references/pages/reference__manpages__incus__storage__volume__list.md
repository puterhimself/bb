# incus storage volume list

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/list/
Fetched: 2026-08-07

incus
storage
volume
list
¶
List storage volumes
Synopsis
¶
Description:
List storage volumes
A single keyword like “vol” which will list any storage volume with a name starting by “vol”.
A regular expression on the storage volume name. (e.g. .*vol.*01$).
A key/value pair where the key is a storage volume field name. Multiple values must be delimited by ‘,’.
Examples:
- “type=custom” will list all custom storage volumes
- “type=custom content_type=block” will list all custom block storage volumes
== Columns ==
The -c option takes a (optionally comma-separated) list of arguments
that control which image attributes to output when displaying in table
or csv format.
Column shorthand chars:
c - Content type (filesystem or block)
d - Description
e - Project name
L - Location of the instance (e.g. its cluster member)
n - Name
t - Type of volume (custom, image, container or virtual-machine)
u - Number of references (used by)
U - Current disk usage
```
incus storage volume list [<remote>:]<pool> [<filter>...] [flags]

```
Options
¶
```
      --all-projects   All projects
  -c, --columns        Columns (default "etndcuL")
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
incus storage volume
- Manage storage volumes
