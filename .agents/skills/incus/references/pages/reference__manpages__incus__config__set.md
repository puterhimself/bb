# incus config set

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/config/set/
Fetched: 2026-08-07

incus
config
set
¶
Set instance or server configuration keys
Synopsis
¶
Description:
Set instance or server configuration keys
For backward compatibility, a single configuration key may still be set with:
incus config set [
:][
]
```
incus config set [<remote>:][<instance>[/<snapshot>]] <key>=<value>... [flags]

```
Examples
¶
```
  incus config set [<remote>:]<instance> limits.cpu=2
      Will set a CPU limit of "2" for the instance.

  incus config set my-instance cloud-init.user-data - < cloud-init.yaml
      Sets the cloud-init user-data for instance "my-instance" by reading "cloud-init.yaml" through stdin.

  incus config set core.https_address=[::]:8443
      Will have the server listen on IPv4 and IPv6 port 8443.

```
Options
¶
```
  -p, --property   Set the key as an instance property
      --target     Cluster member name

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
