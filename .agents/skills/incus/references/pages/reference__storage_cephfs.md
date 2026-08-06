# CephFS - cephfs

Source: https://linuxcontainers.org/incus/docs/main/reference/storage_cephfs/
Fetched: 2026-08-07

CephFS -
cephfs
¶
Ceph
is an open-source storage platform that stores its data in a storage cluster based on
RADOS
.
It is highly scalable and, as a distributed system without a single point of failure, very reliable.
Ceph provides different components for block storage and for file systems.
CephFS
is Ceph’s file system component that provides a robust, fully-featured POSIX-compliant distributed file system.
Internally, it maps files to Ceph objects and stores file metadata (for example, file ownership, directory paths, access permissions) in a separate data pool.
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
A
CephFS file system
consists of two OSD storage pools, one for the actual data and one for the file metadata.
cephfs
driver in Incus
¶
Note
The
cephfs
driver can only be used for custom storage volumes with content type
filesystem
.
For other storage volumes, use the
Ceph
driver.
That driver can also be used for custom storage volumes with content type
filesystem
, but it implements them through Ceph RBD images.
Unlike other storage drivers, this driver does not set up the storage system but assumes that you already have a Ceph cluster installed.
You can either create the CephFS file system that you want to use beforehand and specify it through the
source
option, or specify the
cephfs.create_missing
option to automatically create the file system and the data and metadata OSD pools (with the names given in
cephfs.data_pool
and
cephfs.meta_pool
).
This driver also behaves differently than other drivers in that it provides remote storage.
As a result and depending on the internal network, storage access might be a bit slower than for local storage.
On the other hand, using remote storage has big advantages in a cluster setup, because all cluster members have access to the same storage pools with the exact same contents, without the need to synchronize storage pools.
Incus assumes that it has full control over the OSD storage pool.
Therefore, you should never maintain any file system entities that are not owned by Incus in an Incus OSD storage pool, because Incus might delete them.
The
cephfs
driver in Incus supports snapshots if snapshots are enabled on the server side.
Configuration options
¶
The following configuration options are available for storage pools that use the
cephfs
driver and for storage volumes in these pools.
Storage pool configuration
¶
cephfs.cluster_name
Name of the Ceph cluster that contains the CephFS file system
Key:
cephfs.cluster_name
Type:
string
Default:
ceph
Scope:
global
cephfs.create_missing
Create the file system and the missing data and metadata OSD pools
Key:
cephfs.create_missing
Type:
bool
Default:
false
Scope:
global
cephfs.data_pool
Data OSD pool name to create for the file system
Key:
cephfs.data_pool
Type:
string
Default:
Scope:
global
cephfs.fscache
Enable use of kernel
fscache
and
cachefilesd
Key:
cephfs.fscache
Type:
bool
Default:
false
Scope:
global
cephfs.meta_pool
Metadata OSD pool name to create for the file system
Key:
cephfs.meta_pool
Type:
string
Default:
Scope:
global
cephfs.osd_pg_num
OSD pool
pg_num
to use when creating missing OSD pools
Key:
cephfs.osd_pg_num
Type:
string
Default:
Scope:
global
cephfs.path
The base path for the CephFS mount
Key:
cephfs.path
Type:
string
Default:
/
Scope:
global
cephfs.user.name
The Ceph user to use
Key:
cephfs.user.name
Type:
string
Default:
admin
Scope:
global
source
Existing CephFS file system or file system path to use
Key:
source
Type:
string
Default:
Scope:
local
volatile.pool.pristine
Whether the CephFS file system was empty on creation time
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
