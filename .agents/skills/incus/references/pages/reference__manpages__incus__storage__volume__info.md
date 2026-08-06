# incus storage volume info

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/info/
Fetched: 2026-08-07

incus
storage
volume
info
¶
Show storage volume state information
Synopsis
¶
Description:
Show storage volume state information
If the type is not specified, Incus assumes the type is “custom”.
Supported values for type are “custom”, “container” and “virtual-machine”.
```
incus storage volume info [<remote>:]<pool> [<type>/]<volume> [flags]

```
Examples
¶
```
  incus storage volume info default foo
      Returns state information for a custom volume "foo" in pool "default"

  incus storage volume info default virtual-machine/v1
      Returns state information for virtual machine "v1" in pool "default"

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
incus storage volume
- Manage storage volumes
