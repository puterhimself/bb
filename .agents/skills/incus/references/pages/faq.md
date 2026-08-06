# Frequently asked questions

Source: https://linuxcontainers.org/incus/docs/main/faq/
Fetched: 2026-08-07

Frequently asked questions
¶
The following sections give answers to frequently asked questions.
They explain how to resolve common issues and point you to more detailed information.
Why do my instances not have network access?
¶
Most likely, your firewall blocks network access for your instances.
See
How to configure your firewall
for more information about the problem and how to fix it.
Another frequent reason for connectivity issues is running Incus and Docker on the same host.
See
Prevent connectivity issues with Incus and Docker
for instructions on how to fix such issues.
How to enable the Incus server for remote access?
¶
By default, the Incus server is not accessible from the network, because it only listens on a local Unix socket.
You can enable it for remote access by following the instructions in
How to expose Incus to the network
.
When I do a
incus
remote
add
, it asks for a token?
¶
To be able to access the remote API, clients must authenticate with the Incus server.
See
Authenticate with the Incus server
for instructions on how to authenticate using a trust token.
Why should I not run privileged containers?
¶
A privileged container can do things that affect the entire host - for example, it can use things in
/sys
to reset the network card, which will reset it for the entire host, causing network blips.
See
Container security
for more information.
Almost everything can be run in an unprivileged container, or - in cases of things that require unusual privileges, like wanting to mount NFS file systems inside the container - you might need to use bind mounts.
Can I bind-mount my home directory in a container?
¶
Yes, you can do this by using a
disk device
:
```
incus config device add container-name home disk source=/home/${USER} path=/home/ubuntu

```
For unprivileged containers, you need to make sure that the user in the container has working read/write permissions.
Otherwise, all files will show up as the overflow UID/GID (
65536:65536
) and access to anything that’s not world-readable will fail.
Use either of the following methods to grant the required permissions:
Pass
shift=true
to the
incus
config
device
add
call. This depends on the kernel and file system supporting either idmapped mounts (see
incus
info
).
Add a
raw.idmap
entry (see
Idmaps for user namespace
).
Place recursive POSIX ACLs on your home directory.
Privileged containers do not have this issue because all UID/GID in the container are the same as outside.
But that’s also the cause of most of the security issues with such privileged containers.
How can I run Docker inside an Incus container?
¶
To run Docker inside an Incus container, set the
security.nesting
property of the container to
true
:
```
incus config set <container> security.nesting true

```
Note that Incus containers cannot load kernel modules, so depending on your Docker configuration, you might need to have extra kernel modules loaded by the host.
You can do so by setting a comma-separated list of kernel modules that your container needs:
```
incus config set <container_name> linux.kernel_modules <modules>

```
In addition, creating a
/.dockerenv
file in your container can help Docker ignore some errors it’s getting due to running in a nested environment.
Where does the Incus client (
incus
) store its configuration?
¶
The
incus
command stores its configuration under
~/.config/incus
.
Various configuration files are stored in that directory, for example:
client.crt
: client certificate (generated on demand)
client.key
: client key (generated on demand)
config.yml
: configuration file (info about
remotes
,
aliases
, etc.)
clientcerts/
: directory with per-remote client certificates
servercerts/
: directory with server certificates belonging to
remotes
Why can I not ping my Incus instance from another host?
¶
Many switches do not allow MAC address changes, and will either drop traffic with an incorrect MAC or disable the port totally.
If you can ping an Incus instance from the host, but are not able to ping it from a different host, this could be the cause.
The way to diagnose this problem is to run a
tcpdump
on the uplink and you will see either
ARP
Who
has
`xx.xx.xx.xx`
tell
`yy.yy.yy.yy`
, with you sending responses but them not getting acknowledged, or ICMP packets going in and out successfully, but never being received by the other host.
How can I monitor what Incus is doing?
¶
To see detailed information about what Incus is doing and what processes it is running, use the
incus
monitor
command.
For example, to show a human-readable output of all types of messages, enter the following command:
```
incus monitor --pretty

```
See
incus
monitor
--help
for all options, and
How to debug Incus
for more information.
Why does Incus stall when creating an instance?
¶
Check if your storage pool is out of space (by running
incus
storage
info
<pool_name>
).
In that case, Incus cannot finish unpacking the image, and the instance that you’re trying to create shows up as stopped.
To get more insight into what is happening, run
incus
monitor
(see
How can I monitor what Incus is doing?
), and check
sudo
dmesg
for any I/O errors.
Why does starting containers suddenly fail?
¶
If starting containers suddenly fails with a cgroup-related error message (
Failed
to
mount
"/sys/fs/cgroup"
), this might be due to running a VPN client on the host.
This is a known issue for both
Mullvad VPN
and
Private Internet Access VPN
, but might occur for other VPN clients as well.
The problem is that the VPN client mounts the
net_cls
cgroup1 over cgroup2 (which Incus uses).
The easiest fix for this problem is to stop the VPN client and unmount the
net_cls
cgroup1 with the following command:
```
umount /sys/fs/cgroup/net_cls

```
If you need to keep the VPN client running, mount the
net_cls
cgroup1 in another location and reconfigure your VPN client accordingly.
See
this Discourse post
for instructions for Mullvad VPN.
What is this
incusbr0-mtu
device?
¶
When setting the
bridge.mtu
option on an Incus managed bridge network, Incus will create a dummy network interface named
BRIDGE-mtu
.
That interface will never be used to carry traffic but it has the requested MTU set to it and is bridged into the network bridge.
This has the effect of forcing the bridge to adopt that MTU and avoids issues where the bridge’s configured MTU would change as interfaces get added to it.
