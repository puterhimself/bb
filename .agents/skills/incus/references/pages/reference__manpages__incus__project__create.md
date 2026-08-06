# incus project create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/project/create/
Fetched: 2026-08-07

incus
project
create
¶
Create projects
Synopsis
¶
Description:
Create projects
```
incus project create [<remote>:]<new project name> [flags]

```
Examples
¶
```
  incus project create p1
      Create a project named p1

  incus project create p1 < config.yaml
      Create a project named p1 with configuration from config.yaml

```
Options
¶
```
  -c, --config        Config key/value to apply to the new project
      --description   Project description

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
incus project
- Manage projects
