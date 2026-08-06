# ZFS - zfs

Source: https://linuxcontainers.org/incus/docs/main/reference/storage_zfs/
Fetched: 2026-08-07

ZFS -
zfs
¶
ZFS
combines both physical volume management and a file system.
A ZFS installation can span across a series of storage devices and is very scalable, allowing you to add disks to expand the available space in the storage pool immediately.
ZFS is a block-based file system that protects against data corruption by using checksums to verify, confirm and correct every operation.
To run at a sufficient speed, this mechanism requires a powerful environment with a lot of RAM.
In addition, ZFS offers snapshots and replication, RAID management, copy-on-write clones, compression and other features.
To use ZFS, make sure you have
zfsutils-linux
installed on your machine.
Terminology
¶
ZFS creates logical units based on physical storage devices.
These logical units are called
ZFS pools
or
zpools
.
Each zpool is then divided into a number of
datasets
.
These
datasets
can be of different types:
A
ZFS filesystem
can be seen as a partition or a mounted file system.
A
ZFS volume
represents a block device.
A
ZFS snapshot
captures a specific state of either a
ZFS filesystem
or a ZFS volume.
ZFS snapshots are read-only.
A
ZFS clone
is a writable copy of a ZFS snapshot.
zfs
driver in Incus
¶
The
zfs
driver in Incus uses
ZFS filesystems
and ZFS volumes for images and custom storage volumes, and ZFS snapshots and clones to create instances from images and for instance and custom volume snapshots.
By default, Incus enables compression when creating a ZFS pool.
Incus assumes that it has full control over what you gave it when creating the storage pool, be it a ZFS pool or a
dataset
.
Therefore, you should never try to maintain any children
datasets
or file system entities, because Incus might delete them.
Due to the way copy-on-write works in ZFS, parent
ZFS filesystems
can’t be removed until all children are gone.
As a result, Incus automatically renames any objects that are removed but still referenced.
Such objects are kept at a random
deleted/
path until all references are gone and the object can safely be removed.
Note that this method might have ramifications for restoring snapshots.
See
Limitations
below.
Incus automatically enables trimming support on all newly created pools on ZFS 0.8 or later.
This increases the lifetime of SSDs by allowing better block reuse by the controller, and it also allows to free space on the root file system when using a loop-backed ZFS pool.
If you are running a ZFS version earlier than 0.8 and want to enable trimming, upgrade to at least version 0.8.
Then use the following commands to make sure that trimming is automatically enabled for the ZFS pool in the future and trim all currently unused space:
```
zpool upgrade ZPOOL-NAME
zpool set autotrim=on ZPOOL-NAME
zpool trim ZPOOL-NAME

```
Limitations
¶
The
zfs
driver has the following limitations:
Restoring from older snapshots
ZFS doesn’t support restoring from snapshots other than the latest one.
You can, however, create new instances from older snapshots.
This method makes it possible to confirm whether a specific snapshot contains what you need.
After determining the correct snapshot, you can
remove the newer snapshots
so that the snapshot you need is the latest one and you can restore it.
Alternatively, you can configure Incus to automatically discard the newer snapshots during restore.
To do so, set the
zfs.remove_snapshots
configuration for the volume (or the corresponding
volume.zfs.remove_snapshots
configuration on the storage pool for all volumes in the pool).
Note, however, that if
zfs.clone_copy
is set to
true
, instance copies use ZFS snapshots too.
In that case, you cannot restore an instance to a snapshot taken before the last copy without having to also delete all its descendants.
If this is not an option, you can copy the wanted snapshot into a new instance and then delete the old instance.
You will, however, lose any other snapshots the instance might have had.
Observing I/O quotas
I/O quotas are unlikely to affect
ZFS filesystems
very much.
That’s because ZFS is a port of a Solaris module (using SPL) and not a native Linux file system using the Linux VFS API, which is where I/O limits are applied.
Feature support in ZFS
Some features, like the use of idmaps or delegation of a ZFS dataset, require ZFS 2.2 or higher and are therefore not widely available yet.
Quotas
¶
ZFS provides two different quota properties:
quota
and
refquota
.
quota
restricts the total size of a
dataset
, including its snapshots and clones.
refquota
restricts only the size of the data in the
dataset
, not its snapshots and clones.
By default, Incus uses the
quota
property when you set up a quota for your storage volume.
If you want to use the
refquota
property instead, set the
zfs.use_refquota
configuration for the volume (or the corresponding
volume.zfs.use_refquota
configuration on the storage pool for all volumes in the pool).
You can also set the
zfs.use_reserve_space
(or
volume.zfs.use_reserve_space
) configuration to use ZFS
reservation
or
refreservation
along with
quota
or
refquota
.
Configuration options
¶
The following configuration options are available for storage pools that use the
zfs
driver and for storage volumes in these pools.
Storage pool configuration
¶
size
Size of the storage pool when creating loop-based pools (in bytes, suffixes supported, can be increased to grow storage pool)
Key:
size
Type:
string
Default:
auto (20% of free disk space, >= 5 GiB and <= 30 GiB)
Scope:
local
source
Path to existing block device(s), loop file or ZFS dataset/pool. Multiple block devices should be separated by
,
. When listing block devices, you can also prefix them with
vdev
type. To specify a
vdev
type, use an
=
sign between the
vdev
type and the block devices (e.g.,
mirror=/dev/sda,/dev/sdb
). Only
stripe
,
mirror
,
raidz1
and
raidz2
vdev
types are supported.
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
prior to creating the storage pool
Key:
source.wipe
Type:
bool
Default:
false
Scope:
local
zfs.clone_copy
Whether to use ZFS lightweight clones rather than full
dataset
copies (Boolean), or
rebase
to copy based on the initial image
Key:
zfs.clone_copy
Type:
string
Default:
true
Scope:
global
zfs.export
Disable zpool export while unmount performed
Key:
zfs.export
Type:
bool
Default:
true
Scope:
global
zfs.pool_name
Name of the zpool
Key:
zfs.pool_name
Type:
string
Default:
name of the pool
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
(
zfs.block_mode
enabled)
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
(
zfs.block_mode
enabled)
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
(
zfs.block_mode
enabled)
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
Default:
same as
volume.size
Condition:
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
zfs.block_mode
Whether to use a formatted
zvol
rather than a
dataset
(
zfs.block_mode
can be set only for custom storage volumes; use
volume.zfs.block_mode
to enable ZFS block mode for all storage volumes in the pool, including instance volumes)
Key:
zfs.block_mode
Type:
bool
Default:
same as
volume.zfs.block_mode
Condition:
zfs.blocksize
Size of the ZFS block in range from 512 bytes to 16 MiB (must be power of 2) - for block volume, a maximum value of 128 KiB will be used even if a higher value is set
Key:
zfs.blocksize
Type:
string
Default:
same as
volume.zfs.blocksize
Condition:
zfs.delegate
Controls whether to delegate the ZFS dataset and anything underneath it to the container(s) using it. Allows the use of the
zfs
command in the container
Key:
zfs.delegate
Type:
bool
Default:
same as
volume.zfs.delegate
Condition:
ZFS 2.2 or higher
zfs.remove_snapshots
Remove snapshots as needed
Key:
zfs.remove_snapshots
Type:
bool
Default:
same as
volume.zfs.remove_snapshots
or
false
Condition:
zfs.reserve_space
Use
reservation
/
refreservation
along with
quota
/
refquota
Key:
zfs.reserve_space
Type:
bool
Default:
same as
volume.zfs.reserve_space
or
false
Condition:
zfs.use_refquota
Use
refquota
instead of
quota
for space
Key:
zfs.use_refquota
Type:
bool
Default:
same as
volume.zfsuse_refquota
or
false
Condition:
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
