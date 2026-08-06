# incus storage bucket key edit

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/bucket/key/edit/
Fetched: 2026-08-07

incus
storage
bucket
key
edit
¶
Edit storage bucket key as YAML
Synopsis
¶
Description:
Edit storage bucket key as YAML
```
incus storage bucket key edit [<remote>:]<pool> <bucket> <key> [flags]

```
Examples
¶
```
  incus storage bucket edit [<remote>:]<pool> <bucket> <key> < key.yaml
      Update a storage bucket key using the content of key.yaml.

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
