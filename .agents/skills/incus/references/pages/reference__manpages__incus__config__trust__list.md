# incus config trust list

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/config/trust/list/
Fetched: 2026-08-07

incus
config
trust
list
¶
List trusted clients
Synopsis
¶
Description:
List trusted clients
The -c option takes a (optionally comma-separated) list of arguments
that control which certificate attributes to output when displaying in table
or csv format.
Default column layout is: ntdfe
Column shorthand chars:
n - Name
t - Type
c - Common Name
f - Fingerprint
d - Description
i - Issue date
e - Expiry date
r - Whether certificate is restricted
p - Newline-separated list of projects
```
incus config trust list [<remote>:] [<filter>...] [flags]

```
Options
¶
```
  -c, --columns   Columns (default "ntdfe")
  -f, --format    Format (csv|json|table|yaml|compact|markdown), use suffix ",noheader" to disable headers and ",header" to enable it if missing, e.g. csv,header (default "table")

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
