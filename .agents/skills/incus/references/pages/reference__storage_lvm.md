# LVM - lvm

Source: https://linuxcontainers.org/incus/docs/main/reference/storage_lvm/
Fetched: 2026-08-07

LVM -
lvm
¶
LVM
is a storage management framework rather than a file system.
It is used to manage physical storage devices, allowing you to create a number of logical storage volumes that use and virtualize the underlying physical storage devices.
Note that it is possible to over-commit the physical storage in the process, to allow flexibility for scenarios where not all available storage is in use at the same time.
To use LVM, make sure you have
lvm2
installed on your machine.
Terminology
¶
LVM can combine several physical storage devices into a
volume group
.
You can then allocate
logical volumes
of different types from this volume group.
One supported volume type is a
thin pool
, which allows over-committing the resources by creating  thinly provisioned volumes whose total allowed maximum size is larger than the available physical storage.
Another type is a
volume snapshot
, which captures a specific state of a logical volume.
lvm
driver in Incus
¶
The
lvm
driver in Incus uses logical volumes for images, and volume snapshots for instances and snapshots.
Incus assumes that it has full control over the volume group.
Therefore, you should not maintain any file system entities that are not owned by Incus in an LVM volume group, because Incus might delete them.
However, if you need to reuse an existing volume group (for example, because your setup has only one volume group), you can do so by setting the
lvm.vg.force_reuse
configuration.
By default, LVM storage pools use an LVM thin pool and create logical volumes for all Incus storage entities (images, instances and custom volumes) in there.
This behavior can be changed by setting
lvm.use_thinpool
to
false
when you create the pool.
In this case, Incus uses “normal” logical volumes for all storage entities that are not snapshots.
Note that this entails serious performance and space reductions for the
lvm
driver (close to the
dir
driver both in speed and storage usage).
The reason for this is that most storage operations must fall back to using
rsync
, because logical volumes that are not thin pools do not support snapshots of snapshots.
In addition, non-thin snapshots take up much more storage space than thin snapshots, because they must reserve space for their maximum size at creation time.
Therefore, this option should only be chosen if the use case requires it.
For environments with a high instance turnover (for example, continuous integration) you should tweak the backup
retain_min
and
retain_days
settings in
/etc/lvm/lvm.conf
to avoid slowdowns when interacting with Incus.
lvmcluster
driver in Incus
¶
A second
lvmcluster
driver is available for use within clusters.
This relies on the
lvmlockd
and
sanlock
daemons to provide distributed locking over a shared disk or set of disks.
It allows using a remote shared block device like a
FiberChannel
LUN
,
NVMEoF/NVMEoTCP
disk or
iSCSI
drive as the backing for a LVM storage pool.
Note
Thin provisioning is incompatible with clustered LVM, so expect higher disk usage.
To use this with Incus, you must:
Have a shared block device available on all your cluster members
Install the relevant packages for
lvm
,
lvmlockd
and
sanlock
Enable
lvmlockd
by setting
use_lvmlockd
=
1
in your
/etc/lvm/lvm.conf
Set a unique (within your cluster)
host_id
value in
/etc/lvm/lvmlocal.conf
Ensure that both
lvmlockd
and
sanlock
daemons are running
Warning
lvmcluster
has the following limitations:
Snapshots for shared custom storage volumes are not supported.
Snapshots of raw block volumes are not supported.
Only
raw
custom volumes support the
security.shared
option.
Configuration options
¶
The following configuration options are available for storage pools that use the
lvm
driver and for storage volumes in these pools.
Storage pool configuration
¶
block.type
Type of the block volume
Key:
block.type
Default:
same as
volume.block.type
Condition:
block-based volume
lvm.metadata_size
The size of the metadata space for the physical volume.
Key:
lvm.metadata_size
Type:
string
Default:
0
(auto)
Scope:
global
lvm.thinpool_metadata_size
The size of the thin pool metadata volume (the default is to let LVM calculate an appropriate size). Not usable with
lvmcluster
.
Key:
lvm.thinpool_metadata_size
Type:
string
Default:
0
(auto)
Scope:
global
lvm.thinpool_name
Thin pool where volumes are created. Not usable with
lvmcluster
.
Key:
lvm.thinpool_name
Type:
string
Default:
IncusThinPool
Scope:
local
lvm.use_thinpool
Whether the storage pool uses a thin pool for logical volumes. Not usable with
lvmcluster
.
Key:
lvm.use_thinpool
Type:
bool
Default:
true
Scope:
global
lvm.vg.force_reuse
Force using an existing non-empty volume group. Not usable with
lvmcluster
.
Key:
lvm.vg.force_reuse
Type:
bool
Default:
false
Scope:
local
lvm.vg_name
Name of the volume group to create.
Key:
lvm.vg_name
Type:
string
Default:
name of the pool
Scope:
local
size
Storage pool size (in bytes, suffixes supported, can be increased to grow storage pool).
lvmcluster
pools: cannot set at creation, but can be updated.
Key:
size
Type:
string
Default:
auto (20% of free disk space, >= 5 GiB and <= 30 GiB) for
lvm
.
Scope:
local
source
Path to an existing block device, loop file or LVM volume group.
Key:
source
Type:
string
Default:
Scope:
local
source.wipe
Wipe the block device specified in
source
prior to creating the storage pool.
Key:
source.wipe
Type:
bool
Default:
false
Scope:
local
Tip
In addition to these configurations, you can also set default values for the storage volume configurations. See
Configure default values for storage volumes
.
Storage volume configuration
¶
block.create_options
Additional options to pass to the file system creation tool when formatting the volume
Key:
block.create_options
Type:
string
Default:
same as
volume.block.create_options
Condition:
block-based volume with content type
filesystem
block.filesystem
File system of the storage volume:
btrfs
,
ext4
or
xfs
(
ext4
if not set)
Key:
block.filesystem
Type:
string
Default:
same as
volume.block.filesystem
Condition:
block-based volume with content type
filesystem
block.mount_options
Mount options for block-backed file system volumes
Key:
block.mount_options
Type:
string
Default:
same as
volume.block.mount_options
Condition:
block-based volume with content type
filesystem
initial.gid
GID of the volume owner in the instance
Key:
initial.gid
Type:
int
Default:
same as
volume.initial.gid
or
0
Condition:
custom volume with content type
filesystem
initial.mode
Mode of the volume in the instance
Key:
initial.mode
Type:
int
Default:
same as
volume.initial.mode
or
711
Condition:
custom volume with content type
filesystem
initial.uid
UID of the volume owner in the instance
Key:
initial.uid
Type:
int
Default:
same as
volume.initial.uid
or
0
Condition:
custom volume with content type
filesystem
lvm.stripes
Number of stripes to use for new volumes (or thin pool volume)
Key:
lvm.stripes
Type:
string
Default:
same as
volume.lvm.stripes
Condition:
lvm.stripes.size
Size of stripes to use (at least 4096 bytes and multiple of 512 bytes)
Key:
lvm.stripes.size
Type:
string
Default:
same as
volume.lvm.stripes.size
Condition:
lvmcluster.remove_snapshots
Remove snapshots as needed
Key:
lvmcluster.remove_snapshots
Type:
bool
Default:
same as
volume.lvmcluster.remove_snapshots
or
false
Condition:
security.shared
Enable sharing the volume across multiple instances
Key:
security.shared
Type:
bool
Default:
same as
volume.security.shared
or
false
Condition:
custom block volume
security.shifted
Enable ID shifting overlay (allows attach by multiple isolated instances)
Key:
security.shifted
Type:
bool
Default:
same as
volume.security.shifted
or
false
Condition:
custom volume
security.unmapped
Disable ID mapping for the volume
Key:
security.unmapped
Type:
bool
Default:
same as
volume.security.unmapped
or
false
Condition:
custom volume
size
Size/quota of the storage volume
Key:
size
Type:
string
Condition:
default: same as
volume.size
snapshots.expiry
Controls when newly created snapshots are to be deleted (expects an expression like
1M
2H
3d
4w
5m
6y
)
Key:
snapshots.expiry
Type:
string
Default:
same as
volume.snapshot.expiry
Condition:
custom volume
This value is used to compute the expiry date of newly created snapshots.
It is added to the current time when a snapshot is taken, and the resulting timestamp is stored as that snapshot’s individual expiry date.
Changing this value only affects snapshots created after the change; the expiry date of existing snapshots is not modified.
The supported units are
S
(seconds),
M
(minutes),
H
(hours),
d
(days),
w
(weeks),
m
(months) and
y
(years).
Note that
M
stands for minutes and
m
for months.
Each unit may only be specified once, and months and years are computed as calendar months and years rather than fixed numbers of days.
snapshots.expiry.manual
Controls when newly created snapshots are to be deleted (expects an expression like
1M
2H
3d
4w
5m
6y
)
Key:
snapshots.expiry.manual
Type:
string
Default:
same as
volume.snapshot.expiry.manual
Condition:
custom volume
This value is used to compute the expiry date of newly created snapshots.
It is added to the current time when a snapshot is taken, and the resulting timestamp is stored as that snapshot’s individual expiry date.
Changing this value only affects snapshots created after the change; the expiry date of existing snapshots is not modified.
The supported units are
S
(seconds),
M
(minutes),
H
(hours),
d
(days),
w
(weeks),
m
(months) and
y
(years).
Note that
M
stands for minutes and
m
for months.
Each unit may only be specified once, and months and years are computed as calendar months and years rather than fixed numbers of days.
snapshots.pattern
Pongo2 template string that represents the snapshot name (used for scheduled snapshots and unnamed snapshots)
[
1
]
Key:
snapshots.pattern
Type:
string
Default:
same as
volume.snapshot.pattern
or
snap%d
Condition:
custom volume
snapshots.schedule
Cron expression (
<minute>
<hour>
<dom>
<month>
<dow>
), a comma-separated list of schedule aliases (
@hourly
,
@daily
,
@midnight
,
@weekly
,
@monthly
,
@annually
,
@yearly
), or empty to disable automatic snapshots (the default)
Key:
snapshots.schedule
Type:
string
Default:
same as
volume.snapshot.schedule
Condition:
custom volume
Storage bucket configuration
¶
To enable storage buckets for local storage pool drivers and allow applications to access the buckets via the S3 protocol, you must configure the
core.storage_buckets_address
server setting.
size
Size/quota of the storage bucket
Key:
size
Type:
string
Default:
same as
volume.size
Condition:
appropriate driver
[
1
]
The
snapshots.pattern
option takes a Pongo2 template string to format the snapshot name.
To add a time stamp to the snapshot name, use the Pongo2 context variable
creation_date
.
Make sure to format the date in your template string to avoid forbidden characters in the snapshot name.
For example, set
snapshots.pattern
to
{{
creation_date|date:'2006-01-02_15-04-05'
}}
to name the snapshots after their time of creation, down to the precision of a second.
Another way to avoid name collisions is to use the placeholder
%d
in the pattern.
For the first snapshot, the placeholder is replaced with
0
.
For subsequent snapshots, the existing snapshot names are taken into account to find the highest number at the placeholder’s position.
This number is then incremented by one for the new name.
