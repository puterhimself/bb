# Btrfs - btrfs

Source: https://linuxcontainers.org/incus/docs/main/reference/storage_btrfs/
Fetched: 2026-08-07

Btrfs -
btrfs
¶
Btrfs
is a local file system based on the
COW
principle.
COW means that data is stored to a different block after it has been modified instead of overwriting the existing data, reducing the risk of data corruption.
Unlike other file systems, Btrfs is extent-based, which means that it stores data in contiguous areas of memory.
In addition to basic file system features, Btrfs offers RAID and volume management, pooling, snapshots, checksums, compression and other features.
To use Btrfs, make sure you have
btrfs-progs
installed on your machine.
Terminology
¶
A Btrfs file system can have
subvolumes
, which are named binary subtrees of the main tree of the file system with their own independent file and directory hierarchy.
A
Btrfs snapshot
is a special type of subvolume that captures a specific state of another subvolume.
Snapshots can be read-write or read-only.
btrfs
driver in Incus
¶
The
btrfs
driver in Incus uses a subvolume per instance, image and snapshot.
When creating a new entity (for example, launching a new instance), it creates a Btrfs snapshot.
Btrfs doesn’t natively support storing block devices.
Therefore, when using Btrfs for VMs, Incus creates a big file on disk to store the VM.
This approach is not very efficient and might cause issues when creating snapshots.
Btrfs can be used as a storage backend inside a container in a nested Incus environment.
In this case, the parent container itself must use Btrfs.
Note, however, that the nested Incus setup does not inherit the Btrfs quotas from the parent (see
Quotas
below).
Quotas
¶
Btrfs supports storage quotas via qgroups.
Btrfs qgroups are hierarchical, but new subvolumes will not automatically be added to the qgroups of their parent subvolumes.
This means that users can trivially escape any quotas that are set.
Therefore, if strict quotas are needed, you should consider using a different storage driver (for example, ZFS with
refquota
or LVM with Btrfs on top).
When using quotas, you must take into account that Btrfs extents are immutable.
When blocks are written, they end up in new extents.
The old extents remain until all their data is dereferenced or rewritten.
This means that a quota can be reached even if the total amount of space used by the current files in the subvolume is smaller than the quota.
Note
This issue is seen most often when using VMs on Btrfs, due to the random I/O nature of using raw disk image files on top of a Btrfs subvolume.
Therefore, you should never use VMs with Btrfs storage pools.
If you really need to use VMs with Btrfs storage pools, set the instance root disk’s
size.state
property to twice the size of the root disk’s size.
This configuration allows all blocks in the disk image file to be rewritten without reaching the qgroup quota.
The per-volume
btrfs.compression
option can also help with this quota issue, as enabling compression reduces the maximum extent size so that block rewrites don’t cause as much storage to be double-tracked.
It does however prevent Incus from disabling copy-on-write on the volume, since the two are mutually exclusive.
Set
btrfs.compression=none
to keep copy-on-write disabled.
Configuration options
¶
The following configuration options are available for storage pools that use the
btrfs
driver and for storage volumes in these pools.
Storage pool configuration
¶
btrfs.create_options
Additional options to pass to
mkfs.btrfs
when creating the pool
Key:
btrfs.create_options
Type:
string
Default:
Scope:
global
btrfs.mount_options
Mount options for block devices
Key:
btrfs.mount_options
Type:
string
Default:
user_subvol_rm_allowed
Scope:
global
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
Path to an existing block device, loop file or Btrfs subvolume
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
Tip
In addition to these configurations, you can also set default values for the storage volume configurations. See
Configure default values for storage volumes
.
Storage volume configuration
¶
btrfs.compression
Compression algorithm to set on the volume, mapping to the Btrfs
compression
property (for example
zstd
,
lzo
,
zlib
or
none
)
Key:
btrfs.compression
Type:
string
Default:
same as
volume.btrfs.compression
Condition:
appropriate driver
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
appropriate driver
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
