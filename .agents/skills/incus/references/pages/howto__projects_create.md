# How to create and configure projects

Source: https://linuxcontainers.org/incus/docs/main/howto/projects_create/
Fetched: 2026-08-07

How to create and configure projects
¶
You can configure projects at creation time or later.
However, note that it is not possible to modify the features that are enabled for a project when the project contains instances.
Create a project
¶
To create a project, use the
incus
project
create
command.
For example, to create a project called
my-project
, enter the following command:
```
incus project create my-project

```
You can specify configuration options by using the
--config
flag.
See
Project configuration
for the available configuration options.
For example, to create a project called
my-project-shared-images
that isolates instances but allows access to the default project’s images, enter the following command:
```
incus project create my-project-shared-images --config features.images=false

```
To create a project called
my-restricted-project
that blocks access to security-sensitive features (for example, container nesting) but allows backups, enter the following command:
```
incus project create my-restricted-project --config restricted=true --config restricted.backups=allow

```
Tip
When you create a project without specifying configuration options,
features.profiles
is set to
true
, which means that profiles are isolated in the project.
Consequently, the new project does not have access to the
default
profile of the
default
project and therefore misses required configuration for creating instances (like the root disk).
To fix this, use the
incus
profile
device
add
command to add a root disk device to the project’s
default
profile.
Configure a project
¶
To configure a project, you can either set a specific configuration option or edit the full project.
Some configuration options can only be set for projects that do not contain any instances.
Set specific configuration options
¶
To set a specific configuration option, use the
incus
project
set
command.
For example, to limit the number of containers that can be created in
my-project
to five, enter the following command:
```
incus project set my-project limits.containers=5

```
To unset a specific configuration option, use the
incus
project
unset
command.
Note
If you unset a configuration option, it is set to its default value.
This default value might differ from the initial value that is set when the project is created.
Edit the project
¶
To edit the full project configuration, use the
incus
project
edit
command.
For example:
```
incus project edit my-project

```
