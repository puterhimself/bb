# incus admin recover

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/admin/recover/
Fetched: 2026-08-07

incus
admin
recover
¶
Recover missing instances and volumes from existing and unknown storage pools
Synopsis
¶
Description:
Recover missing instances and volumes from existing and unknown storage pools
This command is mostly used for disaster recovery. It will ask you about unknown storage pools and attempt to
access them, along with existing storage pools, and identify any missing instances and volumes that exist on the
pools but are not in the database. It will then offer to recreate these database records.
```
incus admin recover [<remote>:] [flags]

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
incus admin
- Manage incus daemon
