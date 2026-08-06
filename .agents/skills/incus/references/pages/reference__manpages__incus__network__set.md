# incus network set

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/set/
Fetched: 2026-08-07

incus
network
set
¶
Set network configuration keys
Synopsis
¶
Description:
Set network configuration keys
For backward compatibility, a single configuration key may still be set with:
incus network set [
:]
```
incus network set [<remote>:]<network> <key>=<value>... [flags]

```
Options
¶
```
  -p, --property   Set the key as a network property
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
incus network
- Manage and attach instances to networks
