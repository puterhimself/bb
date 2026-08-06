# incus network zone create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/zone/create/
Fetched: 2026-08-07

incus
network
zone
create
¶
Create new network zones
Synopsis
¶
Description:
Create new network zones
```
incus network zone create [<remote>:]<new zone name> [<key>=<value>...] [flags]

```
Examples
¶
```
  incus network zone create z1
      Create network zone z1

  incus network zone create z1 < config.yaml
      Create network zone z1 with configuration from config.yaml

```
Options
¶
```
      --description   Zone description

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
incus network zone
- Manage network zones
