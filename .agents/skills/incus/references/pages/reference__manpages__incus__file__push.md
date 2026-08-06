# incus file push

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/file/push/
Fetched: 2026-08-07

incus
file
push
¶
Push files into instances
Synopsis
¶
Description:
Push files into instances
```
incus file push <path>... [<remote>:]<instance>/<target path> [flags]

```
Examples
¶
```
  incus file push /etc/hosts foo/etc/hosts
     To push /etc/hosts into the instance "foo".

  echo "Hello world" | incus file push - foo/root/test
     To read "Hello world" from standard input and write it into /root/test in instance "foo".

```
Options
¶
```
  -p, --create-dirs      Create any directories necessary
  -L, --dereference      Always follow symbolic links in source path
  -H, --follow           Follow command-line symbolic links in source path
      --gid              Set the files' GIDs on push (default -1)
      --mode             Set the file's perms on push (in recursive mode, only sets the target directory's permissions)
  -P, --no-dereference   Never follow symbolic links in source path
  -r, --recursive        Recursively transfer files
      --uid              Set the files' UIDs on push (default -1)

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
