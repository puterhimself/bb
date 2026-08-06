# incus config trust

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/config/trust/
Fetched: 2026-08-07

incus
config
trust
¶
Manage trusted clients
Synopsis
¶
Description:
Manage trusted clients
```
incus config trust [flags]

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
incus config
- Manage instance and server configuration options
incus config trust add
- Add new trusted client
incus config trust add-certificate
- Add new trusted client certificate
incus config trust edit
- Edit trust configurations as YAML
incus config trust list
- List trusted clients
incus config trust list-tokens
- List all active certificate add tokens
incus config trust remove
- Remove trusted client
incus config trust revoke-token
- Revoke certificate add token
incus config trust show
- Show trust configurations
