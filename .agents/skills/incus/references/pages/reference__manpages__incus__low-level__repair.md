# incus low-level repair

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/low-level/repair/
Fetched: 2026-08-07

incus
low-level
repair
¶
Run a repair action on an instance
Synopsis
¶
Description:
Run a low-level repair action on an instance.
Supported actions:
rebuild-config-volume    Rebuild the config volume of a stopped QCOW2 backed virtual machine
rebuild-nvram            Rebuild the virtual machine’s UEFI NVRAM
```
incus low-level repair [<remote>:]<instance> <action> [flags]

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
incus low-level
- Low-level commands
