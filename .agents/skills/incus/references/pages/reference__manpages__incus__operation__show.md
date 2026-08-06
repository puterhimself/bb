# incus operation show

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/operation/show/
Fetched: 2026-08-07

incus
operation
show
¶
Show details on a background operation
Synopsis
¶
Description:
Show details on a background operation
```
incus operation show [<remote>:]<operation> [flags]

```
Examples
¶
```
  incus operation show 344a79e4-d88a-45bf-9c39-c72c26f6ab8a
      Show details on that operation UUID

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
