# incus config edit

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/config/edit/
Fetched: 2026-08-07

incus
config
edit
¶
Edit instance or server configurations as YAML
Synopsis
¶
Description:
Edit instance or server configurations as YAML
```
incus config edit [<remote>:][<instance>[/<snapshot>]] [flags]

```
Examples
¶
```
  incus config edit <instance> < instance.yaml
      Update the instance configuration from instance.yaml.

```
Options
¶
```
      --target   Cluster member name

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
