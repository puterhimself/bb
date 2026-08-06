# incus storage volume create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/create/
Fetched: 2026-08-07

incus
storage
volume
create
¶
Create new custom storage volumes
Synopsis
¶
Description:
Create new custom storage volumes
```
incus storage volume create [<remote>:]<pool> <new volume name> [<key>=<value>...] [flags]

```
Examples
¶
```
  incus storage volume create default foo
      Create custom storage volume "foo" in pool "default"

  incus storage volume create default foo < config.yaml
      Create custom storage volume "foo" in pool "default" with configuration from config.yaml

```
Options
¶
```
      --description   Volume description
      --target        Cluster member name
  -t, --type          Content type, block or filesystem (default "filesystem")

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
