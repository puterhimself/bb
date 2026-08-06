# incus profile assign

Source: https://linuxcontainers.org/incus/docs/main/reference/manpages/incus/profile/assign/
Fetched: 2026-08-07

incus
profile
assign
¶
Assign sets of profiles to instances
Synopsis
¶
Description:
Assign sets of profiles to instances
```
incus profile assign [<remote>:]<instance> (<profile>...|--no-profiles) [flags]

```
Examples
¶
```
  incus profile assign foo default bar
      Set the profiles for "foo" to "default" and "bar".

  incus profile assign foo default
      Reset "foo" to only using the "default" profile.

  incus profile assign foo --no-profiles
      Remove all profile assigned to "foo"

```
Options
¶
```
      --no-profiles   Remove all profiles from the instance

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
incus profile
- Manage profiles
