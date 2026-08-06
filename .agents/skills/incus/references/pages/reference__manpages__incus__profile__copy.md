# incus profile copy

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/profile/copy/
Fetched: 2026-08-07

incus
profile
copy
¶
Copy profiles
Synopsis
¶
Description:
Copy profiles
```
incus profile copy [<remote>:]<profile> [<remote>:]<new profile name> [flags]

```
Options
¶
```
      --refresh          Update the target profile from the source if it already exists
      --target-project   Copy to a project different from the source

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
