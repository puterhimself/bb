# incus network integration create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/integration/create/
Fetched: 2026-08-07

incus
network
integration
create
¶
Create network integrations
Synopsis
¶
Description:
Create network integrations
```
incus network integration create [<remote>:]<new network integration name> <type> [flags]

```
Examples
¶
```
  incus network integration create o1 ovn
     Create network integration o1 of type ovn

  incus network integration create o1 ovn < config.yaml
      Create network integration o1 of type ovn with configuration from config.yaml

```
Options
¶
```
  -c, --config   Config key/value to apply to the new network integration

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
incus network integration
- Manage network integrations
