# incus cluster evacuate

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/cluster/evacuate/
Fetched: 2026-08-07

incus
cluster
evacuate
¶
Evacuate cluster member
Synopsis
¶
Description:
Evacuate cluster member
The action flag allows overriding the default server-side action (“cluster.evacuate” instance configuration option)
```
incus cluster evacuate [<remote>:]<member> [flags]

```
Options
¶
```
      --action   Force a particular evacuation action
  -f, --force    Force evacuation without user confirmation

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
incus cluster
- Manage cluster members
