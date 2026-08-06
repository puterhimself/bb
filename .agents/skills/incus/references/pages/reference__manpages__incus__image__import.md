# incus image import

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/image/import/
Fetched: 2026-08-07

incus
image
import
¶
Import images into the image store
Synopsis
¶
Description:
Import image into the image store
Directory import is only available on Linux and must be performed as root.
```
incus image import (<tarball>|<directory>|<URL>) [<rootfs tarball>] [<remote>:] [<key>=<value>...] [flags]

```
Options
¶
```
      --alias    New aliases to add to the image
      --public   Make image public
      --reuse    If the image alias already exists, delete and create a new one

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
