# incus admin init

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/admin/init/
Fetched: 2026-08-07

incus
admin
init
¶
Configure the daemon
Synopsis
¶
Description:
Configure the daemon
```
incus admin init [--preseed [<preseed.yaml>]] [flags]

```
Examples
¶
```
  init --minimal
  init --auto [--network-address=IP] [--network-port=8443] [--storage-backend=dir]
              [--storage-create-device=DEVICE] [--storage-create-loop=SIZE]
              [--storage-pool=POOL]
  init --preseed [preseed.yaml]
  init --dump

```
Options
¶
```
      --auto                    Automatic (non-interactive) mode
      --dump                    Dump YAML config to stdout
      --minimal                 Minimal configuration (non-interactive)
      --network-address         Address to bind to (default: none)
      --network-port            Port to bind to (default: 8443) (default -1)
      --preseed                 Pre-seed mode, expects YAML config from stdin
      --storage-backend         Storage backend to use (btrfs, dir, lvm or zfs, default: dir)
      --storage-create-device   Setup device based storage using DEVICE
      --storage-create-loop     Setup loop based storage with SIZE in GiB (default -1)
      --storage-pool            Storage pool to use or create

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
