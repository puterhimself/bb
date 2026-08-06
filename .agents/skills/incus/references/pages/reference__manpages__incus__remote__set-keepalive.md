# incus remote set-keepalive

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/remote/set-keepalive/
Fetched: 2026-08-07

incus
remote
set-keepalive
¶
Set a keepalive timeout for a remote
Synopsis
¶
Description:
Set a keepalive timeout for a remote
```
incus remote set-keepalive <remote> <keepalive timeout> [flags]

```
Examples
¶
```
  incus remote set-keepalive my-remote 30
      Set a keepalive with 30 seconds timeout for my-remote

  incus remote set-keepalive my-remote 0
      Disable keeplive for my-remote

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
incus remote
- Manage the list of remote servers
