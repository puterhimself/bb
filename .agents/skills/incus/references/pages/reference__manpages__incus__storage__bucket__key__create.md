# incus storage bucket key create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/bucket/key/create/
Fetched: 2026-08-07

incus
storage
bucket
key
create
¶
Create key for a storage bucket
Synopsis
¶
Description:
Create key for a storage bucket
```
incus storage bucket key create [<remote>:]<pool> <bucket> <new key name> [flags]

```
Examples
¶
```
  incus storage bucket key create p1 b01 k1
  	Create a key called k1 for the bucket b01 in the pool p1.

  incus storage bucket key create p1 b01 k1 < config.yaml
  	Create a key called k1 for the bucket b01 in the pool p1 using the content of config.yaml.

```
Options
¶
```
      --access-key    Access key (auto-generated if empty)
      --description   Key description
      --role          Role (admin or read-only) (default "read-only")
      --secret-key    Secret key (auto-generated if empty)
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
incus storage bucket key
- Manage storage bucket keys
