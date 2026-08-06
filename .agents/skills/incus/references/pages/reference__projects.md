# Project configuration

Source: https://linuxcontainers.org/incus/docs/main/reference/projects/
Fetched: 2026-08-07

Project configuration
¶
Projects can be configured through a set of key/value configuration options.
See
Configure a project
for instructions on how to set these options.
The key/value configuration is namespaced.
The following options are available:
Project features
Project limits
Project restrictions
Project-specific configuration
Project features
¶
The project features define which entities are isolated in the project and which are inherited from the
default
project.
If a
feature.*
option is set to
true
, the corresponding entity is isolated in the project.
Note
When you create a project without explicitly configuring a specific option, this option is set to the initial value given in the following table.
However, if you unset one of the
feature.*
options, it does not go back to the initial value, but to the default value.
The default value for all
feature.*
options is
false
.
features.images
Whether to use a separate set of images for the project
Key:
features.images
Type:
bool
Default:
false
Initial value:
true
This setting applies to both images and image aliases.
features.networks
Whether to use a separate set of networks for the project
Key:
features.networks
Type:
bool
Default:
false
Initial value:
false
features.networks.zones
Whether to use a separate set of network zones for the project
Key:
features.networks.zones
Type:
bool
Default:
false
Initial value:
false
features.profiles
Whether to use a separate set of profiles for the project
Key:
features.profiles
Type:
bool
Default:
false
Initial value:
true
features.storage.buckets
Whether to use a separate set of storage buckets for the project
Key:
features.storage.buckets
Type:
bool
Default:
false
Initial value:
true
features.storage.volumes
Whether to use a separate set of storage volumes for the project
Key:
features.storage.volumes
Type:
bool
Default:
false
Initial value:
true
Project limits
¶
Project limits define a hard upper bound for the resources that can be used by the containers and VMs that belong to a project.
Depending on the
limits.*
option, the limit applies to the number of entities that are allowed in the project (for example,
limits.containers
or
limits.networks
) or to the aggregate value of resource usage for all instances in the project (for example,
limits.cpu
or
limits.processes
).
In the latter case, the limit usually applies to the
Resource limits
that are configured for each instance (either directly or via a profile), and not to the resources that are actually in use.
For example, if you set the project’s
limits.memory
configuration to
50GiB
, the sum of the individual values of all
limits.memory
configuration keys defined on the project’s instances will be kept under 50 GiB.
Similarly, setting the project’s
limits.cpu
configuration key to
100
means that the sum of individual
limits.cpu
values will be kept below 100.
When using project limits, the following conditions must be fulfilled:
When you set one of the
limits.*
configurations and there is a corresponding configuration for the instance, all instances in the project must have the corresponding configuration defined (either directly or via a profile).
See
Resource limits
for the instance configuration options.
The
limits.cpu
configuration cannot be used if
CPU pinning
is enabled.
This means that to use
limits.cpu
on a project, the
limits.cpu
configuration of each instance in the project must be set to a number of CPUs, not a set or a range of CPUs.
The
limits.memory
configuration must be set to an absolute value, not a percentage.
limits.containers
Maximum number of containers that can be created in the project
Key:
limits.containers
Type:
integer
limits.cpu
Maximum number of CPUs to use in the project
Key:
limits.cpu
Type:
integer
This value is the maximum value for the sum of the individual
limits.cpu
configurations set on the instances of the project.
limits.disk
Maximum disk space used by the project
Key:
limits.disk
Type:
string
This value is the maximum value of the aggregate disk space used by all instance volumes, custom volumes, and images of the project.
limits.disk.pool.POOL_NAME
Maximum disk space used by the project on this pool
Key:
limits.disk.pool.POOL_NAME
Type:
string
This value is the maximum value of the aggregate disk
space used by all instance volumes, custom volumes, and images of the
project on this specific storage pool.
limits.instances
Maximum number of instances that can be created in the project
Key:
limits.instances
Type:
integer
limits.memory
Usage limit for the host’s memory for the project
Key:
limits.memory
Type:
string
The value is the maximum value for the sum of the individual
limits.memory
configurations set on the instances of the project.
limits.networks
Maximum number of networks that the project can have
Key:
limits.networks
Type:
integer
limits.processes
Maximum number of processes within the project
Key:
limits.processes
Type:
integer
This value is the maximum value for the sum of the individual
limits.processes
configurations set on the instances of the project.
limits.virtual-machines
Maximum number of VMs that can be created in the project
Key:
limits.virtual-machines
Type:
integer
Project restrictions
¶
To prevent the instances of a project from accessing security-sensitive features (such as container nesting or raw LXC configuration), set the
restricted
configuration option to
true
.
You can then use the various
restricted.*
options to pick individual features that would normally be blocked by
restricted
and allow them, so they can be used by the instances of the project.
For example, to restrict a project and block all security-sensitive features, but allow container nesting, enter the following commands:
```
incus project set <project_name> restricted=true
incus project set <project_name> restricted.containers.nesting=allow

```
Each security-sensitive feature has an associated
restricted.*
project configuration option.
If you want to allow the usage of a feature, change the value of its
restricted.*
option.
Most
restricted.*
configurations are binary switches that can be set to either
block
(the default) or
allow
.
However, some options support other values for more fine-grained control.
Note
You must set the
restricted
configuration to
true
for any of the
restricted.*
options to be effective.
If
restricted
is set to
false
, changing a
restricted.*
option has no effect.
Setting all
restricted.*
keys to
allow
is equivalent to setting
restricted
itself to
false
.
restricted
Whether to block access to security-sensitive features
Key:
restricted
Type:
bool
Default:
false
This option must be enabled to allow the
restricted.*
keys to take effect.
To temporarily remove the restrictions, you can disable this option instead of clearing the related keys.
restricted.backups
Whether to prevent creating instance or volume backups
Key:
restricted.backups
Type:
string
Default:
block
Possible values are
allow
or
block
.
restricted.cluster.groups
Cluster groups that can be targeted
Key:
restricted.cluster.groups
Type:
string
If specified, this option prevents targeting cluster groups other than the provided ones.
restricted.cluster.target
Whether to prevent targeting of cluster members
Key:
restricted.cluster.target
Type:
string
Default:
block
Possible values are
allow
or
block
.
When set to
allow
, this option allows targeting of cluster members (either directly or via a group) when creating or moving instances.
restricted.containers.interception
Whether to prevent using system call interception options
Key:
restricted.containers.interception
Type:
string
Default:
block
Possible values are
allow
,
block
, or
full
.
When set to
allow
, interception options that are usually safe are allowed.
File system mounting remains blocked.
restricted.containers.lowlevel
Whether to prevent using low-level container options
Key:
restricted.containers.lowlevel
Type:
string
Default:
block
Possible values are
allow
or
block
.
When set to
allow
, low-level container options like
raw.lxc
,
raw.idmap
,
volatile.*
, etc. can be used.
restricted.containers.nesting
Whether to prevent running nested Incus
Key:
restricted.containers.nesting
Type:
string
Default:
block
Possible values are
allow
or
block
.
When set to
allow
,
security.nesting
can be set to
true
for an instance.
restricted.containers.privilege
Which settings for privileged containers to prevent
Key:
restricted.containers.privilege
Type:
string
Default:
unprivileged
Possible values are
unprivileged
,
isolated
, and
allow
.
When set to
unprivileged
, this option prevents setting
security.privileged
to
true
.
When set to
isolated
, this option prevents setting
security.privileged
to
true
and
security.idmap.isolated
to
false
.
When set to
allow
, there is no restriction.
restricted.devices.disk
Which disk devices can be used
Key:
restricted.devices.disk
Type:
string
Default:
managed
Possible values are
allow
,
block
, or
managed
.
When set to
block
, this option prevents using all disk devices except the root one.
When set to
managed
, this option allows using disk devices only if
pool=
is set.
When set to
allow
, there is no restriction on which disk devices can be used.
restricted.devices.disk.paths
Which
source
can be used for
disk
devices
Key:
restricted.devices.disk.paths
Type:
string
If
restricted.devices.disk
is set to
allow
, this option controls which
source
can be used for
disk
devices.
Specify a comma-separated list of path prefixes that restrict the
source
setting.
If this option is left empty, all paths are allowed.
restricted.devices.gpu
Whether to prevent using devices of type
gpu
Key:
restricted.devices.gpu
Type:
string
Default:
block
Possible values are
allow
or
block
.
restricted.devices.infiniband
Whether to prevent using devices of type
infiniband
Key:
restricted.devices.infiniband
Type:
string
Default:
block
Possible values are
allow
or
block
.
restricted.devices.nic
Which network devices can be used
Key:
restricted.devices.nic
Type:
string
Default:
managed
Possible values are
allow
,
block
, or
managed
.
When set to
block
, this option prevents using all network devices.
When set to
managed
, this option allows using network devices only if
network=
is set.
When set to
allow
, there is no restriction on which network devices can be used.
restricted.devices.pci
Whether to prevent using devices of type
pci
Key:
restricted.devices.pci
Type:
string
Default:
block
Possible values are
allow
or
block
.
restricted.devices.proxy
Whether to prevent using devices of type
proxy
Key:
restricted.devices.proxy
Type:
string
Default:
block
Possible values are
allow
or
block
.
restricted.devices.unix-block
Whether to prevent using devices of type
unix-block
Key:
restricted.devices.unix-block
Type:
string
Default:
block
Possible values are
allow
or
block
.
restricted.devices.unix-char
Whether to prevent using devices of type
unix-char
Key:
restricted.devices.unix-char
Type:
string
Default:
block
Possible values are
allow
or
block
.
restricted.devices.unix-hotplug
Whether to prevent using devices of type
unix-hotplug
Key:
restricted.devices.unix-hotplug
Type:
string
Default:
block
Possible values are
allow
or
block
.
restricted.devices.usb
Whether to prevent using devices of type
usb
Key:
restricted.devices.usb
Type:
string
Default:
block
Possible values are
allow
or
block
.
restricted.idmap.gid
Which host GID ranges are allowed in
raw.idmap
Key:
restricted.idmap.gid
Type:
string
This option specifies the host GID ranges that are allowed in the instance’s
raw.idmap
setting.
restricted.idmap.uid
Which host UID ranges are allowed in
raw.idmap
Key:
restricted.idmap.uid
Type:
string
This option specifies the host UID ranges that are allowed in the instance’s
raw.idmap
setting.
restricted.images.servers
Which image servers (HTTP host) are allowed for us in this project
Key:
restricted.images.servers
Type:
string
Specify a comma-delimited list of image servers domains that are allowed for use in this project.
If this option is not set, all image servers are accessible.
restricted.networks.access
Which network names are allowed for use in this project
Key:
restricted.networks.access
Type:
string
Specify a comma-delimited list of network names that are allowed for use in this project.
If this option is not set, all networks are accessible.
Note that this setting depends on the
restricted.devices.nic
setting.
restricted.networks.integrations
Which network integrations can be used in this project
Key:
restricted.networks.integrations
Type:
string
Specify a comma-delimited list of network integrations that can be used by networks in this project.
restricted.networks.subnets
Which network subnets are allocated for use in this project
Key:
restricted.networks.subnets
Type:
string
Default:
block
Specify a comma-delimited list of network subnets from the uplink networks that are allocated for use in this project.
Use the form
<uplink>:<subnet>
.
restricted.networks.uplinks
Which network names can be used as uplink in this project
Key:
restricted.networks.uplinks
Type:
string
Specify a comma-delimited list of network names that can be used as uplink for networks in this project.
restricted.networks.zones
Which network zones can be used in this project
Key:
restricted.networks.zones
Type:
string
Default:
block
Specify a comma-delimited list of network zones that can be used (or something under them) in this project.
restricted.snapshots
Whether to prevent creating instance or volume snapshots
Key:
restricted.snapshots
Type:
string
Default:
block
restricted.storage-pools.access
Which storage pool names are allowed for use in this project
Key:
restricted.storage-pools.access
Type:
string
Specify a comma-delimited list of storage pool names that are allowed for use in this project.
If this option is not set, all storage pools are accessible.
restricted.virtual-machines.lowlevel
Whether to prevent using low-level VM options
Key:
restricted.virtual-machines.lowlevel
Type:
string
Default:
block
Possible values are
allow
or
block
.
When set to
allow
, low-level VM options like
raw.qemu
,
volatile.*
, etc. can be used.
restricted.virtual-machines.nesting
Whether to prevent using nested virtualization
Key:
restricted.virtual-machines.nesting
Type:
string
Default:
allow
Possible values are
allow
or
block
.
When set to
block
,
security.nesting
must be set to
false
on all virtual machines, turning off nested virtualization.
Project-specific configuration
¶
There are some
Server configuration
options that you can override for a project.
In addition, you can add user metadata for a project.
backups.compression_algorithm
Compression algorithm to use for backups
Key:
backups.compression_algorithm
Type:
string
Specify which compression algorithm to use for backups in this project.
Possible values are
bzip2
,
gzip
,
lz4
,
lzma
,
xz
,
zstd
or
none
.
images.auto_update_cached
Whether to automatically update cached images in the project
Key:
images.auto_update_cached
Type:
bool
images.auto_update_interval
Interval at which to look for updates to cached images
Key:
images.auto_update_interval
Type:
integer
Specify the interval in hours.
To disable looking for updates to cached images, set this option to
0
.
images.compression_algorithm
Compression algorithm to use for new images in the project
Key:
images.compression_algorithm
Type:
string
Possible values are
bzip2
,
gzip
,
lz4
,
lzma
,
xz
,
zstd
or
none
.
images.default_architecture
Default architecture to use in a mixed-architecture cluster
Key:
images.default_architecture
Type:
string
images.remote_cache_expiry
When an unused cached remote image is flushed in the project
Key:
images.remote_cache_expiry
Type:
integer
Specify the number of days after which the unused cached image expires.
network.hwaddr_pattern
MAC address template
Key:
network.hwaddr_pattern
Type:
string
Scope:
global
Specify a MAC address template, e.g.
10:66:6a:xx:xx:xx
, to use within the cluster.
Every
x
in the template will be replaced by a random character in
0
–
f
.
Beware of the birthday paradox! A single
xx
block leads to a 10% collision probability with only 8 addresses; for a double
xx:xx
block, 118 addresses; for a triple
xx:xx:xx
block, 1881; for a quadruple
xx:xx:xx:xx
block, 30084. We provide absolutely no guardrail against that.
user.*
User-provided free-form key/value pairs
Key:
user.*
Type:
string
