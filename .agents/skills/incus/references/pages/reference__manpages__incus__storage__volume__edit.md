# incus storage volume edit

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/storage/volume/edit/
Fetched: 2026-08-07

incus
storage
volume
edit
¶
Edit storage volume configurations as YAML
Synopsis
¶
Description:
Edit storage volume configurations as YAML
If the type is not specified, incus assumes the type is “custom”.
Supported values for type are “custom”, “container” and “virtual-machine”.
```
incus storage volume edit [<remote>:]<pool> [<type>/]<volume>[/<snapshot>] [flags]

```
Examples
¶
```
  incus storage volume edit default container/c1
      Edit container storage volume "c1" in pool "default"

  incus storage volume edit default foo < volume.yaml
      Edit custom storage volume "foo" in pool "default" using the content of volume.yaml

```
Options
¶
```
      --target   Cluster member name

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
