# incus network peer create

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/network/peer/create/
Fetched: 2026-08-07

incus
network
peer
create
¶
Create new network peering
Synopsis
¶
Description:
Create new network peering
```
incus network peer create [<remote>:]<network> <new peer name> [<target project>/]<target network or integration> [<key>=<value>...] [flags]

```
Examples
¶
```
  incus network peer create default peer1 web/default
      Create a new peering between network "default" in the current project and network "default" in the "web" project

  incus network peer create default peer2 ovn-ic --type=remote
      Create a new peering between network "default" in the current project and other remote networks through the "ovn-ic" integration

  incus network peer create default peer3 web/default < config.yaml
  	Create a new peering between network default in the current project and network default in the web project using the configuration
  	in the file config.yaml

```
Options
¶
```
      --description   Peer description
  -t, --type          Type of peer (local or remote) (default "local")

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
incus network peer
- Manage network peerings
