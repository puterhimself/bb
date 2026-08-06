# incus remote get-client-certificate

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/remote/get-client-certificate/
Fetched: 2026-08-07

incus
remote
get-client-certificate
¶
Print or retrieve the client certificate used by this Incus client
```
incus remote get-client-certificate [<target file>] [flags]

```
Options
¶
```
  -f, --format   Format (pem|pfx) (default "pem")

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
