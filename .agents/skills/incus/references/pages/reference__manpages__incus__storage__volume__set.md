# incus storage volume set

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/set/
Fetched: 2026-08-07

incus
storage
volume
set
¶
Set storage volume configuration keys
Synopsis
¶
Description:
Set storage volume configuration keys
For backward compatibility, a single configuration key may still be set with:
incus storage volume set [
:]
[
/]
If the type is not specified, Incus assumes the type is “custom”.
Supported values for type are “custom”, “container” and “virtual-machine”.
```
incus storage volume set [<remote>:]<pool> [<type>/]<volume>[/<snapshot>] <key>=<value>... [flags]

```
Examples
¶
```
  incus storage volume set default data size=1GiB
      Sets the size of a custom volume "data" in pool "default" to 1 GiB

  incus storage volume set default virtual-machine/data snapshots.expiry=7d
      Sets the snapshot expiration period for a virtual machine "data" in pool "default" to seven days

```
Options
¶
```
  -p, --property   Set the key as a storage volume property
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
