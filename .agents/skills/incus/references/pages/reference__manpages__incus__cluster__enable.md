# incus cluster enable

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/cluster/enable/
Fetched: 2026-08-07

incus
cluster
enable
¶
Enable clustering on a single non-clustered server
Synopsis
¶
Description:
Enable clustering on a single non-clustered server
This command turns a non-clustered server into the first member of a new
cluster, which will have the given name.
It’s required that the server is already available on the network. You can check
that by running ‘incus config get core.https_address’, and possibly set a value
for the address if not yet set.
```
incus cluster enable [<remote>:] <new member name> [flags]

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
