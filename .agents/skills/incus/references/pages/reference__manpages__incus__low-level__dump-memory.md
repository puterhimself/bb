# incus low-level dump-memory

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/low-level/dump-memory/
Fetched: 2026-08-07

incus
low-level
dump-memory
¶
Export a virtual machine’s memory state
Synopsis
¶
Description:
Export the current memory state of a running virtual machine into a dump file.
This can be useful for debugging or analysis purposes.
```
incus low-level dump-memory [<remote>:]<instance> <target file> [flags]

```
Examples
¶
```
  incus low-level dump-memory vm1 memory-dump.elf --format=elf
      Creates an ELF format memory dump of the vm1 instance.

```
Options
¶
```
  -f, --format   Format of memory dump (e.g. elf, win-dmp, kdump-zlib, kdump-raw-zlib, ...) (default "elf")

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
