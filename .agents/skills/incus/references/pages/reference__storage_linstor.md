# LINSTOR - linstor

Source: https://linuxcontainers.org/incus/docs/main/reference/storage_linstor/
Fetched: 2026-08-07

LINSTOR -
linstor
¶
LINSTOR
is an open-source software-defined storage solution that is typically used to manage
DRBD
replicated storage volumes. It provides both highly available and high performance volumes while focusing on operational simplicity.
LINSTOR does not manage the underlying storage by itself, and instead relies on other components such as ZFS or LVM to provision block devices. These block devices are then replicated using
DRBD
to provide fault tolerance and the ability to mount the volumes on any cluster node, regardless of its storage capabilities. Since volumes are replicated using the DRBD kernel module, the data path for the replication is kept entirely on kernel space, reducing its overhead when compared to solutions implemented in user space.
Terminology
¶
A LINSTOR cluster is composed of two main components:
controllers
and
satellites
. The LINSTOR controller manages the database and keeps track of the cluster state and configuration, while satellites provide storage and ability to mount volumes across the cluster. Clients interact only with the controller, which is responsible for orchestrating operations across satellites to fulfill the user’s request.
LINSTOR takes a somewhat object-oriented approach to its internal concepts. This manifests itself in the hierarchical nature of concepts and the fact that lower level objects can inherit properties from higher level ones.
LINSTOR has the concept of a
storage pool
, which describes physical storage that can be consumed by LINSTOR to create volumes. A storage pool defines its backend driver (such as LVM or ZFS), the cluster node in which it exists and properties that can be applied to either the storage pool itself or its backend storage.
In LINSTOR, a
resource
is the representation of a storage unit that can be consumed by instances. A resource is most often a DRBD replicated block device, and in that case represents one replica of that device. Resources can be grouped into
resource definitions
, which define common properties that should be inherited by all their child resources. Similarly,
resource groups
define common properties that are applied to their child resource definitions. Resource groups also define placement rules that define how many replicas should be created for a given resource definition, which storage pool should be used, how to spread the replicas among different availability zones, etc. The usual way to interact with LINSTOR is by defining a resource group with the desired properties and then
spawning
resources from it.
linstor
driver in Incus
¶
Note
LINSTOR can only move and mount volumes between its satellite nodes. Therefore, to ensure that all Incus cluster members can access volumes, all Incus nodes must also be LINSTOR satellite nodes. In other words, each node running the
incus
service should also run an
linstor-satellite
service.
Note, however, that this does not mean that Incus nodes must also provide storage. It is still possible to use LINSTOR while using separated storage and compute nodes by deploying “diskless” satellites on Incus nodes. Diskless nodes do not provide storage, but are still able to mount DRBD devices and perform IO over the network.
Unlike other storage drivers, this driver does not set up the storage system but assumes that you already have a LINSTOR cluster installed. The driver requires the
storage.linstor.controller_connection
option to be set to the endpoint of a LINSTOR controller that will be used by Incus.
This driver also behaves differently than other drivers in that it can provide both remote and local storage. If a diskful replica of the volume is available on the node, reads and writes can be performed locally to reduce latency (although writes must be synchronously replicated across replicas, so network latency still has an impact). At the same time, a diskless replica performs all IO over the network, enabling volumes to be mounted and used on any node regardless of its physical storage. These hybrid capabilities enable LINSTOR to provide low latency storage while retaining the flexibility of moving volumes across cluster nodes when needed.
The
linstor
driver in Incus uses resource groups to manage and spawn resources. The following table describes the mapping between Incus and LINSTOR concepts:
Incus concept
LINSTOR concept
Storage pool
Resource group
Volume
Resource definition
Snapshot
Snapshot
Incus assumes that it has full control over the LINSTOR resource group.
Therefore, you should never maintain any entities that are not owned by Incus in an Incus LINSTOR resource group, because Incus might delete them.
When managing resources, Incus needs to be able to determine which LINSTOR satellite node corresponds to a given Incus node. By default, Incus assumes that its node names match LINSTOR’s (e.g.
incus
cluster
list
and
linstor
node
list
show the same node names). When Incus is running as a standalone server (i.e. not clustered), the hostname is used as the node name. If node names between Incus and LINSTOR do not match, the
storage.linstor.satellite.name
can be set on each Incus node to the appropriate LINSTOR satellite node name.
Limitations
¶
The
linstor
driver has the following limitations:
Sharing custom volumes between instances
Custom storage volumes with
content type
filesystem
can usually be shared between multiple instances different cluster members.
However, because the LINSTOR driver “simulates” volumes with content type
filesystem
by putting a file system on top of an DRBD replicated device, custom storage volumes can only be assigned to a single instance at a time.
Sharing the resource group between installations
Sharing the same LINSTOR resource group between multiple Incus installations is not supported.
Restoring from older snapshots
LINSTOR doesn’t support restoring from snapshots other than the latest one.
You can, however, create new instances from older snapshots.
This method makes it possible to confirm whether a specific snapshot contains what you need.
After determining the correct snapshot, you can
remove the newer snapshots
so that the snapshot you need is the latest one and you can restore it.
Alternatively, you can configure Incus to automatically discard the newer snapshots during restore.
To do so, set the
linstor.remove_snapshots
configuration for the volume (or the corresponding
volume.linstor.remove_snapshots
configuration on the storage pool for all volumes in the pool).
Configuration options
¶
The following configuration options are available for storage pools that use the
linstor
driver and for storage volumes in these pools.
Storage pool configuration
¶
drbd.auto_add_quorum_tiebreaker
Whether to allow LINSTOR to automatically create diskless resources to act as quorum tiebreakers if needed (applied to the resource group)
Key:
drbd.auto_add_quorum_tiebreaker
Type:
bool
Default:
true
Scope:
global
drbd.auto_diskful
A duration string describing the time after which a primary diskless resource can be converted to diskful if storage is available on the node (applied to the resource group)
Key:
drbd.auto_diskful
Type:
string
Default:
Scope:
global
drbd.on_no_quorum
The DRBD policy to use on resources when quorum is lost (applied to the resource group)
Key:
drbd.on_no_quorum
Type:
string
Default:
Scope:
global
linstor.raw.*
Extra LINSTOR properties to set. For example,
BCache/PoolName
is encoded as
linstor.raw.BCache/PoolName
.
Key:
linstor.raw.*
Type:
string
Scope:
global
linstor.resource_group.name
Name of the LINSTOR resource group that will be used for the storage pool
Key:
linstor.resource_group.name
Type:
string
Default:
incus
Scope:
global
linstor.resource_group.place_count
Number of diskful replicas that should be created for resources in the resource group. Increasing the value of this option on a pool that already has volumes will result in LINSTOR creating new diskful replicas for all existing resources to match the new value
Key:
linstor.resource_group.place_count
Type:
int
Default:
2
Scope:
global
linstor.resource_group.storage_pool
The storage pool name in which resources should be placed on satellite nodes
Key:
linstor.resource_group.storage_pool
Type:
string
Default:
Scope:
global
linstor.volume.prefix
The prefix to use for the internal names of LINSTOR-managed volumes. Cannot be updated after the storage pool is created
Key:
linstor.volume.prefix
Type:
string
Default:
incus-volume-
Scope:
global
source
LINSTOR storage pool name. Alias for
linstor.resource_group.name
. Use either either one or the other or make sure they have the same value.
Key:
source
Type:
string
Default:
incus
Scope:
global
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
drbd.auto_add_quorum_tiebreaker
Whether to allow LINSTOR to automatically create diskless resources to act as quorum tiebreakers if needed (applied to the resource definition)
Key:
drbd.auto_add_quorum_tiebreaker
Type:
bool
Default:
true
Condition:
drbd.auto_diskful
A duration string describing the time after which a primary diskless resource can be converted to diskful if storage is available on the node (applied to the resource definition)
Key:
drbd.auto_diskful
Type:
string
Default:
Condition:
drbd.on_no_quorum
The DRBD policy to use on resources when quorum is lost (applied to the resource definition)
Key:
drbd.on_no_quorum
Type:
string
Default:
Condition:
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
linstor.raw.*
Extra LINSTOR properties to set. For example,
BCache/PoolName
is encoded as
linstor.raw.BCache/PoolName
.
Key:
linstor.raw.*
Type:
string
Scope:
global
linstor.remove_snapshots
Remove snapshots as needed
Key:
linstor.remove_snapshots
Type:
bool
Default:
same as
volume.linstor.remove_snapshots
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
