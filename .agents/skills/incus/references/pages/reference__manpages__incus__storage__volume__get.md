# incus storage volume get

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/get/
Fetched: 2026-08-07

incus
storage
volume
get
¶
Get values for storage volume configuration keys
Synopsis
¶
Description:
Get values for storage volume configuration keys
If the type is not specified, incus assumes the type is “custom”.
Supported values for type are “custom”, “container” and “virtual-machine”.
For snapshots, add the snapshot name (only if type is one of custom, container or virtual-machine).
```
incus storage volume get [<remote>:]<pool> [<type>/]<volume>[/<snapshot>] <key> [flags]

```
Examples
¶
```
  incus storage volume get default data size
      Returns the size of a custom volume "data" in pool "default"

  incus storage volume get default virtual-machine/data snapshots.expiry
      Returns the snapshot expiration period for a virtual machine "data" in pool "default"

```
Options
¶
```
  -p, --property   Get the key as a storage volume property
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
