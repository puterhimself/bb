# incus low-level nvram list

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/low-level/nvram/list/
Fetched: 2026-08-07

incus
low-level
nvram
list
¶
List UEFI GUIDs and variables
Synopsis
¶
Description:
List UEFI GUIDs and variables
```
incus low-level nvram list [<remote>:]<instance> [<GUID>] [flags]

```
Options
¶
```
  -c, --columns   Columns (default "Gnv")
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
incus low-level nvram
- Manage NVRAM on virtual machines
