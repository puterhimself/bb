# How to confine projects to specific users

Source: https://linuxcontainers.org/incus/docs/main/howto/projects_confine/
Fetched: 2026-08-07

How to confine projects to specific users
¶
You can use projects to confine the activities of different users or clients.
See
Confined projects in a multi-user environment
for more information.
How to confine a project to a specific user depends on the authentication method you choose.
Confine projects to specific TLS clients
¶
You can confine access to specific projects by restricting the TLS client certificate that is used to connect to the Incus server.
See
TLS client certificates
for detailed information.
To confine the access from the time the client certificate is added, you must either use token authentication or add the client certificate to the server directly.
Use the following command to add a restricted client certificate:
Token authentication
Add client certificate
```
incus config trust add --projects <project_name> --restricted

```
```
incus config trust add-certificate <certificate_file> --projects <project_name> --restricted

```
The client can then add the server as a remote in the usual way (
incus
remote
add
<server_name>
<token>
or
incus
remote
add
<server_name>
<server_address>
) and can only access the project or projects that have been specified.
To confine access for an existing certificate, use the following command:
```
incus config trust edit <fingerprint>

```
Make sure that
restricted
is set to
true
and specify the projects that the certificate should give access to under
projects
.
Note
You can specify the
--project
flag when adding a remote.
This configuration preselects the specified project.
However, it does not confine the client to this project.
Confine projects to specific Incus users
¶
Incus can be configured to dynamically create projects for all users in a specific user group.
This is usually achieved by having some users be a member of the
incus
group but not the
incus-admin
group.
Make sure that all user accounts that you want to be able to use Incus are a member of this group.
Once a member of the group issues an Incus command, Incus creates a confined project for this user and switches to this project.
If Incus has not been
initialized
at this point, it is automatically initialized (with the default settings).
If you want to customize the project settings, for example, to impose limits or restrictions, you can do so after the project has been created.
To modify the project configuration, you must have full access to Incus, which means you must be part of the
incus-admin
group and not only the group that you configured as the Incus user group.
