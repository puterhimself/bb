# incus low-level nbd

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/low-level/nbd/
Fetched: 2026-08-07

incus
low-level
nbd
¶
NBD access to all of a virtual machine’s disks
Synopsis
¶
Description:
NBD access to all of a virtual machine’s disks
This exposes all the disks of a running virtual machine over a local NBD
server, with each disk reachable as an NBD export named after its Incus
device name.
```
incus low-level nbd [<remote>:]<instance> [flags]

```
Options
¶
```
      --address   Specific address to listen on

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
