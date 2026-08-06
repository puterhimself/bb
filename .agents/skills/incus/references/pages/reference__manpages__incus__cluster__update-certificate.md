# incus cluster update-certificate

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/cluster/update-certificate/
Fetched: 2026-08-07

incus
cluster
update-certificate
¶
Update cluster certificate
Synopsis
¶
Description:
Update cluster certificate with PEM certificate and key read from input files.
```
incus cluster update-certificate [<remote>:] <cert.crt> <cert.key> [flags]

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
incus cluster
- Manage cluster members
