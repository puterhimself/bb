# incus image generate-metadata

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/image/generate-metadata/
Fetched: 2026-08-07

incus
image
generate-metadata
¶
Generate a metadata tarball
Synopsis
¶
Description:
Generate a metadata tarball
This command produces an incus.tar.xz tarball for use during import with an existing QCOW2 or squashfs disk image.
This command will prompt for all of the metadata tarball fields:
- Operating system name
- Release
- Variant
- Architecture
- Description
```
incus image generate-metadata <target path> [flags]

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
incus image
- Manage images
