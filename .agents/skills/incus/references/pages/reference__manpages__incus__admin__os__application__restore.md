# incus admin os application restore

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/admin/os/application/restore/
Fetched: 2026-08-07

incus
admin
os
application
restore
¶
Restore an application backup
Synopsis
¶
Description
Restore an application backup
```
incus admin os application restore [<remote>:]<application> <file|-> [flags]

```
Options
¶
```
      --force    Skip the confirmation prompt
      --target   Cluster member name

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
incus admin os application
- Manage IncusOS applications
