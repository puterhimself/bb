# incus port-forward

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/port-forward/
Fetched: 2026-08-07

incus
port-forward
¶
Forward a local TCP port to the instance
Synopsis
¶
Description:
Forward a local TCP port to the instance
This runs a local TCP listener and forwards every connection made to it
to the given address and port inside of the instance.
Both ports can be prefixed with an address to use (“ADDRESS:PORT”),
defaulting to 127.0.0.1 otherwise. IPv6 addresses must be wrapped in
square brackets (e.g. “[::1]:80”).
```
incus port-forward [<remote>:]<instance> <target port> <listen port> [flags]

```
Examples
¶
```
  incus port-forward c1 80 8080
      Forward local port 8080 to port 80 inside of the instance.

  incus port-forward c1 10.0.3.1:443 0.0.0.0:8443
      Forward port 8443 on all local addresses to 10.0.3.1:443 inside of the instance.

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
