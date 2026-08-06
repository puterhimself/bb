# incus storage volume nbd

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/nbd/
Fetched: 2026-08-07

incus
storage
volume
nbd
¶
NBD access to a block storage volume
Synopsis
¶
Description:
NBD access to a block storage volume
```
incus storage volume nbd [<remote>:]<pool> [<type>/]<volume> [flags]

```
Options
¶
```
      --address    Specific address to listen on
      --writable   Get write access to the disk

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
