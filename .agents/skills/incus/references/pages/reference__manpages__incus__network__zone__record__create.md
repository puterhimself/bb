# incus network zone record create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/zone/record/create/
Fetched: 2026-08-07

incus
network
zone
record
create
¶
Create new network zone record
Synopsis
¶
Description:
Create new network zone record
```
incus network zone record create [<remote>:]<zone> <new record name> [<key>=<value>...] [flags]

```
Examples
¶
```
  incus network zone record create z1 r1
      Create record r1 for zone z1

  incus network zone record create z1 r1 < config.yaml
      Create record r1 for zone z1 with configuration from config.yaml

```
Options
¶
```
      --description   Record description

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
incus network zone record
- Manage network zone records
