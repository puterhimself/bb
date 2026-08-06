# incus storage volume export

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/export/
Fetched: 2026-08-07

incus
storage
volume
export
¶
Export custom storage volumes
Synopsis
¶
Description:
Export custom storage volumes.
```
incus storage volume export [<remote>:]<pool> <volume> [<target file>] [flags]

```
Options
¶
```
      --compression         Compression algorithm to use (none for uncompressed, ignored for ISO storage volumes)
  -f, --force               Force overwriting existing backup file
      --optimized-storage   Use storage driver optimized format (can only be restored on a similar pool, ignored for ISO storage volumes)
      --target              Cluster member name
      --volume-only         Export the volume without its snapshots (ignored for ISO storage volumes)

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
incus storage volume
- Manage storage volumes
