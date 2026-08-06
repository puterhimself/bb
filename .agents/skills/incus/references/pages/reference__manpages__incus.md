# incus

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/
Fetched: 2026-08-07

incus
¶
Command line client for Incus
Synopsis
¶
Description:
Command line client for Incus
All of Incus’s features can be driven through the various commands below.
For help with any of those, simply call them with –help.
Custom commands can be defined through aliases, use “incus alias” to control those.
Options
¶
```
  -a, --all            Show less common commands
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
incus admin
- Manage incus daemon
incus alias
- Manage command aliases
incus cluster
- Manage cluster members
incus config
- Manage instance and server configuration options
incus console
- Attach to instance consoles
incus copy
- Copy instances within or in between servers
incus create
- Create instances from images
incus default
- Manage client defaults
incus delete
- Delete instances
incus exec
- Execute commands in instances
incus export
- Export instance backups
incus file
- Manage files in instances
incus image
- Manage images
incus import
- Import instance backups
incus info
- Show instance or server information
incus launch
- Create and start instances from images
incus list
- List instances
incus low-level
- Low-level commands
incus manpage
- Generate manpages for all commands
incus monitor
- Monitor a local or remote server
incus move
- Move instances within or in between servers
incus network
- Manage and attach instances to networks
incus operation
- List, show and delete background operations
incus pause
- Pause instances
incus port-forward
- Forward a local TCP port to the instance
incus profile
- Manage profiles
incus project
- Manage projects
incus publish
- Publish instances as images
incus query
- Send a raw query to the server
incus rebuild
- Rebuild instances
incus remote
- Manage the list of remote servers
incus rename
- Rename instances
incus restart
- Restart instances
incus resume
- Resume instances
incus snapshot
- Manage instance snapshots
incus start
- Start instances
incus stop
- Stop instances
incus storage
- Manage storage pools and volumes
incus top
- Display resource usage info per instance
incus version
- Show local and remote versions
incus wait
- Wait for an instance to satisfy a condition
incus warning
- Manage warnings
incus webui
- Open the web interface
