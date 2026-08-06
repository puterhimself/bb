# incus file delete

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/file/delete/
Fetched: 2026-08-07

incus
file
delete
¶
Delete files in instances
Synopsis
¶
Description:
Delete files in instances
```
incus file delete [<remote>:]<instance>/<path>... [flags]

```
Options
¶
```
  -f, --force   Force deleting files, directories, and subdirectories

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
incus file
- Manage files in instances
