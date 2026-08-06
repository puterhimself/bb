# incus profile edit

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/profile/edit/
Fetched: 2026-08-07

incus
profile
edit
¶
Edit profile configurations as YAML
Synopsis
¶
Description:
Edit profile configurations as YAML
```
incus profile edit [<remote>:]<profile> [flags]

```
Examples
¶
```
  incus profile edit <profile> < profile.yaml
      Update a profile using the content of profile.yaml

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
