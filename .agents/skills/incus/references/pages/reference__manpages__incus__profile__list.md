# incus profile list

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/profile/list/
Fetched: 2026-08-07

incus
profile
list
¶
List profiles
Synopsis
¶
Description:
List profiles
Filters may be of the
=
form for property based filtering,
or part of the profile name. Filters must be delimited by a ‘,’.
Examples:
- “foo” lists all profiles that start with the name foo
- “name=foo” lists all profiles that exactly have the name foo
- “description=.
bar.
” lists all profiles with a description that contains “bar”
The -c option takes a (optionally comma-separated) list of arguments
that control which profile attributes to output when displaying in table
or csv format.
Default column layout is: ndu
Column shorthand chars:
n - Profile Name
d - Description
u - Used By
```
incus profile list [<remote>:] [<filter>...] [flags]

```
Options
¶
```
      --all-projects   Display profiles from all projects
  -c, --columns        Columns (default "ndu")
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
incus profile
- Manage profiles
