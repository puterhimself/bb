# incus storage volume

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/
Fetched: 2026-08-07

incus
storage
volume
¶
Manage storage volumes
Synopsis
¶
Description:
Manage storage volumes
Unless specified through a prefix, all volume operations affect “custom” (user created) volumes.
```
incus storage volume [flags]

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
incus storage
- Manage storage pools and volumes
incus storage volume attach
- Attach new custom storage volumes to instances
incus storage volume attach-profile
- Attach new custom storage volumes to profiles
incus storage volume bitmap
- Manage storage volume dirty bitmaps
incus storage volume copy
- Copy custom storage volumes
incus storage volume create
- Create new custom storage volumes
incus storage volume delete
- Delete custom storage volumes
incus storage volume detach
- Detach custom storage volumes from instances
incus storage volume detach-profile
- Detach custom storage volumes from profiles
incus storage volume edit
- Edit storage volume configurations as YAML
incus storage volume export
- Export custom storage volumes
incus storage volume file
- Manage files in custom volumes
incus storage volume get
- Get values for storage volume configuration keys
incus storage volume import
- Import custom storage volumes
incus storage volume info
- Show storage volume state information
incus storage volume list
- List storage volumes
incus storage volume move
- Move custom storage volumes between pools
incus storage volume nbd
- NBD access to a block storage volume
incus storage volume rebuild
- Rebuild custom storage volumes
incus storage volume rename
- Rename custom storage volumes
incus storage volume set
- Set storage volume configuration keys
incus storage volume show
- Show storage volume configurations
incus storage volume snapshot
- Manage storage volume snapshots
incus storage volume unset
- Unset storage volume configuration keys
