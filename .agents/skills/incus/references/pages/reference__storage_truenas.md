# TrueNAS - truenas

Source: https://linuxcontainers.org/incus/docs/main/reference/storage_truenas/
Fetched: 2026-08-07

TrueNAS -
truenas
¶
The
truenas
storage driver in Incus
¶
The
truenas
storage driver enables an Incus node to use a remote
TrueNAS storage server to host one or more Incus storage pools. When the
node is part of a cluster, all cluster members can access the storage
pool simultaneously, making it ideal for use cases such as live
migrating virtual machines (VMs) between nodes.
The driver operates in a block-based manner, meaning that all Incus
volumes are created as ZFS Volume block devices on the remote TrueNAS
server. These ZFS Volume block devices are accessed on the local Incus
node via iSCSI.
Modeled after the existing ZFS driver, the
truenas
driver supports
most standard ZFS functionality, but operates on remote TrueNAS servers.
For instance, a local VM can be snapshotted and cloned, with the
snapshot and clone operations performed on the remote server after
synchronizing the local file system. The clone is then activated through
iSCSI as necessary.
Each storage pool corresponds to a ZFS dataset on a remote TrueNAS host.
The dataset is created automatically if it does not exist. The driver
uses ZFS features available on the remote host to support efficient
image handling, copy operations, and snapshot management without
requiring nested ZFS (ZFS-on-ZFS).
To reference a remote dataset, the
source
property can be specified in the form:
[<remote
host>:]<remote
pool>[[/<remote
dataset>]...][/]
If the path ends with a trailing
/
, the dataset name will be derived
from the Incus storage pool name (e.g.,
tank/pool1
).
Requirements
¶
The driver relies on the
truenas_incus_ctl
tool
to interact with the TrueNAS API and perform actions on the remote
server. This tool also manages the activation and deactivation of remote
ZFS Volumes via
open-iscsi
. If
truenas_incus_ctl
is not installed or
available in the system’s PATH, the driver will be disabled.
To install the required tool, download the latest version (v0.7.2+ is
required) from the
truenas\_incus\_ctl
GitHub
page
. Additionally,
ensure that
open-iscsi
is installed on the system, which can be done
using:
```
sudo apt install open-iscsi

```
Logging in to the TrueNAS host
¶
As an alternative to manually creating an API Key and supplying using the
truenas.api_key
property, you can instead
login
to the remote server using the
truenas_incus_ctl
tool.
```
sudo truenas_incus_ctl config login

```
This will prompt you to provide connection details for the TrueNAS server, including authentication details, and will save the configuration to a local file. After logging in, you can verify the iSCSI setup with:
```
sudo truenas_incus_ctl share iscsi setup --test

```
Once the tool is configured, you can use it to interact with remote datasets and create storage pools:
```
incus storage create <poolname> truenas source=[host:]<pool>[/<dataset>]/[remote-poolname]

```
In this command:
source
refers to the location on the remote TrueNAS host where the storage pool will be created.
host
is optional, and can be specified using the
truenas.host
property, or by specifying a configuration with
truenas.config
If
remote-poolname
is not supplied, it will default to the name of the local pool.
Configuration options
¶
The following configuration options are available for storage pools that use the
truenas
driver and for storage volumes in these pools.
Storage pool configuration
¶
source
ZFS dataset to use on the remote TrueNAS host. Format:
[<host>:]<pool>[/<dataset>][/]
. If
host
is omitted here, it must be set via
truenas.host
.
Key:
source
Type:
string
Default:
Scope:
local
truenas.allow_insecure
If set to
true
, allows insecure (non-TLS) connections to the TrueNAS API.
Key:
truenas.allow_insecure
Type:
bool
Default:
false
Scope:
global
truenas.api_key
API key used to authenticate with the TrueNAS host.
Key:
truenas.api_key
Type:
string
Default:
Scope:
global
truenas.clone_copy
Whether to use lightweight clones rather than full
dataset
copies.
Key:
truenas.clone_copy
Type:
bool
Default:
true
Scope:
global
truenas.config
Path to a configuration file for the TrueNAS client tool.
Key:
truenas.config
Type:
string
Default:
Scope:
global
truenas.dataset
Remote dataset name. Typically inferred from
source
, but can be overridden.
Key:
truenas.dataset
Type:
string
Default:
Scope:
global
truenas.force_reuse
Allow to use an existing non-empty pool.
Key:
truenas.force_reuse
Type:
bool
Default:
false
Scope:
global
truenas.host
Hostname or IP address of the remote TrueNAS system. Optional if included in the
source
, or a configuration is used.
Key:
truenas.host
Type:
string
Default:
Scope:
global
truenas.initiator
iSCSI initiator name used during block volume attachment.
Key:
truenas.initiator
Type:
string
Default:
Scope:
global
truenas.portal
iSCSI portal address to use for block volume connections.
Key:
truenas.portal
Type:
string
Default:
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
truenas.blocksize
Size of the ZFS block in range from 512 bytes to 16 MiB (must be power of 2) - for block volume, a maximum value of 128 KiB will be used even if a higher value is set
Key:
truenas.blocksize
Type:
string
Default:
same as
volume.truenas.blocksize
Condition:
truenas.remove_snapshots
Remove snapshots as needed
Key:
truenas.remove_snapshots
Type:
bool
Default:
same as
volume.truenas.remove_snapshots
or
false
Condition:
truenas.use_refquota
Use
refquota
instead of
quota
for space
Key:
truenas.use_refquota
Type:
bool
Default:
same as
volume.truenas.use_refquota
or
false
Condition:
