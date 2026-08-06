# incus remote get-client-token

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/remote/get-client-token/
Fetched: 2026-08-07

incus
remote
get-client-token
¶
Generate a client token derived from the client certificate
Synopsis
¶
Description:
Generate a client trust token derived from the existing client certificate and private key.
This is useful for remote authentication workflows where a token is passed to another Incus server.
```
incus remote get-client-token <expiry> [flags]

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
