# incus network address-set create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/address-set/create/
Fetched: 2026-08-07

incus
network
address-set
create
¶
Create new network address sets
Synopsis
¶
Description:
Create new network address sets
```
incus network address-set create [<remote>:]<new address set name> [<key>=<value>...] [flags]

```
Examples
¶
```
  incus network address-set create as1
      Create network address set as1

  incus network address-set create as1 < config.yaml
      Create network address set with configuration from config.yaml

```
Options
¶
```
      --description   Network address set description

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
incus network address-set
- Manage network address sets
