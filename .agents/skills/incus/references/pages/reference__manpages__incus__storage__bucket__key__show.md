# incus storage bucket key show

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/bucket/key/show/
Fetched: 2026-08-07

incus
storage
bucket
key
show
¶
Show storage bucket key configurations
Synopsis
¶
Description:
Show storage bucket key configurations
```
incus storage bucket key show [<remote>:]<pool> <bucket> <key> [flags]

```
Examples
¶
```
  incus storage bucket key show default data foo
      Will show the properties of a bucket key called "foo" for a bucket called "data" in the "default" pool.

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
incus storage bucket key
- Manage storage bucket keys
