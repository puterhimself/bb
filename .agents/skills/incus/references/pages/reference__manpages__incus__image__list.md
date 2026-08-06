# incus image list

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/image/list/
Fetched: 2026-08-07

incus
image
list
¶
List images
Synopsis
¶
Description:
List images
Filters may be of the
=
form for property based filtering,
or part of the image hash or part of the image alias name.
The -c option takes a (optionally comma-separated) list of arguments
that control which image attributes to output when displaying in table
or csv format.
Default column layout is: lfpdasu
Column shorthand chars:
l - Shortest image alias (and optionally number of other aliases)
L - Newline-separated list of all image aliases
f - Fingerprint (short)
F - Fingerprint (long)
p - Whether image is public
d - Description
e - Project
a - Architecture
s - Size
u - Upload date
t - Type
```
incus image list [<remote>:] [<filter>...] [flags]

```
Options
¶
```
      --all-projects   Display images from all projects
  -c, --columns        Columns (default "lfpdatsu")
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
incus image
- Manage images
