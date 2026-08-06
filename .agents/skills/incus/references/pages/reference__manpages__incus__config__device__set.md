# incus config device set

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/config/device/set/
Fetched: 2026-08-07

incus
config
device
set
¶
Set device configuration keys
Synopsis
¶
Description:
Set device configuration keys
For backward compatibility, a single configuration key may still be set with:
incus config device set [
:]
```
incus config device set [<remote>:]<instance> <device> <key>=<value>... [flags]

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
incus config device
- Manage devices
