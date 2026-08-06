# incus low-level nvram set

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/low-level/nvram/set/
Fetched: 2026-08-07

incus
low-level
nvram
set
¶
Set values for UEFI variables
Synopsis
¶
Description:
Set values for UEFI variables.
```
incus low-level nvram set [<remote>:]<instance> <variable>=<value>... [flags]

```
Options
¶
```
      --attributes   Set the variable attributes (requires `--format=base64|binary|hex`) (default 7)
  -f, --format       Format (base64|binary|efivarfs|hex|json|yaml) (default "yaml")
      --timestamp    Set the variable timestamp (requires `--format=base64|binary|efivarfs|hex`)

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
incus low-level nvram
- Manage NVRAM on virtual machines
