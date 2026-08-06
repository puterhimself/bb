# incus cluster

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/cluster/
Fetched: 2026-08-07

incus
cluster
¶
Manage cluster members
Synopsis
¶
Description:
Manage cluster members
```
incus cluster [flags]

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
incus cluster add
- Request a join token for adding a cluster member
incus cluster edit
- Edit cluster member configurations as YAML
incus cluster enable
- Enable clustering on a single non-clustered server
incus cluster evacuate
- Evacuate cluster member
incus cluster get
- Get values for cluster member configuration keys
incus cluster group
- Manage cluster groups
incus cluster info
- Show useful information about a cluster member
incus cluster join
- Join an existing server to a cluster
incus cluster list
- List all the cluster members
incus cluster list-tokens
- List all active cluster member join tokens
incus cluster remove
- Remove a member from the cluster
incus cluster rename
- Rename a cluster member
incus cluster restore
- Restore cluster member
incus cluster revoke-token
- Revoke cluster member join token
incus cluster role
- Manage cluster roles
incus cluster set
- Set a cluster member’s configuration keys
incus cluster show
- Show details of a cluster member
incus cluster unset
- Unset a cluster member’s configuration keys
incus cluster update-certificate
- Update cluster certificate
