# First steps with Incus

Source: https://linuxcontainers.org/incus/docs/main/tutorial/first_steps/
Fetched: 2026-08-07

First steps with Incus
¶
This tutorial guides you through the first steps with Incus.
It covers installing and initializing Incus, creating and configuring some instances, interacting with the instances, and creating snapshots.
After going through these steps, you will have a general idea of how to use Incus, and you can start exploring more advanced use cases!
Install and initialize Incus
¶
Install the Incus package
Incus is available on most common Linux distributions.
For detailed distribution-specific instructions, refer to
How to install Incus
.
Allow your user to control Incus
Access to Incus in the packages above is controlled through two groups:
incus
allows basic user access, no configuration and all actions restricted to a per-user project.
incus-admin
allows full control over Incus.
To control Incus without having to run all commands as root, you can add yourself to the
incus-admin
group:
```
sudo adduser $USER incus-admin
newgrp incus-admin

```
The
newgrp
step is needed in any terminal that interacts with Incus until you restart your user session.
Initialize Incus
Incus requires some initial setup for networking and storage. This can be done interactively through:
```
incus admin init

```
Or a basic automated configuration can be applied with just:
```
incus admin init --minimal

```
If you want to tune the initialization options, see
How to initialize Incus
for more information.
Launch and inspect instances
¶
Incus is image based and can load images from different image servers.
In this tutorial, we will use the
official image server
.
You can list all images that are available on this server with:
```
incus image list images:

```
See
Images
for more information about the images that Incus uses.
Now, let’s start by launching a few instances.
With
instance
, we mean either a container or a virtual machine.
See
About containers and VMs
for information about the difference between the two instance types.
For managing instances, we use the Incus command line client
incus
.
Launch a container called
first
using the Debian 12 image:
```
incus launch images:debian/12 first

```
Note
Launching this container takes a few seconds, because the image must be downloaded and unpacked first.
Launch a container called
second
using the same image:
```
incus launch images:debian/12 second

```
Note
Launching this container is quicker than launching the first, because the image is already available.
Copy the first container into a container called
third
:
```
incus copy first third

```
Launch a VM called
debian-vm
using the Debian 12 image:
```
incus launch images:debian/12 debian-vm --vm

```
Note
Even though you are using the same image name to launch the instance, Incus downloads a slightly different image that is compatible with VMs.
Check the list of instances that you launched:
```
incus list

```
You will see that all but the third container are running.
This is because you created the third container by copying the first, but you didn’t start it.
You can start the third container with:
```
incus start third

```
Query more information about each instance with:
```
incus info first
incus info second
incus info third
incus info debian-vm

```
We don’t need all of these instances for the remainder of the tutorial, so let’s clean some of them up:
Stop the second container:
```
incus stop second

```
Delete the second container:
```
incus delete second

```
Delete the third container:
```
incus delete third

```
Since this container is running, you get an error message that you must stop it first.
Alternatively, you can force-delete it:
```
incus delete third --force

```
See
How to create instances
and
How to manage instances
for more information.
Configure instances
¶
There are several limits and configuration options that you can set for your instances.
See
Instance options
for an overview.
Let’s create another container with some resource limits:
Launch a container and limit it to one vCPU and 192 MiB of RAM:
```
incus launch images:debian/12 limited --config limits.cpu=1 --config limits.memory=192MiB

```
Check the current configuration and compare it to the configuration of the first (unlimited) container:
```
incus config show limited
incus config show first

```
Check the amount of free and used memory on the parent system and on the two containers:
```
free -m
incus exec first -- free -m
incus exec limited -- free -m

```
Note
The total amount of memory is identical for the parent system and the first container, because by default, the container inherits the resources from its parent environment.
The limited container, on the other hand, has only 192 MiB available.
Check the number of CPUs available on the parent system and on the two containers:
```
nproc
incus exec first -- nproc
incus exec limited -- nproc

```
Note
Again, the number is identical for the parent system and the first container, but reduced for the limited container.
You can also update the configuration while your container is running:
Configure a memory limit for your container:
```
incus config set limited limits.memory=128MiB

```
Check that the configuration has been applied:
```
incus config show limited

```
Check the amount of memory that is available to the container:
```
incus exec limited -- free -m

```
Note that the number has changed.
Depending on the instance type and the storage drivers that you use, there are more configuration options that you can specify.
For example, you can configure the size of the root disk device for a VM:
Check the current size of the root disk device of the Debian VM:
~$
incus
exec
debian-vm
--
df
-h
Filesystem
Size
Used
Avail
Use%
Mounted
on
/dev/root
9.6G
1.4G
8.2G
15%
/
tmpfs
483M
0
483M
0%
/dev/shm
tmpfs
193M
604K
193M
1%
/run
tmpfs
5.0M
0
5.0M
0%
/run/lock
tmpfs
50M
14M
37M
27%
/run/incus_agent
/dev/sda15
105M
6.1M
99M
6%
/boot/efi
Override the size of the root disk device:
```
incus config device override debian-vm root size=30GiB

```
Restart the VM:
```
incus restart debian-vm

```
Check the size of the root disk device again:
~$
incus
exec
debian-vm
--
df
-h
Filesystem
Size
Used
Avail
Use%
Mounted
on
/dev/root
29G
1.4G
28G
5%
/
tmpfs
483M
0
483M
0%
/dev/shm
tmpfs
193M
588K
193M
1%
/run
tmpfs
5.0M
0
5.0M
0%
/run/lock
tmpfs
50M
14M
37M
27%
/run/incus_agent
/dev/sda15
105M
6.1M
99M
6%
/boot/efi
See
How to configure instances
and
Instance configuration
for more information.
Interact with instances
¶
You can interact with your instances by running commands in them (including an interactive shell) or accessing the files in the instance.
Start by launching an interactive shell in your instance:
Run the
bash
command in your container:
```
incus exec first -- bash

```
Enter some commands, for example, display information about the operating system:
```
cat /etc/*release

```
Exit the interactive shell:
```
exit

```
Instead of logging on to the instance and running commands there, you can run commands directly from the host.
For example, you can install a command line tool on the instance and run it:
```
incus exec first -- apt-get update
incus exec first -- apt-get install sl -y
incus exec first -- /usr/games/sl

```
See
How to run commands in an instance
for more information.
You can also access the files from your instance and interact with them:
Pull a file from the container:
```
incus file pull first/etc/hosts .

```
Add an entry to the file:
```
echo "1.2.3.4 my-example" >> hosts

```
Push the file back to the container:
```
incus file push hosts first/etc/hosts

```
Use the same mechanism to access log files:
```
incus file pull first/var/log/syslog - | less

```
Note
Press
q
to exit the
less
command.
See
How to access files in an instance
for more information.
Manage snapshots
¶
You can create a snapshot of your instance, which makes it easy to restore the instance to a previous state.
Create a snapshot called “clean”:
```
incus snapshot create first clean

```
Confirm that the snapshot has been created:
```
incus list first
incus info first

```
Note
incus
list
shows the number of snapshots.
incus
info
displays information about each snapshot.
Break the container:
```
incus exec first -- rm /usr/bin/bash

```
Confirm the breakage:
```
incus exec first -- bash

```
Note
You do not get a shell, because you deleted the
bash
command.
Restore the container to the state of the snapshot:
```
incus snapshot restore first clean

```
Confirm that everything is back to normal:
```
incus exec first -- bash
exit

```
Delete the snapshot:
```
incus snapshot delete first clean

```
See
Use snapshots for instance backup
for more information.
