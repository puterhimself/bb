# incus profile device add

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/profile/device/add/
Fetched: 2026-08-07

incus
profile
device
add
¶
Add instance devices
Synopsis
¶
Description:
Add instance devices
```
incus profile device add [<remote>:]<profile> <new device name> <type> [<key>=<value>...] [flags]

```
Examples
¶
```
  incus profile device add [<remote>:]profile1 <device-name> disk source=/share/c1 path=/opt
      Will mount the host's /share/c1 onto /opt in the instance.

  incus profile device add [<remote>:]profile1 <device-name> disk pool=some-pool source=some-volume path=/opt
      Will mount the some-volume volume on some-pool onto /opt in the instance.

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
incus profile device
- Manage devices
