# incus storage volume unset

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/unset/
Fetched: 2026-08-07

incus
storage
volume
unset
¶
Unset storage volume configuration keys
Synopsis
¶
Description:
Unset storage volume configuration keys
If the type is not specified, Incus assumes the type is “custom”.
Supported values for type are “custom”, “container” and “virtual-machine”.
```
incus storage volume unset [<remote>:]<pool> [<type>/]<volume>[/<snapshot>] <key>... [flags]

```
Examples
¶
```
  incus storage volume unset default foo size
      Removes the size/quota of custom volume "foo" in pool "default"

  incus storage volume unset default virtual-machine/v1 snapshots.expiry
      Removes the snapshot expiration period of virtual machine volume "v1" in pool "default"

```
Options
¶
```
  -p, --property   Unset the keys as storage volume properties
      --target     Cluster member name

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
