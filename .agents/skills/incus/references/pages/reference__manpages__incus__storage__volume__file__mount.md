# incus storage volume file mount

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/file/mount/
Fetched: 2026-08-07

incus
storage
volume
file
mount
¶
Mount files from custom storage volumes
Synopsis
¶
Description:
Mount files from custom storage volumes.
If no target path is provided, start an SSH SFTP listener instead.
```
incus storage volume file mount [<remote>:]<pool> <volume> [<target path>] [flags]

```
Examples
¶
```
  incus storage volume file mount mypool myvolume localdir
     To mount the storage volume myvolume from pool mypool onto the local directory localdir.

  incus storage volume file mount mypool myvolume
     To start an SSH SFTP listener for the storage volume myvolume from pool mypool.

```
Options
¶
```
      --auth-user   Set authentication user when using SSH SFTP listener
      --listen      Setup SSH SFTP listener on address:port instead of mounting
      --no-auth     Disable authentication when using SSH SFTP listener

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
incus storage volume file
- Manage files in custom volumes
