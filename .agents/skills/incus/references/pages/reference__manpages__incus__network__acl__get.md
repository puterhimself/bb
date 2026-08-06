# incus network acl get

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/acl/get/
Fetched: 2026-08-07

incus
network
acl
get
¶
Get values for network ACL configuration keys
Synopsis
¶
Description:
Get values for network ACL configuration keys
```
incus network acl get [<remote>:]<ACL> <key> [flags]

```
Options
¶
```
  -p, --property   Get the key as a network ACL property

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
incus network acl
- Manage network ACLs
