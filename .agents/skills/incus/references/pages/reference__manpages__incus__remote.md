# incus remote

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/remote/
Fetched: 2026-08-07

incus
remote
¶
Manage the list of remote servers
Synopsis
¶
Description:
Manage the list of remote servers
```
incus remote [flags]

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
incus
- Command line client for Incus
incus remote add
- Add new remote servers
incus remote generate-certificate
- Generate the client certificate
incus remote get-client-certificate
- Print or retrieve the client certificate used by this Incus client
incus remote get-client-token
- Generate a client token derived from the client certificate
incus remote get-default
- Show the default remote
incus remote list
- List the available remotes
incus remote proxy
- Run a local API proxy
incus remote remove
- Remove remotes
incus remote rename
- Rename remotes
incus remote set-keepalive
- Set a keepalive timeout for a remote
incus remote set-urls
- Set the URL(s) for the remote
incus remote switch
- Switch the default remote
