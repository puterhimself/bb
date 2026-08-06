# incus storage volume file push

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/file/push/
Fetched: 2026-08-07

incus
storage
volume
file
push
¶
Push files into custom volumes
Synopsis
¶
Description:
Push files into custom volumes
```
incus storage volume file push <path> [<remote>:]<pool> <volume>/<target path> [flags]

```
Examples
¶
```
  incus storage volume file push /etc/hosts local v1/etc/hosts
     To push /etc/hosts into the custom volume "v1".

  echo "Hello world" | incus storage volume file push - local v1 test
     To read "Hello world" from standard input and write it into test in volume "v1".

```
Options
¶
```
  -p, --create-dirs      Create any directories necessary
  -L, --dereference      Always follow symbolic links in source path
  -H, --follow           Follow command-line symbolic links in source path
      --gid              Set the file's gid on push (default -1)
      --mode             Set the file's perms on push
  -P, --no-dereference   Never follow symbolic links in source path
  -r, --recursive        Recursively transfer files
      --uid              Set the file's uid on push (default -1)

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
