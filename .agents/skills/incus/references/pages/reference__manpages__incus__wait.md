# incus wait

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/wait/
Fetched: 2026-08-07

incus
wait
¶
Wait for an instance to satisfy a condition
Synopsis
¶
Description:
Wait for an instance to satisfy a condition
Supported Conditions:
agent            Wait for the VM agent to be running
ip               Wait for any globally routable IP address
ipv4             Wait for a globally routable IPv4 address
ipv6             Wait for a globally routable IPv6 address
status=STATUS    Wait for the instance status to become STATUS
```
incus wait [<remote>:]<instance> <condition> [flags]

```
Examples
¶
```
  incus wait v1 agent
  	Wait for VM instance v1 to have a functional agent.

```
Options
¶
```
      --interval   Polling interval (in seconds) (default 5)
      --timeout    Maximum wait time (default -1)

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
