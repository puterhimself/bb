# incus storage bucket edit

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/bucket/edit/
Fetched: 2026-08-07

incus
storage
bucket
edit
¶
Edit storage bucket configurations as YAML
Synopsis
¶
Description:
Edit storage bucket configurations as YAML
```
incus storage bucket edit [<remote>:]<pool> <bucket> [flags]

```
Examples
¶
```
  incus storage bucket edit [<remote>:]<pool> <bucket> < bucket.yaml
      Update a storage bucket using the content of bucket.yaml.

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
