# incus admin waitready

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/admin/waitready/
Fetched: 2026-08-07

incus
admin
waitready
¶
Wait for the daemon to be ready to process requests
Synopsis
¶
Description:
Wait for the daemon to be ready to process requests
This command will block until the daemon is reachable over its REST API and
is done with early start tasks like re-starting previously started
containers.
```
incus admin waitready [flags]

```
Options
¶
```
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
