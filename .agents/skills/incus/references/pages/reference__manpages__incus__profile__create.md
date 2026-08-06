# incus profile create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/profile/create/
Fetched: 2026-08-07

incus
profile
create
¶
Create profiles
Synopsis
¶
Description:
Create profiles
```
incus profile create [<remote>:]<new profile name> [flags]

```
Examples
¶
```
  incus profile create p1
      Create a profile named p1

  incus profile create p1 < config.yaml
      Create a profile named p1 with configuration from config.yaml

```
Options
¶
```
      --description   Profile description

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
incus profile
- Manage profiles
