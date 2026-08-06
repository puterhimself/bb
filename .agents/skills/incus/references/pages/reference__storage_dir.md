# Directory - dir

Source: https://linuxcontainers.org/incus/docs/main/reference/storage_dir/
Fetched: 2026-08-07

Directory -
dir
¶
The directory storage driver is a basic backend that stores its data in a standard file and directory structure.
This driver is quick to set up and allows inspecting the files directly on the disk, which can be convenient for testing.
However, Incus operations are
not optimized
for this driver.
dir
driver in Incus
¶
The
dir
driver in Incus is fully functional and provides the same set of features as other drivers.
However, it is much slower than all the other drivers because it must unpack images and do instant copies of instances, snapshots and images.
Unless specified differently during creation (with the
source
configuration option), the data is stored in the
/var/lib/incus/storage-pools/
directory.
Quotas
¶
The
dir
driver supports storage quotas when running on either ext4 or XFS with project quotas enabled at the file system level.
Configuration options
¶
The following configuration options are available for storage pools that use the
dir
driver and for storage volumes in these pools.
Storage pool configuration
¶
rsync.bwlimit
The upper limit to be placed on the socket I/O when
rsync
must be used to transfer storage entities
Key:
rsync.bwlimit
Type:
string
Default:
0
(no limit)
Scope:
global
rsync.compression
Whether to use compression while migrating storage pools
Key:
rsync.compression
Type:
bool
Default:
true
Scope:
global
source
Path to an existing directory
Key:
source
Type:
string
Default:
Scope:
local
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
security.size
Size/quota of the storage volume
Key:
security.size
Type:
string
Default:
same as
volume.size
Condition:
appropriate driver
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
Storage buckets do not have any configuration for
dir
pools.
Unlike the other storage pool drivers, the
dir
driver does not support bucket quotas via the
size
setting.
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
