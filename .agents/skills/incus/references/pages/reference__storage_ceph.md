# Ceph RBD - ceph

Source: https://linuxcontainers.org/incus/docs/main/reference/storage_ceph/
Fetched: 2026-08-07

Ceph RBD -
ceph
¶
Ceph
is an open-source storage platform that stores its data in a storage cluster based on
RADOS
.
It is highly scalable and, as a distributed system without a single point of failure, very reliable.
Ceph provides different components for block storage and for file systems.
Ceph
RBD
is Ceph’s block storage component that distributes data and workload across the Ceph cluster.
It uses thin provisioning, which means that it is possible to over-commit resources.
Terminology
¶
Ceph uses the term
object
for the data that it stores.
The daemon that is responsible for storing and managing data is the
Ceph
OSD
.
Ceph’s storage is divided into
pools
, which are logical partitions for storing objects.
They are also referred to as
data pools
,
storage pools
or
OSD pools
.
Ceph block devices are also called
RBD images
, and you can create
snapshots
and
clones
of these RBD images.
ceph
driver in Incus
¶
Note
To use the Ceph RBD driver, you must specify it as
ceph
.
This is slightly misleading, because it uses only Ceph RBD (block storage) functionality, not full Ceph functionality.
For storage volumes with content type
filesystem
(images, containers and custom file-system volumes), the
ceph
driver uses Ceph RBD images with a file system on top (see
block.filesystem
).
Alternatively, you can use the
CephFS
driver to create storage volumes with content type
filesystem
.
Unlike other storage drivers, this driver does not set up the storage system but assumes that you already have a Ceph cluster installed.
This driver also behaves differently than other drivers in that it provides remote storage.
As a result and depending on the internal network, storage access might be a bit slower than for local storage.
On the other hand, using remote storage has big advantages in a cluster setup, because all cluster members have access to the same storage pools with the exact same contents, without the need to synchronize storage pools.
The
ceph
driver in Incus uses RBD images for images, and snapshots and clones to create instances and snapshots.
Incus assumes that it has full control over the OSD storage pool.
Therefore, you should never maintain any file system entities that are not owned by Incus in an Incus OSD storage pool, because Incus might delete them.
Due to the way copy-on-write works in Ceph RBD, parent RBD images can’t be removed until all children are gone.
As a result, Incus automatically renames any objects that are removed but still referenced.
Such objects are kept with a
zombie_
prefix until all references are gone and the object can safely be removed.
Limitations
¶
The
ceph
driver has the following limitations:
Sharing custom volumes between instances
Custom storage volumes with
content type
filesystem
can usually be shared between multiple instances different cluster members.
However, because the Ceph RBD driver “simulates” volumes with content type
filesystem
by putting a file system on top of an RBD image, custom storage volumes can only be assigned to a single instance at a time.
If you need to share a custom volume with content type
filesystem
, use the
CephFS
driver instead.
Sharing the OSD storage pool between installations
Sharing the same OSD storage pool between multiple Incus installations is not supported.
Using an OSD pool of type “erasure”
To use a Ceph OSD pool of type “erasure”, you must create the OSD pool beforehand.
You must also create a separate OSD pool of type “replicated” that will be used for storing metadata.
This is required because Ceph RBD does not support
omap
.
To specify which pool is “erasure coded”, set the
ceph.osd.data_pool_name
configuration option to the erasure coded pool name and the
source
configuration option to the replicated pool name.
Configuration options
¶
The following configuration options are available for storage pools that use the
ceph
driver and for storage volumes in these pools.
Storage pool configuration
¶
ceph.cluster_name
Name of the Ceph cluster in which to create new storage pools
Key:
ceph.cluster_name
Type:
string
Default:
ceph
Scope:
global
ceph.osd.data_pool_name
Name of the OSD data pool
Key:
ceph.osd.data_pool_name
Type:
string
Default:
Scope:
global
ceph.osd.force_reuse
Deprecated, should not be used.
Key:
ceph.osd.force_reuse
Type:
bool
Default:
Scope:
global
ceph.osd.pg_name
Number of placement groups for the OSD storage pool
Key:
ceph.osd.pg_name
Type:
string
Default:
32
Scope:
global
ceph.osd.pool_name
Name of the OSD storage pool
Key:
ceph.osd.pool_name
Type:
string
Default:
name of the pool
Scope:
global
ceph.rbd.clone_copy
Whether to use RBD lightweight clones rather than full dataset copies
Key:
ceph.rbd.clone_copy
Type:
bool
Default:
true
Scope:
global
ceph.rbd.du
Whether to use RBD
du
to obtain disk usage data for stopped instances
Key:
ceph.rbd.du
Type:
bool
Default:
true
Scope:
global
ceph.rbd.features
Comma-separated list of RBD features to enable on the volumes
Key:
ceph.rbd.features
Type:
string
Default:
layering
Scope:
global
ceph.user.name
The Ceph user to use when creating storage pools and volumes
Key:
ceph.user.name
Type:
string
Default:
admin
Scope:
global
source
Existing OSD storage pool to use
Key:
source
Type:
string
Default:
Scope:
local
volatile.pool.pristine
Whether the pool was empty on creation time
Key:
volatile.pool.pristine
Type:
string
Default:
true
Scope:
global
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
