# incus storage bucket export

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/bucket/export/
Fetched: 2026-08-07

incus
storage
bucket
export
¶
Export storage bucket
Synopsis
¶
Description:
Export storage buckets as tarball.
```
incus storage bucket export [<remote>:]<pool> <bucket> [<target file>] [flags]

```
Examples
¶
```
  incus storage bucket export default b1
      Download a backup tarball of the b1 storage bucket from the default pool.

```
Options
¶
```
      --compression   Define a compression algorithm: for backup or none
  -f, --force         Force overwriting existing backup file
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
incus storage bucket
- Manage storage buckets
