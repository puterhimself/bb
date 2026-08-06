# incus image copy

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/image/copy/
Fetched: 2026-08-07

incus
image
copy
¶
Copy images between servers
Synopsis
¶
Description:
Copy images between servers
The auto-update flag instructs the server to keep this image up to date.
It requires the source to be an alias and for it to be public.
```
incus image copy [<remote>:]<image> [<remote>:] [flags]

```
Options
¶
```
      --alias            New aliases to add to the image
      --auto-update      Keep the image up to date after initial copy
      --copy-aliases     Copy aliases from source
      --mode             Transfer mode. One of pull, push or relay (default "pull")
  -p, --profile          Profile to apply to the new image
      --public           Make image public
      --reuse            If an alias already exists, delete and recreate it
      --target-project   Copy to a project different from the source
      --vm               Copy virtual machine images

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
