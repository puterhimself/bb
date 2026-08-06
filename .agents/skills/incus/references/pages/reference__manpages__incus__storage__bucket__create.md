# incus storage bucket create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/bucket/create/
Fetched: 2026-08-07

incus
storage
bucket
create
¶
Create new custom storage buckets
Synopsis
¶
Description:
Create new custom storage buckets
```
incus storage bucket create [<remote>:]<pool> <new bucket name> [<key>=<value>...] [flags]

```
Examples
¶
```
  incus storage bucket create p1 b01
  	Create a new storage bucket named b01 in storage pool p1

  incus storage bucket create p1 b01 < config.yaml
  	Create a new storage bucket named b01 in storage pool p1 using the content of config.yaml

```
Options
¶
```
      --description   Bucket description
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
