# incus remote proxy

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/remote/proxy/
Fetched: 2026-08-07

incus
remote
proxy
¶
Run a local API proxy
Synopsis
¶
Description:
Run a local API proxy for the remote
```
incus remote proxy <remote>: <target unix socket file> [flags]

```
Options
¶
```
      --timeout   Proxy timeout (exits when no connections)

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
