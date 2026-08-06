# incus alias add

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/alias/add/
Fetched: 2026-08-07

incus
alias
add
¶
Add new aliases
Synopsis
¶
Description:
Add new aliases
```
incus alias add <new alias name> <target command> [flags]

```
Examples
¶
```
  incus alias add list "list -c ns46S"
      Overwrite the "list" command to pass -c ns46S.

  incus alias add volume "storage volume @ARGS@"
      Create a short command for managing volumes

  incus alias add cat "exec @ARG1@ -- cat @ARG2@"
      Create a command for displaying file content of instances

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
