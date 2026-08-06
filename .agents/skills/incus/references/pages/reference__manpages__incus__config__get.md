# incus config get

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/config/get/
Fetched: 2026-08-07

incus
config
get
¶
Get values for instance or server configuration keys
Synopsis
¶
Description:
Get values for instance or server configuration keys
```
incus config get [<remote>:][<instance>[/<snapshot>]] <key> [flags]

```
Options
¶
```
  -e, --expanded   Access the expanded configuration
  -p, --property   Get the key as an instance property
      --target     Cluster member name

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
incus config
- Manage instance and server configuration options
