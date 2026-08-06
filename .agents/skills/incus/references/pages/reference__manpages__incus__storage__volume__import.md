# incus storage volume import

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/import/
Fetched: 2026-08-07

incus
storage
volume
import
¶
Import custom storage volumes
Synopsis
¶
Description:
Import custom storage volumes.
```
incus storage volume import [<remote>:]<pool> <backup file> [<new volume name>] [flags]

```
Examples
¶
```
  incus storage volume import default backup0.tar.gz
      Create a new custom volume using backup0.tar.gz as the source

  incus storage volume import default some-installer.iso installer --type=iso
      Create a new custom volume storing some-installer.iso for use as a CD-ROM image

```
Options
¶
```
      --target   Cluster member name
  -t, --type     Import type, backup or iso (default "backup")

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
