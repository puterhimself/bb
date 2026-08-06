# incus project edit

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/project/edit/
Fetched: 2026-08-07

incus
project
edit
¶
Edit project configurations as YAML
Synopsis
¶
Description:
Edit project configurations as YAML
```
incus project edit [<remote>:]<project> [flags]

```
Examples
¶
```
  incus project edit <project> < project.yaml
      Update a project using the content of project.yaml

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
