# incus config template list

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/config/template/list/
Fetched: 2026-08-07

incus
config
template
list
¶
List instance file templates
Synopsis
¶
Description:
List instance file templates
```
incus config template list [<remote>:]<instance> [flags]

```
Options
¶
```
  -f, --format   Format (csv|json|table|yaml|compact|markdown), use suffix ",noheader" to disable headers and ",header" to enable it if missing, e.g. csv,header (default "table")

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
incus config template
- Manage instance file templates
