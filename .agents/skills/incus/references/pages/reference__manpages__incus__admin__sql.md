# incus admin sql

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/admin/sql/
Fetched: 2026-08-07

incus
admin
sql
¶
Execute a SQL query against the local or global database
Synopsis
¶
Description:
Execute a SQL query against the local or global database
The local database is specific to the cluster member you target the
command to, and contains member-specific data (such as the member network
address).
The global database is common to all members in the cluster, and contains
cluster-specific data (such as profiles, containers, etc).
Non-clustered servers still have both local and global databases.
If
is the special value “-”, then the query is read from
standard input.
If
is the special value “.dump”, the command returns a SQL text
dump of the given database.
If
is the special value “.schema”, the command returns the SQL
text schema of the given database.
If
is the special value “.tables”, the command returns the SQL
text tables of the given database.
This internal command is mostly useful for debugging and disaster
recovery. The development team will occasionally provide hotfixes to users as a
set of database queries to fix some data inconsistency.
```
incus admin sql [<remote>:](local|global) <query> [flags]

```
Options
¶
```
  -f, --format   Format (csv|json|table|yaml|compact|markdown), use suffix ",noheader" to disable headers and ",header" to enable it if missing, e.g. csv,header (default "table")

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
incus admin
- Manage incus daemon
