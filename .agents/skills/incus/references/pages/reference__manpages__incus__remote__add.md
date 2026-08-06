# incus remote add

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/remote/add/
Fetched: 2026-08-07

incus
remote
add
¶
Add new remote servers
Synopsis
¶
Description:
Add new remote servers
URL for remote resources must be HTTPS (https://).
Basic authentication can be used when combined with the “simplestreams” protocol:
incus remote add some-name
https://LOGIN:PASSWORD@example.com/some/path
–protocol=simplestreams
Several remote targets can be provided, to handle switching to other servers if one is down:
incus remote add some-name server1.example.com server2.example.com
The remote name can be ignored if a single target is provided.
```
incus remote add [<new remote name>] (<IP/FQDN/URL>...|<token>) [flags]

```
Options
¶
```
      --accept-certificate   Accept certificate
      --auth-type            Server authentication type (tls or oidc)
      --credentials-helper   Binary helper for retrieving credentials
      --keepalive            Maintain remote connection for faster commands
      --project              Project to use for the remote
      --protocol             Server protocol (incus, oci or simplestreams) (default "incus")
      --public               Public image server
      --token                Remote trust token

```
Options inherited from parent commands
¶
```
      --debug          Show all debug messages
      --explain        If the command is valid, explain its parsed arguments instead of running it
      --force-local    Force using the local unix socket
  -h, --help           Print help
  -q, --quiet          Don't show progress information
      --sub-commands   Use with help or --help to view sub-commands
  -v, --verbose        Show all information messages
      --version        Print version number

```
SEE ALSO
¶
incus remote
- Manage the list of remote servers
