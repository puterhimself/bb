# incus config template create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/config/template/create/
Fetched: 2026-08-07

incus
config
template
create
¶
Create new instance file templates
Synopsis
¶
Description:
Create new instance file templates
```
incus config template create [<remote>:]<instance> <new template name> [flags]

```
Examples
¶
```
  incus config template create u1 t1
      Create template t1 for instance u1

  incus config template create u1 t1 < config.tpl
      Create template t1 for instance u1 from config.tpl

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
incus config template
- Manage instance file templates
