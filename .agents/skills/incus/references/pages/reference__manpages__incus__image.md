# incus image

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/image/
Fetched: 2026-08-07

incus
image
¶
Manage images
Synopsis
¶
Description:
Manage images
Instances are created from images. Those images were themselves
either generated from an existing instance or downloaded from an image
server.
When using remote images, the server will automatically cache images for you
and remove them upon expiration.
The image unique identifier is the hash (sha-256) of its representation
as a compressed tarball (or for split images, the concatenation of the
metadata and rootfs tarballs).
Images can be referenced by their full hash, shortest unique partial
hash or alias name (if one is set).
```
incus image [flags]

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
incus
- Command line client for Incus
incus image alias
- Manage image aliases
incus image copy
- Copy images between servers
incus image delete
- Delete images
incus image edit
- Edit image properties
incus image export
- Export and download images
incus image generate-metadata
- Generate a metadata tarball
incus image get-property
- Get image properties
incus image import
- Import images into the image store
incus image info
- Show useful information about images
incus image list
- List images
incus image refresh
- Refresh images
incus image set-property
- Set image properties
incus image show
- Show image properties
incus image unset-property
- Unset image properties
