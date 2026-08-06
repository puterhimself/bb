# incus storage volume bitmap show

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/bitmap/show/
Fetched: 2026-08-07

incus
storage
volume
bitmap
show
¶
Show storage volume dirty bitmap information
Synopsis
¶
Description:
Show storage volume dirty bitmap information
```
incus storage volume bitmap show [<remote>:]<pool> [<type>/]<volume> <bitmap> [flags]

```
Options
¶
```
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
incus storage volume bitmap
- Manage storage volume dirty bitmaps
