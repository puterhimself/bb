# incus config trust add

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/config/trust/add/
Fetched: 2026-08-07

incus
config
trust
add
¶
Add new trusted client
Synopsis
¶
Description:
Add new trusted client
This will issue a trust token to be used by the client to add itself to the trust store.
```
incus config trust add [<remote>:]<new client name> [flags]

```
Options
¶
```
      --projects     List of projects to restrict the certificate to
      --restricted   Restrict the certificate to one or more projects

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
incus config trust
- Manage trusted clients
