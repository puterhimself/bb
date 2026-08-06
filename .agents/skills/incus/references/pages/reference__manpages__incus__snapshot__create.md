# incus snapshot create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/snapshot/create/
Fetched: 2026-08-07

incus
snapshot
create
¶
Create instance snapshot
Synopsis
¶
Description:
Create instance snapshots
When –stateful is used, attempt to checkpoint the instance’s
running state, including process memory state, TCP connections, …
```
incus snapshot create [<remote>:]<instance> [<new snapshot name>] [flags]

```
Examples
¶
```
  incus snapshot create u1 snap0
  	Create a snapshot of "u1" called "snap0".

  incus snapshot create u1 snap0 < config.yaml
  	Create a snapshot of "u1" called "snap0" with the configuration from "config.yaml".

```
Options
¶
```
      --expiry      Expiry for the new snapshot (either a time span like `1d 3H` or a date in `2006/01/02 15:04 MST` format)
      --no-expiry   Ignore any configured auto-expiry for the instance
      --reuse       If the snapshot name already exists, delete and create a new one
      --stateful    Whether or not to snapshot the instance's running state

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
incus snapshot
- Manage instance snapshots
