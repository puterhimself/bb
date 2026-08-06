# incus storage volume bitmap list

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/bitmap/list/
Fetched: 2026-08-07

incus
storage
volume
bitmap
list
¶
List storage volume dirty bitmaps
Synopsis
¶
Description:
List storage volume dirty bitmaps
The -c option takes a (optionally comma-separated) list of arguments
that control which bitmap attributes to output when displaying in
table or csv format.
Column shorthand chars:
n - Name
c - Number of dirty bytes
g - Granularity
r - Recording
b - Busy
p - Persistent
i - Inconsistent
```
incus storage volume bitmap list [<remote>:]<pool> [<type>/]<volume> [flags]

```
Options
¶
```
  -c, --columns   Columns (default "ncgrbpi")
  -f, --format    Format (csv|json|table|yaml|compact|markdown), use suffix ",noheader" to disable headers and ",header" to enable it if missing, e.g. csv,header (default "table")
      --target    Cluster member name

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
incus storage volume bitmap
- Manage storage volume dirty bitmaps
