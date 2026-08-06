# incus storage create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/create/
Fetched: 2026-08-07

incus
storage
create
¶
Create storage pools
Synopsis
¶
Description:
Create storage pools
```
incus storage create [<remote>:]<new pool name> <driver> [<key>=<value>...] [flags]

```
Examples
¶
```
  incus storage create s1 dir
      Create a storage pool s1

  incus storage create s1 dir < config.yaml
      Create a storage pool s1 using the content of config.yaml
  	

```
Options
¶
```
      --description   Storage pool description
      --target        Cluster member name

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
incus storage
- Manage storage pools and volumes
