# incus image alias create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/image/alias/create/
Fetched: 2026-08-07

incus
image
alias
create
¶
Create aliases for existing images
Synopsis
¶
Description:
Create aliases for existing images
```
incus image alias create [<remote>:]<new alias name> <fingerprint> [flags]

```
Options
¶
```
      --description   Image alias description

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
incus image alias
- Manage image aliases
