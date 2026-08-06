# incus file create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/file/create/
Fetched: 2026-08-07

incus
file
create
¶
Create files and directories in instances
Synopsis
¶
Description:
Create files and directories in instances
```
incus file create [<remote>:]<instance>/<path> [<symlink target path>] [flags]

```
Examples
¶
```
  incus file create foo/bar
     To create a file /bar in the foo instance.

  incus file create --type=symlink foo/bar baz
     To create a symlink /bar in instance foo whose target is baz.

```
Options
¶
```
  -p, --create-dirs   Create any directories necessary
  -f, --force         Force creating files or directories
      --gid           Set the file's gid on create (default -1)
      --mode          Set the file's perms on create
  -t, --type          The type to create (file, symlink, or directory) (default "file")
      --uid           Set the file's uid on create (default -1)

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
