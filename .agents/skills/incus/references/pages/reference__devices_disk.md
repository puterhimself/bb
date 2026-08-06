# Type: disk

Source: https://linuxcontainers.org/incus/docs/main/reference/devices_disk/
Fetched: 2026-08-07

Type:
disk
¶
Note
The
disk
device type is supported for both containers and VMs.
It supports hotplugging for both containers and VMs.
Disk devices supply additional storage to instances.
For containers, they are essentially mount points inside the instance (either as a bind-mount of an existing file or directory on the host, or, if the source is a block device, a regular mount).
Virtual machines share host-side mounts or directories through
9p
or
virtiofs
(if available), or as VirtIO disks for block-based disks.
Warning
The device name affects the serial generated for the device. If the device name exceeds 14 characters for
nvme
and
virtio-blk
, or 30 characters for
virtio-scsi
, Incus will hash the device value to ensure the generated serial remains within supported length constraints. The device name itself is left unchanged.
Types of disk devices
¶
You can create disk devices from different sources.
The value that you specify for the
source
option specifies the type of disk device that is added:
Storage volume
The most common type of disk device is a storage volume.
To add a storage volume, specify its name as the
source
of the device:
```
incus config device add <instance_name> <device_name> disk pool=<pool_name> source=<volume_name> [path=<path_in_instance>]

```
The path is required for file system volumes, but not for block volumes.
Alternatively, you can use the
incus
storage
volume
attach
command to
Attach the volume to an instance
.
Both commands use the same mechanism to add a storage volume as a disk device.
It’s possible to attach a sub-path of a custom volume to an instance using the
source=<volume_name>/<sub_path>
syntax.
If the sub-path doesn’t exist inside the custom volume, it will be created automatically when the device is started using the
initial.XYZ
configuration keys for ownership and permissions.
Path on the host
You can share a path on your host (either a file system or a block device) to your instance by adding it as a disk device with the host path as the
source
:
```
incus config device add <instance_name> <device_name> disk source=<path_on_host> [path=<path_in_instance>]

```
The path is required for file systems, but not for block devices.
Ceph RBD
Incus can use Ceph to manage an internal file system for the instance, but if you have an existing, externally managed Ceph RBD that you would like to use for an instance, you can add it with the following command:
```
incus config device add <instance_name> <device_name> disk source=ceph:<pool_name>/<volume_name> ceph.user_name=<user_name> ceph.cluster_name=<cluster_name> [path=<path_in_instance>]

```
The path is required for file systems, but not for block devices.
CephFS
Incus can use Ceph to manage an internal file system for the instance, but if you have an existing, externally managed Ceph file system that you would like to use for an instance, you can add it with the following command:
```
incus config device add <instance_name> <device_name> disk source=cephfs:<fs_name>/<path> ceph.user_name=<user_name> ceph.cluster_name=<cluster_name> path=<path_in_instance>

```
ISO file
You can add an ISO file as a disk device for a virtual machine.
It is added as a ROM device inside the VM.
This source type is applicable only to VMs.
To add an ISO file, specify its file path as the
source
:
```
incus config device add <instance_name> <device_name> disk source=<file_path_on_host>

```
VM
cloud-init
You can generate a
cloud-init
configuration ISO from the
cloud-init.vendor-data
and
cloud-init.user-data
configuration keys and attach it to a virtual machine.
The
cloud-init
that is running inside the VM then detects the drive on boot and applies the configuration.
This source type is applicable only to VMs.
To add such a device, use the following command:
```
incus config device add <instance_name> <device_name> disk source=cloud-init:config

```
VM
agent
You can generate an
agent
configuration ISO which will contain the agent binary, configuration files and installation scripts.
This is required for environments where
9p
isn’t supported and where an alternative way to load the agent is required.
This source type is applicable only to VMs.
To add such a device, use the following command:
```
incus config device add <instance_name> <device_name> disk source=agent:config

```
Tmpfs
You can back a disk device with an in-memory file system by using the
tmpfs:
source.
```
incus config device add <instance_name> <device_name> disk source=tmpfs: path=<path_in_instance> [size=<size>] [initial.uid=<uid>] [initial.gid=<gid>] [initial.mode=<mode>]

```
Both
source
and
path
are required.
This creates a
tmpfs
mount inside the instance and supports optional properties for size, ownership, and permissions.
Tmpfs with overlayfs behavior
If you want the same tmpfs behavior but combined with overlayfs semantics, use
tmpfs-overlay:
as the source.
```
incus config device add <instance_name> <device_name> disk source=tmpfs-overlay: path=<path_in_instance> [size=<size>] [initial.uid=<uid>] [initial.gid=<gid>] [initial.mode=<mode>]

```
Both
source
and
path
are required.
Additionally, the target
path
must already exist inside the container.
This provides an ephemeral in-memory file system with overlayfs handling.
Initial volume configuration for instance root disk devices
¶
Initial volume configuration allows setting specific configurations for the root disk devices of new instances.
These settings are prefixed with
initial.
and are only applied when the instance is created.
This method allows creating instances that have unique configurations, independent of the default storage pool settings.
For example, you can add an initial volume configuration for
zfs.block_mode
to an existing profile, and this
will then take effect for each new instance you create using this profile:
```
incus profile device set <profile_name> <device_name> initial.zfs.block_mode=true

```
You can also set an initial configuration directly when creating an instance. For example:
```
incus init <image> <instance_name> --device <device_name>,initial.zfs.block_mode=true

```
Note that you cannot use initial volume configurations with custom volume options or to set the volume’s size.
initial.uid
,
initial.gid
and
initial.mode
¶
initial.uid
,
initial.gid
and
initial.mode
apply in three different scenarios:
On root disk devices, they are passed to the storage driver to set the ownership and mode of the instance’s root volume at creation time (when supported by the driver).
On
tmpfs:
and
tmpfs-overlay:
disk devices, they are translated into
uid=
,
gid=
and
mode=
mount options for the underlying
tmpfs
mount.
On custom volume disks where the
source
includes a sub-path (for example
source=myvol/sub/path
), they are used as the ownership and mode of any sub-directory that has to be created automatically when the device is started.
In all cases,
initial.uid
and
initial.gid
default to
0
and
initial.mode
defaults to
0711
(octal).
Device options
¶
disk
devices have the following device options:
attached
Only for VMs: Whether the disk is attached or ejected
Key:
attached
Type:
bool
Default:
true
Required:
no
boot.priority
Boot priority for VMs (higher value boots first)
Key:
boot.priority
Type:
integer
Required:
no
ceph.cluster_name
The cluster name of the Ceph cluster (required for Ceph or CephFS sources)
Key:
ceph.cluster_name
Type:
string
Default:
ceph
Required:
no
ceph.user_name
The user name of the Ceph cluster (required for Ceph or CephFS sources)
Key:
ceph.user_name
Type:
string
Default:
admin
Required:
no
dependent
Specifies if the disk is instance dependent
Key:
dependent
Type:
bool
Default:
false
Required:
no
initial.*
Initial volume configuration for instance root disk devices
Key:
initial.*
Type:
string
Required:
no
For root disk devices, this is used to override the storage pool’s default volume
configuration when creating the instance’s root volume.
For custom volumes, only
initial.uid
,
initial.gid
and
initial.mode
are
accepted and they are used when auto-creating sub-directories inside the custom
volume (when the
source
includes a sub-path that doesn’t exist).
initial.uid
,
initial.gid
and
initial.mode
are also used to set the ownership
and mode of the file system when the
source
is
tmpfs:
or
tmpfs-overlay:
.
io.bus
Only for VMs: Override the bus for the device
Key:
io.bus
Type:
string
Default:
virtio-scsi
for block,
auto
for file system
Required:
no
This controls what bus a disk device should be attached to.
For block devices (disks), this is one of:
nvme
virtio-blk
virtio-scsi
(default)
usb
For file systems (shared directories or custom volumes), this is one of:
9p
auto
(default) (
virtiofs
if possible, else
9p
)
virtiofs
9p
doesn’t support hotplugging and
virtiofs
doesn’t support live migration.
auto
tries
to use
virtiofs
if possible (
migration.stateful
not set to
true
and host support for
virtiofsd
) and falls back to
9p
otherwise.
io.cache
Only for VMs: Override the caching mode for the device
Key:
io.cache
Type:
string
Default:
none
Required:
no
This controls what bus a disk device should be attached to.
For block devices (disks), this is one of:
none
(default)
writeback
unsafe
For file systems (shared directories or custom volumes), this is one of:
none
(default)
metadata
unsafe
limits.max
I/O limit in byte/s and/or IOPS for both read and write (same as setting both
limits.read
and
limits.write
)
Key:
limits.max
Type:
string
Required:
no
limits.read
I/O limit in byte/s (various suffixes supported, see
Units for storage, memory and network limits
) and/or in IOPS (must be suffixed with
iops
), comma separated when specifying both - see also
Configure I/O limits
Key:
limits.read
Type:
string
Required:
no
limits.write
I/O limit in byte/s (various suffixes supported, see
Units for storage, memory and network limits
) and/or in IOPS (must be suffixed with
iops
), comma separated when specifying both - see also
Configure I/O limits
Key:
limits.write
Type:
string
Required:
no
path
Path inside the instance where the disk will be mounted (only for file system disk devices)
Key:
path
Type:
string
Required:
yes
This controls which path inside the instance the disk should be mounted on.
With containers, this option supports mounting file system disk devices, and paths and single files within them.
With VMs, this option supports mounting file system disk devices and paths within them. Mounting single files is not supported.
pool
The storage pool to which the disk device belongs (only applicable for storage volumes managed by Incus)
Key:
pool
Type:
string
Required:
no
propagation
Controls how a bind-mount is shared between the instance and the host (can be one of
private
, the default, or
shared
,
slave
,
unbindable
,
rshared
,
rslave
,
runbindable
,
rprivate
; see the Linux Kernel
shared subtree
documentation for a full explanation)
Key:
propagation
Type:
string
Required:
no
raw.mount.options
File system specific mount options
Key:
raw.mount.options
Type:
string
Required:
no
readonly
Controls whether to make the mount read-only
Key:
readonly
Type:
bool
Default:
false
Required:
no
recursive
Controls whether to recursively mount the source path
Key:
recursive
Type:
bool
Default:
false
Required:
no
required
Controls whether to fail if the source doesn’t exist
Key:
required
Type:
bool
Default:
true
Required:
no
shift
Sets up a shifting overlay to translate the source UID/GID to match the instance (only for containers)
Key:
shift
Type:
bool
Default:
false
Required:
no
size
Disk size in bytes (various suffixes supported, see
Units for storage, memory and network limits
) - only supported for the
rootfs
(
/
)
Key:
size
Type:
string
Required:
no
size.state
Same as
size
, but applies to the file-system volume used for saving runtime state in VMs
Key:
size.state
Type:
string
Required:
no
source
Source of a file system or block device (see
Types of disk devices
for details)
Key:
source
Type:
string
Required:
yes
wwn
Only for VMs: Set the disk World Wide Name (only supported on
virtio-scsi
bus)
Key:
wwn
Type:
bool
Default:
``
Required:
no
