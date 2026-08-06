# incus file mount

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/file/mount/
Fetched: 2026-08-07

incus
file
mount
¶
Mount files from instances
Synopsis
¶
Description:
Mount files from instances.
If no target path is provided, start an SSH SFTP listener instead.
```
incus file mount [<remote>:]<instance>[/<path>] [<target path>] [flags]

```
Examples
¶
```
  incus file mount foo/root fooroot
     To mount /root from the instance foo onto the local fooroot directory.

  incus file mount foo
     To start an SSH SFTP listener for the root filesystem of instance foo.

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
incus file
- Manage files in instances
