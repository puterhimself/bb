# incus admin shutdown

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/admin/shutdown/
Fetched: 2026-08-07

incus
admin
shutdown
¶
Tell the daemon to shutdown all instances and exit
Synopsis
¶
Description:
Tell the daemon to shutdown all instances and exit
This will tell the daemon to start a clean shutdown of all instances,
followed by having itself shutdown and exit.
This can take quite a while as instances can take a long time to
shutdown, especially if a non-standard timeout was configured for them.
```
incus admin shutdown [flags]

```
Options
¶
```
  -f, --force     Force shutdown instead of waiting for running operations to finish
  -t, --timeout   Number of seconds to wait before giving up

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
incus admin
- Manage incus daemon
