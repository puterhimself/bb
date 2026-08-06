# incus storage volume copy

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/copy/
Fetched: 2026-08-07

incus
storage
volume
copy
¶
Copy custom storage volumes
Synopsis
¶
Description:
Copy custom storage volumes
```
incus storage volume copy [<remote>:]<pool>/<volume>[/<snapshot>] [<remote>:]<pool>/<new volume name> [flags]

```
Options
¶
```
      --destination-target      Destination cluster member name
      --mode                    Transfer mode. One of pull, push or relay (default "pull")
      --refresh                 Refresh and update the existing storage volume copies
      --refresh-exclude-older   During refresh, exclude source snapshots earlier than latest target snapshot
      --target                  Cluster member name
      --target-project          Copy to a project different from the source
      --volume-only             Copy the volume without its snapshots

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
incus storage volume
- Manage storage volumes
