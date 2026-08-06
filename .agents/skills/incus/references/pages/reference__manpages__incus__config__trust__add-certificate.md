# incus config trust add-certificate

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/config/trust/add-certificate/
Fetched: 2026-08-07

incus
config
trust
add-certificate
¶
Add new trusted client certificate
Synopsis
¶
Description:
Add new trusted client certificate
The following certificate types are supported:
- client (default)
- metrics
```
incus config trust add-certificate [<remote>:] <cert.crt> [flags]

```
Options
¶
```
      --description   Certificate description
      --name          Alternative certificate name
      --projects      List of projects to restrict the certificate to
      --restricted    Restrict the certificate to one or more projects
  -t, --type          Type of certificate (default "client")

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
