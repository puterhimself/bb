# incus alias rename

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/alias/rename/
Fetched: 2026-08-07

incus
alias
rename
¶
Rename aliases
Synopsis
¶
Description:
Rename aliases
```
incus alias rename <alias> <new alias name> [flags]

```
Examples
¶
```
  incus alias rename list my-list
      Rename existing alias "list" to "my-list".

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
incus alias
- Manage command aliases
