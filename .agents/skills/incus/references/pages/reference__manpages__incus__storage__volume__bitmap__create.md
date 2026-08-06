# incus storage volume bitmap create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/bitmap/create/
Fetched: 2026-08-07

incus
storage
volume
bitmap
create
¶
Create a dirty bitmap on a storage volume
Synopsis
¶
Description:
Create a dirty bitmap on a storage volume
```
incus storage volume bitmap create [<remote>:]<pool> [<type>/]<volume> <new bitmap name> [flags]

```
Options
¶
```
      --disabled      Create the bitmap in the disabled state
      --granularity   Granularity of the dirty bitmap in bytes
      --persistent    Store the bitmap on disk
      --target        Cluster member name

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
