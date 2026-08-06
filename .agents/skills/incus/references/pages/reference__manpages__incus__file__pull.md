# incus file pull

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/file/pull/
Fetched: 2026-08-07

incus
file
pull
¶
Pull files from instances
Synopsis
¶
Description:
Pull files from instances
```
incus file pull [<remote>:]<instance>/<path>... <target path> [flags]

```
Examples
¶
```
  incus file pull foo/etc/hosts .
     To pull /etc/hosts from the instance and write it to the current directory.

  incus file pull foo/etc/hosts -
     To pull /etc/hosts from the instance and write its output to standard output.

```
Options
¶
```
  -p, --create-dirs      Create any directories necessary
  -L, --dereference      Always follow symbolic links in source path
  -H, --follow           Follow command-line symbolic links in source path
  -P, --no-dereference   Never follow symbolic links in source path
  -r, --recursive        Recursively transfer files

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
