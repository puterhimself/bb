# incus image edit

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/image/edit/
Fetched: 2026-08-07

incus
image
edit
¶
Edit image properties
Synopsis
¶
Description:
Edit image properties
```
incus image edit [<remote>:]<image> [flags]

```
Examples
¶
```
  incus image edit <image>
      Launch a text editor to edit the properties

  incus image edit <image> < image.yaml
      Load the image properties from a YAML file

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
