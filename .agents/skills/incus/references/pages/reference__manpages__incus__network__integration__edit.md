# incus network integration edit

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/integration/edit/
Fetched: 2026-08-07

incus
network
integration
edit
¶
Edit network integration configurations as YAML
Synopsis
¶
Description:
Edit network integration configurations as YAML
```
incus network integration edit [<remote>:]<network integration> [flags]

```
Examples
¶
```
  incus network integration edit <network integration> < network-integration.yaml
      Update a network integration using the content of network-integration.yaml

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
