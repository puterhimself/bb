# incus storage bucket show

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/bucket/show/
Fetched: 2026-08-07

incus
storage
bucket
show
¶
Show storage bucket configurations
Synopsis
¶
Description:
Show storage bucket configurations
```
incus storage bucket show [<remote>:]<pool> <bucket> [flags]

```
Examples
¶
```
  incus storage bucket show default data
      Will show the properties of a bucket called "data" in the "default" pool.

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
incus storage bucket
- Manage storage buckets
