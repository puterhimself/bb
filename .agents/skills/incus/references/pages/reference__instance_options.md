# Instance options

Source: https://linuxcontainers.org/incus/docs/main/reference/instance_options/
Fetched: 2026-08-07

Instance options
¶
Instance options are configuration options that are directly related to the instance.
See
Configure instance options
for instructions on how to set the instance options.
The key/value configuration is namespaced.
The following options are available:
Miscellaneous options
Boot-related options
cloud-init
configuration
Resource limits
Migration options
NVIDIA and CUDA configuration
OCI configuration
Raw instance configuration overrides
Security policies
Snapshot scheduling and configuration
Volatile internal data
Note that while a type is defined for each option, all values are stored as strings and should be exported over the REST API as strings (which makes it possible to support any extra values without breaking backward compatibility).
Miscellaneous options
¶
In addition to the configuration options listed in the following sections, these instance options are supported:
agent.nic_config
Whether to use the name and MTU of the default network interfaces
Key:
agent.nic_config
Type:
bool
Default:
false
Live update:
no
Condition:
virtual machine
For containers, the name and MTU of the default network interfaces is used for the instance devices.
For virtual machines, set this option to
true
to set the name and MTU of the default network interfaces to be the same as the instance devices.
cluster.evacuate
What to do when evacuating the instance
Key:
cluster.evacuate
Type:
string
Default:
auto
Live update:
no
The
cluster.evacuate
provides control over how instances are handled when a cluster member is being
evacuated.
Available Modes:
auto
(default)
: The system will automatically decide the best evacuation method based on the
instance’s type and configured devices:
If any device is not suitable for migration, the instance will not be migrated (only stopped).
Live migration will be used only for virtual machines with the
migration.stateful
setting
enabled and for which all its devices can be migrated as well.
live-migrate
: Instances are live-migrated to another server. This means the instance remains running
and operational during the migration process, ensuring minimal disruption.
migrate
: In this mode, instances are migrated to another server in the cluster. The migration
process will not be live, meaning there will be a brief downtime for the instance during the
migration.
stop
: Instances are not migrated. Instead, they are stopped on the current server.
stateful-stop
: Instances are not migrated. Instead, they are stopped on the current server
but with their runtime state (memory) stored on disk for resuming on restore.
force-stop
: Instances are not migrated. Instead, they are forcefully stopped.
See
Evacuate and restore cluster members
for more information.
environment.*
Free-form environment key/value
Key:
environment.*
Type:
string
Live update:
yes
Extra environment variables to set on boot and during exec.
linux.kernel_modules
Kernel modules to load before starting the instance
Key:
linux.kernel_modules
Type:
string
Live update:
yes
Condition:
container
Specify the kernel modules as a comma-separated list.
linux.sysctl.*
Override for the corresponding
sysctl
setting in the container
Key:
linux.sysctl.*
Type:
string
Live update:
no
Condition:
container
smbios11.*
Free-form
SMBIOS
Type
11
key/value
Key:
smbios11.*
Type:
string
Live update:
yes
SMBIOS
Type
11
configuration keys.
systemd.credential-binary.*
Systemd credential key/value, where value is Base64 encoded
Key:
systemd.credential-binary.*
Type:
string
Live update:
yes
Systemd credential key/value pair passed as a read-only bind mount in containers and as
SMBIOS
Type
11
data in virtual machines. The value is Base64 encoded.
systemd.credential.*
Systemd credential key/value
Key:
systemd.credential.*
Type:
string
Live update:
yes
Systemd credential key/value pair passed as a read-only bind mount in containers and as
SMBIOS
Type
11
data in virtual machines.
user.*
Free-form user key/value storage
Key:
user.*
Type:
string
Live update:
yes
User keys can be used in search.
environment.*
Environment variables for the instance
Key:
environment.*
Type:
string
Live update:
yes (exec)
You can export key/value environment variables to the instance.
These are then set for
incus
exec
.
Boot-related options
¶
The following instance options control the boot-related behavior of the instance:
boot.autorestart
Whether to automatically restart an instance on unexpected exit
Key:
boot.autorestart
Type:
bool
Live update:
no
If set to
true
will attempt up to 10 restarts over a 1 minute period upon unexpected instance exit.
boot.autostart
Whether to always start the instance when the daemon starts
Key:
boot.autostart
Type:
bool
Live update:
no
If unset or set to
last-state
, restores the last state.
boot.autostart.delay
Delay after starting the instance
Key:
boot.autostart.delay
Type:
integer
Default:
0
Live update:
no
The number of seconds to wait after the instance started before starting the next one.
boot.autostart.priority
What order to start the instances in
Key:
boot.autostart.priority
Type:
integer
Live update:
no
The instance with the highest value is started first.
Instances without a priority set will be started (with some parallelism) ahead of
instances with a priority set.
boot.host_shutdown_action
What action to take on the instance when the host is shut down
Key:
boot.host_shutdown_action
Type:
string
Default:
stop
Live update:
yes
Action to take on host shut down
Valid values are:
stop
,
force-stop
or
stateful-stop
boot.host_shutdown_timeout
How long to wait for the instance to shut down
Key:
boot.host_shutdown_timeout
Type:
integer
Default:
30
Live update:
yes
Number of seconds to wait for the instance to shut down before it is force-stopped.
boot.stop.priority
What order to shut down the instances in
Key:
boot.stop.priority
Type:
integer
Default:
0
Live update:
no
The instance with the highest value is shut down first.
cloud-init
configuration
¶
The following instance options control the
cloud-init
configuration of the instance:
cloud-init.network-config
Network configuration for
cloud-init
Key:
cloud-init.network-config
Type:
string
Default:
DHCP
on
eth0
Live update:
no
Condition:
If supported by image
The content is used as seed value for
cloud-init
.
cloud-init.user-data
User data for
cloud-init
Key:
cloud-init.user-data
Type:
string
Default:
#cloud-config
Live update:
no
Condition:
If supported by image
The content is used as seed value for
cloud-init
.
cloud-init.vendor-data
Vendor data for
cloud-init
Key:
cloud-init.vendor-data
Type:
string
Default:
#cloud-config
Live update:
no
Condition:
If supported by image
The content is used as seed value for
cloud-init
.
user.network-config
Legacy version of
cloud-init.network-config
Key:
user.network-config
Type:
string
Default:
DHCP
on
eth0
Live update:
no
Condition:
If supported by image
user.user-data
Legacy version of
cloud-init.user-data
Key:
user.user-data
Type:
string
Default:
#cloud-config
Live update:
no
Condition:
If supported by image
user.vendor-data
Legacy version of
cloud-init.vendor-data
Key:
user.vendor-data
Type:
string
Default:
#cloud-config
Live update:
no
Condition:
If supported by image
Support for these options depends on the image that is used and is not guaranteed.
If you specify both
cloud-init.user-data
and
cloud-init.vendor-data
, the content of both options is merged.
Therefore, make sure that the
cloud-init
configuration you specify in those options does not contain the same keys.
Resource limits
¶
The following instance options specify resource limits for the instance:
limits.cpu
Which CPUs to expose to the instance
Key:
limits.cpu
Type:
string
Default:
1 (VMs)
Live update:
yes
A number or a specific range of CPUs to expose to the instance.
For virtual machines, a CPU topology of the form
sockets=2,cores=4,threads=2
may also be provided.
See
CPU pinning
for more information.
limits.cpu.allowance
How much of the CPU can be used
Key:
limits.cpu.allowance
Type:
string
Default:
100%
Live update:
yes
Condition:
container
To control how much of the CPU can be used, specify either a percentage (
50%
) for a soft limit
or a chunk of time (
25ms/100ms
) for a hard limit.
See
Allowance and priority (container only)
for more information.
limits.cpu.nodes
Which NUMA nodes to place the instance CPUs on
Key:
limits.cpu.nodes
Type:
string
Live update:
yes
A comma-separated list of NUMA node IDs or ranges to place the instance CPUs on.
Alternatively, the value
balanced
may be used to have Incus pick the least busy NUMA node on startup.
See
Allowance and priority (container only)
for more information.
limits.cpu.priority
CPU scheduling priority compared to other instances
Key:
limits.cpu.priority
Type:
integer
Default:
10
(maximum)
Live update:
yes
Condition:
container
When overcommitting resources, specify the CPU scheduling priority compared to other instances that share the same CPUs.
Specify an integer between 0 and 10.
See
Allowance and priority (container only)
for more information.
limits.disk.priority
Priority of the instance’s I/O requests
Key:
limits.disk.priority
Type:
integer
Default:
5
(medium)
Live update:
yes
Controls how much priority to give to the instance’s I/O requests when under load.
Specify an integer between 0 and 10.
limits.hugepages.1GB
Limit for the number of 1 GB huge pages
Key:
limits.hugepages.1GB
Type:
string
Live update:
yes
Condition:
container
Fixed value (in bytes) to limit the number of 1 GB huge pages.
Various suffixes are supported (see
Units for storage, memory and network limits
).
See
Huge page limits
for more information.
limits.hugepages.1MB
Limit for the number of 1 MB huge pages
Key:
limits.hugepages.1MB
Type:
string
Live update:
yes
Condition:
container
Fixed value (in bytes) to limit the number of 1 MB huge pages.
Various suffixes are supported (see
Units for storage, memory and network limits
).
See
Huge page limits
for more information.
limits.hugepages.2MB
Limit for the number of 2 MB huge pages
Key:
limits.hugepages.2MB
Type:
string
Live update:
yes
Condition:
container
Fixed value (in bytes) to limit the number of 2 MB huge pages.
Various suffixes are supported (see
Units for storage, memory and network limits
).
See
Huge page limits
for more information.
limits.hugepages.64KB
Limit for the number of 64 KB huge pages
Key:
limits.hugepages.64KB
Type:
string
Live update:
yes
Condition:
container
Fixed value (in bytes) to limit the number of 64 KB huge pages.
Various suffixes are supported (see
Units for storage, memory and network limits
).
See
Huge page limits
for more information.
limits.memory
Usage limit for the host’s memory
Key:
limits.memory
Type:
string
Default:
1GiB
(VMs)
Live update:
yes
Percentage of the host’s memory or a fixed value in bytes.
Various suffixes are supported.
See
Units for storage, memory and network limits
for details.
limits.memory.enforce
Whether the memory limit is
hard
or
soft
Key:
limits.memory.enforce
Type:
string
Default:
hard
Live update:
yes
Condition:
container
If the instance’s memory limit is
hard
, the instance cannot exceed its limit.
If it is
soft
, the instance can exceed its memory limit when extra host memory is available.
limits.memory.hotplug
Control upper limit for hotplugged memory or disable memory hotplug.
Key:
limits.memory.hotplug
Type:
string
Default:
true
Live update:
yes
Condition:
virtual machine
If this option is set to
false
, disable memory hotplug entirely.
Alternatively, it can be set to a bytes value which will define an upper limit for hotplugged memory.
The value must be greater than or equal to limits.memory.
limits.memory.hugepages
Whether to back the instance using huge pages
Key:
limits.memory.hugepages
Type:
bool
Default:
false
Live update:
no
Condition:
virtual machine
If this option is set to
false
, regular system memory is used.
limits.memory.oom_priority
Out Of Memory killer priority adjustment for the instance
Key:
limits.memory.oom_priority
Type:
integer
Default:
0
Live update:
yes
Specify an integer between -1000 and 1000.
A negative value makes the instance less likely to be killed by the Out Of Memory killer,
while a positive value makes it more likely to be killed.
The default value of 0 means no adjustment to the Out Of Memory score.
limits.memory.swap
Control swap usage by the instance
Key:
limits.memory.swap
Type:
string
Default:
true
Live update:
yes
Condition:
container
When set to
true
or
false
, it controls whether the container is likely to get some of
its memory swapped by the kernel. Alternatively, it can be set to a bytes value which will
then allow the container to make use of additional memory through swap.
Support for this is limited on cgroup2 systems due to lack of swap priority control.
limits.memory.swap.priority
Prevents the instance from being swapped to disk
Key:
limits.memory.swap.priority
Type:
integer
Default:
10
(maximum)
Live update:
yes
Condition:
container
Specify an integer between 0 and 10.
The higher the value, the less likely the instance is to be swapped to disk.
This currently doesn’t have any effect on cgroup2 systems.
limits.processes
Maximum number of processes that can run in the instance
Key:
limits.processes
Type:
integer
Default:
empty
Live update:
yes
Condition:
container
If left empty, no limit is set.
limits.kernel.*
Kernel resources per instance
Key:
limits.kernel.*
Type:
string
Live update:
no
Condition:
container
You can set kernel limits on an instance, for example, you can limit the number of open files.
See
Kernel resource limits
for more information.
Memory limits in virtual machines
¶
Incus supports both increasing and decreasing the memory allocation of virtual machines.
Increasing the memory is done through memory hot plug, effectively adding virtual memory sticks to the VM.
There is a limit of 16 virtual slots for this, limiting the number of memory increases that can be done without rebooting the VM.
Note
To avoid high resource usage and compatibility issues with guests, Incus limits memory hotplug to a maximum of 1TiB in clustered environments.
On standalone hosts, the default limit matches the total memory amount of the host system.
Some CPUs further reduce that amount based on how much memory they are able to address (physical / virtual bits).
Exceeding that limit require the instance be stopped, its
memory.limit
updated and then started back up.
Decreasing memory is not done through hot remove as that has a high risk of causing guest issues.
Instead the memory balloon device is used, causing memory pressure inside the guest and causing memory to be released.
This is a pretty slow process, so it is common for a memory reduction to fail to meet the requested value.
When that happens, re-applying the lower value will trigger another attempt.
As each attempt will cause the effective memory available to the guest to be reduced,
it should eventually succeed and lead to the guest having the desired memory limit applied.
CPU limits
¶
You have different options to limit CPU usage:
Set
limits.cpu
to restrict which CPUs the instance can see and use.
See
CPU pinning
for how to set this option.
Set
limits.cpu.allowance
to restrict the load an instance can put on the available CPUs.
This option is available only for containers.
See
Allowance and priority (container only)
for how to set this option.
It is possible to set both options at the same time to restrict both which CPUs are visible to the instance and the allowed usage of those instances.
However, if you use
limits.cpu.allowance
with a time limit, you should avoid using
limits.cpu
in addition, because that puts a lot of constraints on the scheduler and might lead to less efficient allocations.
The CPU limits are implemented through a mix of the
cpuset
and
cpu
cgroup controllers.
CPU pinning
¶
limits.cpu
results in CPU pinning through the
cpuset
controller.
You can specify either which CPUs or how many CPUs are visible and available to the instance:
To specify which CPUs to use, set
limits.cpu
to either a set of CPUs (for example,
1,2,3
) or a CPU range (for example,
0-3
).
To pin to a single CPU, use the range syntax (for example,
1-1
) to differentiate it from a number of CPUs.
If you specify a number (for example,
4
) of CPUs, Incus will do dynamic load-balancing of all instances that aren’t pinned to specific CPUs, trying to spread the load on the machine.
Instances are re-balanced every time an instance starts or stops, as well as whenever a CPU is added to the system.
CPU limits for virtual machines
¶
Note
Incus supports live-updating the
limits.cpu
option.
However, for virtual machines, this only means that the respective CPUs are hotplugged.
Depending on the guest operating system, you might need to either restart the instance or complete some manual actions to bring the new CPUs online.
Incus virtual machines default to having just one vCPU allocated, which shows up as matching the host CPU vendor and type, but has a single core and no threads.
When
limits.cpu
is set to a single integer, Incus allocates multiple vCPUs and exposes them to the guest as full cores.
Those vCPUs are not pinned to specific physical cores on the host.
The number of vCPUs can be updated while the VM is running.
Note
To avoid high resource usage and compatibility issues with guests, Incus limits CPU hotplug to a maximum of 64 cores.
VMs needing more than 64 CPU cores will need to be shut down to adjust their
limits.cpu
property.
You can also request a specific CPU topology by setting
limits.cpu
to a value of the form
sockets=2,cores=4,threads=2
.
Any of the three fields may be omitted, in which case it defaults to
1
.
For example,
sockets=2
results in two vCPUs (two sockets, each with a single core and a single thread), while
cores=4
results in four vCPUs (a single socket with four cores).
The resulting topology is exposed verbatim to the guest and the vCPUs are not pinned to specific physical cores on the host.
Note
Using the CPU topology syntax is incompatible with CPU hotplugging.
The virtual machine must be stopped to switch to or away from such a value.
When
limits.cpu
is set to a range or comma-separated list of CPU IDs (as provided by
incus
info
--resources
), the vCPUs are pinned to those physical cores.
In this scenario, Incus checks whether the CPU configuration lines up with a realistic hardware topology and if it does, it replicates that topology in the guest.
When doing CPU pinning, it is not possible to change the configuration while the VM is running.
For example, if the pinning configuration includes eight threads, with each pair of thread coming from the same core and an even number of cores spread across two CPUs, the guest will show two CPUs, each with two cores and each core with two threads.
The NUMA layout is similarly replicated and in this scenario, the guest would most likely end up with two NUMA nodes, one for each CPU socket.
In such an environment with multiple NUMA nodes, the memory is similarly divided across NUMA nodes and be pinned accordingly on the host and then exposed to the guest.
All this allows for very high performance operations in the guest as the guest scheduler can properly reason about sockets, cores and threads as well as consider NUMA topology when sharing memory or moving processes across NUMA nodes.
Allowance and priority (container only)
¶
limits.cpu.allowance
drives either the CFS scheduler quotas when passed a time constraint, or the generic CPU shares mechanism when passed a percentage value:
The time constraint (for example,
20ms/50ms
) is a hard limit.
For example, if you want to allow the container to use a maximum of one CPU, set
limits.cpu.allowance
to a value like
100ms/100ms
.
The value is relative to one CPU worth of time, so to restrict to two CPUs worth of time, use something like
100ms/50ms
or
200ms/100ms
.
When using a percentage value, the limit is a soft limit that is applied only when under load.
It is used to calculate the scheduler priority for the instance, relative to any other instance that is using the same CPU or CPUs.
For example, to limit the CPU usage of the container to one CPU when under load, set
limits.cpu.allowance
to
100%
.
limits.cpu.priority
is another factor that is used to compute the scheduler priority score when a number of instances sharing a set of CPUs have the same percentage of CPU assigned to them.
Huge page limits
¶
Incus allows to limit the number of huge pages available to a container through the
limits.hugepage.[size]
key.
Architectures often expose multiple huge-page sizes.
The available huge-page sizes depend on the architecture.
Setting limits for huge pages is especially useful when Incus is configured to intercept the
mount
syscall for the
hugetlbfs
file system in unprivileged containers.
When Incus intercepts a
hugetlbfs
mount
syscall, it mounts the
hugetlbfs
file system for a container with correct
uid
and
gid
values as mount options.
This makes it possible to use huge pages from unprivileged containers.
However, it is recommended to limit the number of huge pages available to the container through
limits.hugepages.[size]
to stop the container from being able to exhaust the huge pages available to the host.
Limiting huge pages is done through the
hugetlb
cgroup controller, which means that the host system must expose the
hugetlb
controller for these limits to apply.
Kernel resource limits
¶
For container instances, Incus exposes a generic namespaced key
limits.kernel.*
that can be used to set resource limits.
It is generic in the sense that Incus does not perform any validation on the resource that is specified following the
limits.kernel.*
prefix.
Incus cannot know about all the possible resources that a given kernel supports.
Instead, Incus simply passes down the corresponding resource key after the
limits.kernel.*
prefix and its value to the kernel.
The kernel does the appropriate validation.
This allows users to specify any supported limit on their system.
Some common limits are:
limits.kernel.as
Maximum size of the process’s virtual memory
Key:
limits.kernel.as
Type:
string
Resource:
RLIMIT_AS
limits.kernel.core
Maximum size of the process’s core dump file
Key:
limits.kernel.core
Type:
string
Resource:
RLIMIT_CORE
limits.kernel.cpu
Limit in seconds on the amount of CPU time the process can consume
Key:
limits.kernel.cpu
Type:
string
Resource:
RLIMIT_CPU
limits.kernel.data
Maximum size of the process’s data segment
Key:
limits.kernel.data
Type:
string
Resource:
RLIMIT_DATA
limits.kernel.fsize
Maximum size of files the process may create
Key:
limits.kernel.fsize
Type:
string
Resource:
RLIMIT_FSIZE
limits.kernel.locks
Limit on the number of file locks that this process may establish
Key:
limits.kernel.locks
Type:
string
Resource:
RLIMIT_LOCKS
limits.kernel.memlock
Limit on the number of bytes of memory that the process may lock in RAM
Key:
limits.kernel.memlock
Type:
string
Resource:
RLIMIT_MEMLOCK
limits.kernel.nice
Maximum value to which the process’s nice value can be raised
Key:
limits.kernel.nice
Type:
string
Resource:
RLIMIT_NICE
limits.kernel.nofile
Maximum number of open files for the process
Key:
limits.kernel.nofile
Type:
string
Resource:
RLIMIT_NOFILE
limits.kernel.nproc
Maximum number of processes that can be created for the user of the calling process
Key:
limits.kernel.nproc
Type:
string
Resource:
RLIMIT_NPROC
limits.kernel.rtprio
Maximum value on the real-time-priority that may be set for this process
Key:
limits.kernel.rtprio
Type:
string
Resource:
RLIMIT_RTPRIO
limits.kernel.sigpending
Limit on the number of bytes of memory that the process may lock in RAM
Key:
limits.kernel.sigpending
Type:
string
Resource:
RLIMIT_SIGPENDING
A full list of all available limits can be found in the manpages for the
getrlimit(2)
/
setrlimit(2)
system calls.
To specify a limit within the
limits.kernel.*
namespace, use the resource name in lowercase without the
RLIMIT_
prefix.
For example,
RLIMIT_NOFILE
should be specified as
nofile
.
A limit is specified as two colon-separated values that are either numeric or the word
unlimited
(for example,
limits.kernel.nofile=1000:2000
).
A single value can be used as a shortcut to set both soft and hard limit to the same value (for example,
limits.kernel.nofile=3000
).
A resource with no explicitly configured limit will inherit its limit from the process that starts up the container.
Note that this inheritance is not enforced by Incus but by the kernel.
Migration options
¶
The following instance options control the behavior if the instance is
moved from one Incus server to another
:
migration.incremental.memory
Whether to use incremental memory transfer
Key:
migration.incremental.memory
Type:
bool
Default:
false
Live update:
yes
Condition:
container
Using incremental memory transfer of the instance’s memory can reduce downtime.
migration.incremental.memory.goal
Percentage of memory to have in sync before stopping the instance
Key:
migration.incremental.memory.goal
Type:
integer
Default:
70
Live update:
yes
Condition:
container
migration.incremental.memory.iterations
Maximum number of transfer operations to go through before stopping the instance
Key:
migration.incremental.memory.iterations
Type:
integer
Default:
10
Live update:
yes
Condition:
container
migration.stateful
Whether to allow for stateful stop/start and snapshots
Key:
migration.stateful
Type:
bool
Default:
false
Live update:
no
Enabling this option prevents the use of some features that are incompatible with it.
NVIDIA and CUDA configuration
¶
The following instance options specify the NVIDIA and CUDA configuration of the instance:
nvidia.driver.capabilities
What driver capabilities the instance needs
Key:
nvidia.driver.capabilities
Type:
string
Default:
compute,utility
Live update:
no
Condition:
container
The specified driver capabilities are used to set
libnvidia-container
NVIDIA_DRIVER_CAPABILITIES
.
nvidia.require.cuda
Required CUDA version
Key:
nvidia.require.cuda
Type:
string
Live update:
no
Condition:
container
The specified version expression is used to set
libnvidia-container
NVIDIA_REQUIRE_CUDA
.
nvidia.require.driver
Required driver version
Key:
nvidia.require.driver
Type:
string
Live update:
no
Condition:
container
The specified version expression is used to set
libnvidia-container
NVIDIA_REQUIRE_DRIVER
.
nvidia.runtime
Whether to pass the host NVIDIA and CUDA runtime libraries into the instance
Key:
nvidia.runtime
Type:
bool
Default:
false
Live update:
no
Condition:
container
OCI configuration
¶
The following instance options specify the OCI configuration of the instance:
oci.cwd
Working directory
Key:
oci.cwd
Type:
string
Live update:
no
Condition:
OCI container
Override the working directory of an OCI container.
oci.dns.domain
DNS domain
Key:
oci.dns.domain
Type:
string
Live update:
no
Condition:
OCI container
Domain name for
resolv.conf
.
When set, the domain name received over DHCP is ignored.
oci.dns.nameservers
DNS name servers
Key:
oci.dns.nameservers
Type:
string
Live update:
no
Condition:
OCI container
Comma-separated list of name server addresses for
resolv.conf
.
When set, name servers received over DHCP are ignored.
oci.dns.search
DNS search domains
Key:
oci.dns.search
Type:
string
Live update:
no
Condition:
OCI container
Comma-separated list of search domains for
resolv.conf
.
When set, search domains received over DHCP are ignored.
oci.entrypoint
Entry point
Key:
oci.entrypoint
Type:
string
Live update:
no
Condition:
OCI container
Override the entry point of an OCI container.
oci.gid
Process GID
Key:
oci.gid
Type:
string
Live update:
no
Condition:
OCI container
Override the GID of the process run in an OCI container.
oci.uid
Process UID
Key:
oci.uid
Type:
string
Live update:
no
Condition:
OCI container
Override the UID of the process run in an OCI container.
Raw instance configuration overrides
¶
The following instance options allow direct interaction with the backend features that Incus itself uses:
raw.apparmor
AppArmor profile entries
Key:
raw.apparmor
Type:
blob
Live update:
yes
The specified entries are appended to the generated profile.
raw.idmap
Raw idmap configuration
Key:
raw.idmap
Type:
blob
Live update:
no
Condition:
unprivileged container
For example:
both
1000
1000
raw.lxc
Raw LXC configuration to be appended to the generated one
Key:
raw.lxc
Type:
blob
Live update:
no
Condition:
container
raw.qemu
Raw QEMU configuration to be appended to the generated command line
Key:
raw.qemu
Type:
blob
Live update:
no
Condition:
virtual machine
raw.qemu.conf
Addition/override to the generated
qemu.conf
file
Key:
raw.qemu.conf
Type:
blob
Live update:
no
Condition:
virtual machine
See
Override QEMU configuration
for more information.
raw.qemu.qmp.early
QMP commands to run before Incus QEMU initialization
Key:
raw.qemu.qmp.early
Type:
blob
Live update:
no
Condition:
virtual machine
raw.qemu.qmp.post-start
QMP commands to run after the VM has started
Key:
raw.qemu.qmp.post-start
Type:
blob
Live update:
no
Condition:
virtual machine
raw.qemu.qmp.pre-start
QMP commands to run after Incus QEMU initialization and before the VM has started
Key:
raw.qemu.qmp.pre-start
Type:
blob
Live update:
no
Condition:
virtual machine
raw.qemu.scriptlet
QEMU scriptlet to run at early, pre-start and post-start stages
Key:
raw.qemu.scriptlet
Type:
string
Live update:
no
Condition:
virtual machine
raw.seccomp
Raw Seccomp configuration
Key:
raw.seccomp
Type:
blob
Live update:
no
Condition:
container
Important
Setting these
raw.*
keys might break Incus in non-obvious ways.
Therefore, you should avoid setting any of these keys.
Override QEMU configuration
¶
For VM instances, Incus configures QEMU through a configuration file that is passed to QEMU with the
-readconfig
command-line option.
This configuration file is generated for each instance before boot.
It can be found at
/run/incus/<instance_name>/qemu.conf
.
The default configuration works fine for Incus’ most common use case: modern UEFI guests with VirtIO devices.
In some situations, however, you might need to override the generated configuration.
For example:
To run an old guest OS that doesn’t support UEFI.
To specify custom virtual devices when VirtIO is not supported by the guest OS.
To add devices that are not supported by Incus before the machines boots.
To remove devices that conflict with the guest OS.
To override the configuration, set the
raw.qemu.conf
option.
It supports a format similar to
qemu.conf
, with some additions.
Since it is a multi-line configuration option, you can use it to modify multiple sections or keys.
To replace a section or key in the generated configuration file, add a section with a different value.
For example, use the following section to override the default
virtio-gpu-pci
GPU driver:
```
raw.qemu.conf: |-
    [device "qemu_gpu"]
    driver = "qxl-vga"

```
To remove a section, specify a section without any keys.
For example:
```
raw.qemu.conf: |-
    [device "qemu_gpu"]

```
To remove a key, specify an empty string as the value.
For example:
```
raw.qemu.conf: |-
    [device "qemu_gpu"]
    driver = ""

```
To add a new section, specify a section name that is not present in the configuration file.
The configuration file format used by QEMU allows multiple sections with the same name.
Here’s a piece of the configuration generated by Incus:
```
[global]
driver = "ICH9-LPC"
property = "disable_s3"
value = "1"

[global]
driver = "ICH9-LPC"
property = "disable_s4"
value = "0"

```
The first
global
section disabled S3(Suspend to RAM), the second
global
section enabled S4(suspend to disk). In order to disable S4, the second
global
section index needs to be specified:
```
raw.qemu.conf: |-
    [global][1]
    value = "1"

```
Section indexes start at 0 (which is the default value when not specified), so the above example would generate the following configuration:
```
[global]
driver = "ICH9-LPC"
property = "disable_s3"
value = "1"

[global]
driver = "ICH9-LPC"
property = "disable_s4"
value = "1"

```
Override QEMU runtime objects
¶
While
raw.qemu
and
raw.qemu.conf
can be used to alter the arguments
and configuration file that’s passed to QEMU, a lot of devices are now
added through QMP instead.
This is used by Incus for any device which may need to be re-configured
at runtime, effectively anything that can be hot-plugged.
Those devices cannot be overridden through the configuration or the
command line, but instead additional configuration keys are available to
run QMP commands directly.
Fixed commands can be provided through the
raw.qemu.early
,
raw.qemu.pre-start
and
raw.qemu.post-start
configuration keys.
Those take a JSON encoded list of QMP commands to run.
The hooks correspond to:
early
, run prior to any device having been added by Incus through QMP, after QEMU has started
pre-start
, run following Incus having added all its devices but prior to the VM being started
post-start
, run immediately following the VM starting up
Advanced use
¶
For anyone needing dynamic QMP interactions, for example to retrieve the
current value of some objects before modifying or generating new
objects, it’s also possible to attach to those same hooks using a
scriptlet.
This is done through
raw.qemu.scriptlet
. The scriptlet must define the
qemu_hook(instance,
stage)
function. The
instance
arguments is an object representing the VM, whose attributes are those of the
api.Instance
struct. The
stage
argument is the name of the hook (
config
,
early
,
pre-start
or
post-start
), with
config
being run before starting QEMU, and the other hooks defined above.
The following commands are exposed to that scriptlet:
log_info
will log an
INFO
message
log_warn
will log a
WARNING
message
log_error
will log an
ERROR
message
run_qmp
will run an arbitrary QMP command (JSON) and return its output
run_command
will run the specified command with an optional list of arguments and return its output
get_qemu_cmdline
will return the list of command-line arguments passed to QEMU
set_qemu_cmdline
will set them
get_qemu_conf
will return the QEMU configuration file as a dictionary
set_qemu_conf
will set it from a dictionary
Additionally the following alias commands (internally use
run_command
) are also available to simplify scripts:
blockdev_add
blockdev_del
chardev_add
chardev_change
chardev_remove
device_add
device_del
netdev_add
netdev_del
object_add
object_del
qom_get
qom_list
qom_set
The functions allowing to change QEMU configuration can only be run during the
config
hook. In parallel, the functions running QMP commands cannot be run during the
config
hook.
Security policies
¶
The following instance options control the
Security
policies of the instance:
security.agent.metrics
Whether the
incus-agent
is queried for state information and metrics
Key:
security.agent.metrics
Type:
bool
Default:
true
Live update:
no
Condition:
virtual machine
security.bpffs.delegate_attachs
What BPF attach types to delegate
Key:
security.bpffs.delegate_attachs
Type:
string
Live update:
no
Condition:
unprivileged container
See
BPF token delegation
for more information.
security.bpffs.delegate_cmds
What BPF command types to delegate
Key:
security.bpffs.delegate_cmds
Type:
string
Live update:
no
Condition:
unprivileged container
See
BPF token delegation
for more information.
security.bpffs.delegate_maps
What BPF map types to delegate
Key:
security.bpffs.delegate_maps
Type:
string
Live update:
no
Condition:
unprivileged container
See
BPF token delegation
for more information.
security.bpffs.delegate_progs
What BPF program types to delegate
Key:
security.bpffs.delegate_progs
Type:
string
Live update:
no
Condition:
unprivileged container
See
BPF token delegation
for more information.
security.bpffs.path
The path to mount the BPF file system at
Key:
security.bpffs.path
Type:
string
Default:
/sys/fs/bpf
Live update:
no
Condition:
unprivileged container
The specified path must exist in the container.
The BPF file system is only mounted if any of the
security.bpffs.delegate_*
options are set.
See
BPF token delegation
for more information.
security.csm
Whether to use a firmware that supports UEFI-incompatible operating systems
Key:
security.csm
Type:
bool
Default:
false
Live update:
no
Condition:
virtual machine
When enabling this option, set
security.secureboot
to
false
.
security.guestapi
Whether
/dev/incus
is present in the instance
Key:
security.guestapi
Type:
bool
Default:
true
Live update:
no
See
Communication between instance and host
for more information.
security.guestapi.images
Controls the availability of the
/1.0/images
API over
guestapi
Key:
security.guestapi.images
Type:
bool
Default:
false
Live update:
no
Condition:
container
security.idmap.base
The base host ID to use for the allocation
Key:
security.idmap.base
Type:
integer
Live update:
no
Condition:
unprivileged container
Setting this option overrides auto-detection.
security.idmap.isolated
Whether to use a unique idmap for this instance
Key:
security.idmap.isolated
Type:
bool
Default:
false
Live update:
no
Condition:
unprivileged container
If specified, the idmap used for this instance is unique among instances that have this option set.
security.idmap.size
The size of the idmap to use
Key:
security.idmap.size
Type:
integer
Live update:
no
Condition:
unprivileged container
security.iommu
Whether to enable virtual IOMMU, useful for device passthrough and nesting
Key:
security.iommu
Type:
bool
Default:
false
Live update:
no
Condition:
virtual machine
security.nesting
Whether to allow nesting inside of the instance
Key:
security.nesting
Type:
bool
Default:
false
(containers),
true
(VMs)
Live update:
yes (containers only)
For containers, this controls whether Incus (nested) can be run inside of the instance.
For virtual machines, setting this to
false
disables nested virtualization (turns off the
svm
and
vmx
CPU flags).
security.privileged
Whether to run the instance in privileged mode
Key:
security.privileged
Type:
bool
Default:
false
Live update:
no
Condition:
container
security.protection.delete
Prevents the instance from being deleted
Key:
security.protection.delete
Type:
bool
Default:
false
Live update:
yes
security.protection.shift
Whether to protect the file system from being UID/GID shifted
Key:
security.protection.shift
Type:
bool
Default:
false
Live update:
yes
Condition:
container
Set this option to
true
to prevent the instance’s file system from being UID/GID shifted on startup.
security.protection.start
Prevents the instance from being started
Key:
security.protection.start
Type:
bool
Default:
false
Live update:
yes
security.secureboot
Whether UEFI secure boot is enforced with the default Microsoft keys
Key:
security.secureboot
Type:
bool
Default:
true
Live update:
no
Condition:
virtual machine
When disabling this option, consider enabling
security.csm
.
security.selinux.domain
SELinux process domain override
Key:
security.selinux.domain
Type:
string
Default:
auto-detected (
container_init_t
for containers,
qemu_t
for VMs)
Live update:
no
Condition:
container or virtual machine
Override the SELinux process domain for the instance.
security.selinux.label_rootfs
SELinux rootfs labeling mode (auto, always, never)
Key:
security.selinux.label_rootfs
Type:
string
Default:
auto
Live update:
no
Condition:
container
Control SELinux rootfs labeling behavior.
The default (
auto
) will label rootfs files if it is required. Labeling will be skipped
only if
security.selinux.level
is explicitly set for the instance, it is not started for
the first time and the persisted SELinux context is still valid.
Setting to
always
will label rootfs files on every start and
never
will never touch any
file labels in the rootfs.
security.selinux.level
SELinux MCS level override
Key:
security.selinux.level
Type:
string
Default:
auto-generated
Live update:
no
Condition:
container or virtual machine
Override the SELinux MCS level for the instance.
This key must only be set on individual instances, never on profiles,
since using the same MCS level across instances breaks isolation.
Values set via profiles are ignored.
security.selinux.type
SELinux file type override
Key:
security.selinux.type
Type:
string
Default:
auto-detected (
container_file_t
for containers,
qemu_image_t
for VMs)
Live update:
no
Condition:
container or virtual machine
Override the SELinux file type used for labeling instance storage.
security.sev
Whether AMD SEV (Secure Encrypted Virtualization) is enabled for this VM
Key:
security.sev
Type:
bool
Default:
false
Live update:
no
Condition:
virtual machine
security.sev.policy.es
Whether AMD SEV-ES (SEV Encrypted State) is enabled for this VM
Key:
security.sev.policy.es
Type:
bool
Default:
false
Live update:
no
Condition:
virtual machine
security.sev.session.data
The guest owner’s
base64
-encoded session blob
Key:
security.sev.session.data
Type:
string
Default:
true
Live update:
no
Condition:
virtual machine
security.sev.session.dh
The guest owner’s
base64
-encoded Diffie-Hellman key
Key:
security.sev.session.dh
Type:
string
Default:
true
Live update:
no
Condition:
virtual machine
security.syscalls.allow
List of syscalls to allow
Key:
security.syscalls.allow
Type:
string
Live update:
no
Condition:
container
A
\n
-separated list of syscalls to allow.
This list must be mutually exclusive with
security.syscalls.deny*
.
security.syscalls.deny
List of syscalls to deny
Key:
security.syscalls.deny
Type:
string
Live update:
no
Condition:
container
A
\n
-separated list of syscalls to deny.
This list must be mutually exclusive with
security.syscalls.allow
.
security.syscalls.deny_compat
Whether to block
compat_*
syscalls (
x86_64
only)
Key:
security.syscalls.deny_compat
Type:
bool
Default:
false
Live update:
no
Condition:
container
On
x86_64
, this option controls whether to block
compat_*
syscalls.
On other architectures, the option is ignored.
security.syscalls.deny_default
Whether to enable the default syscall deny
Key:
security.syscalls.deny_default
Type:
bool
Default:
true
Live update:
no
Condition:
container
security.syscalls.intercept.bpf
Whether to handle the
bpf()
system call
Key:
security.syscalls.intercept.bpf
Type:
bool
Default:
false
Live update:
no
Condition:
container
security.syscalls.intercept.bpf.devices
Whether to allow BPF programs
Key:
security.syscalls.intercept.bpf.devices
Type:
bool
Default:
false
Live update:
no
Condition:
container
This option controls whether to allow BPF programs for the devices cgroup in the unified hierarchy to be loaded.
security.syscalls.intercept.mknod
Whether to handle the
mknod
and
mknodat
system calls
Key:
security.syscalls.intercept.mknod
Type:
bool
Default:
false
Live update:
no
Condition:
container
These system calls allow creation of a limited subset of char/block devices.
security.syscalls.intercept.mount
Whether to handle the
mount
system call
Key:
security.syscalls.intercept.mount
Type:
bool
Default:
false
Live update:
no
Condition:
container
security.syscalls.intercept.mount.allowed
File systems that can be mounted
Key:
security.syscalls.intercept.mount.allowed
Type:
string
Live update:
yes
Condition:
container
Specify a comma-separated list of file systems that are safe to mount for processes inside the instance.
security.syscalls.intercept.mount.fuse
File system that should be redirected to FUSE implementation
Key:
security.syscalls.intercept.mount.fuse
Type:
string
Live update:
yes
Condition:
container
Specify the mounts of a given file system that should be redirected to their FUSE implementation (for example,
ext4=fuse2fs
).
security.syscalls.intercept.mount.shift
Whether to use idmapped mounts for syscall interception
Key:
security.syscalls.intercept.mount.shift
Type:
bool
Default:
false
Live update:
yes
Condition:
container
security.syscalls.intercept.sched_setscheduler
Whether to handle the
sched_setscheduler
system call
Key:
security.syscalls.intercept.sched_setscheduler
Type:
bool
Default:
false
Live update:
no
Condition:
container
This system call allows increasing process priority.
security.syscalls.intercept.setxattr
Whether to handle the
setxattr
system call
Key:
security.syscalls.intercept.setxattr
Type:
bool
Default:
false
Live update:
no
Condition:
container
This system call allows setting a limited subset of restricted extended attributes.
security.syscalls.intercept.sysinfo
Whether to handle the
sysinfo
system call
Key:
security.syscalls.intercept.sysinfo
Type:
bool
Default:
false
Live update:
no
Condition:
container
This system call can be used to get cgroup-based resource usage information.
Snapshot scheduling and configuration
¶
The following instance options control the creation and expiry of
instance snapshots
:
snapshots.expiry
When newly created snapshots are to be deleted
Key:
snapshots.expiry
Type:
string
Live update:
no
Specify an expression like
1M
2H
3d
4w
5m
6y
.
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
snapshots.expiry.manual
When newly created snapshots are to be deleted (for those not created through scheduling)
Key:
snapshots.expiry.manual
Type:
string
Live update:
no
Specify an expression like
1M
2H
3d
4w
5m
6y
.
This value is used to compute the expiry date of newly created snapshots that are not created through scheduling.
It is added to the current time when a snapshot is taken, and the resulting timestamp is stored as that snapshot’s individual expiry date.
Changing this value only affects snapshots created after the change; the expiry date of existing snapshots is not modified.
See
snapshots.expiry
for the supported units.
snapshots.pattern
Template for the snapshot name
Key:
snapshots.pattern
Type:
string
Default:
snap%d
Live update:
no
Specify a Pongo2 template string that represents the snapshot name.
This template is used for scheduled snapshots and for unnamed snapshots.
See
Automatic snapshot names
for more information.
snapshots.schedule
Schedule for automatic instance snapshots
Key:
snapshots.schedule
Type:
string
Default:
empty
Live update:
no
Specify either a cron expression (
<minute>
<hour>
<dom>
<month>
<dow>
), a comma-and-space-separated list of schedule aliases (
@startup
,
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
), or leave empty to disable automatic snapshots.
Note that unlike most other configuration keys, this one must be comma-and-space-separated and not just comma-separated as cron expression can themselves contain commas.
snapshots.schedule.stopped
Whether to automatically snapshot stopped instances
Key:
snapshots.schedule.stopped
Type:
bool
Default:
false
Live update:
no
Automatic snapshot names
¶
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
Volatile internal data
¶
The following volatile keys are currently used internally by Incus to store internal data specific to an instance:
volatile.<name>.apply_quota
Disk quota
Key:
volatile.<name>.apply_quota
Type:
string
The disk quota is applied the next time the instance starts.
volatile.<name>.ceph_rbd
RBD device path for Ceph disk devices
Key:
volatile.<name>.ceph_rbd
Type:
string
volatile.<name>.host_name
Network device name on the host
Key:
volatile.<name>.host_name
Type:
string
volatile.<name>.hwaddr
Network device MAC address
Key:
volatile.<name>.hwaddr
Type:
string
The network device MAC address is used when no
hwaddr
property is set on the device itself.
volatile.<name>.io.bus
IO bus in use
Key:
volatile.<name>.io.bus
Type:
string
The IO bus stores the actual IO bus being used, checked in case
io.bus=auto
.
volatile.<name>.last_state.created
Whether the network device physical device was created
Key:
volatile.<name>.last_state.created
Type:
string
Possible values are
true
or
false
.
volatile.<name>.last_state.hwaddr
Network device original MAC
Key:
volatile.<name>.last_state.hwaddr
Type:
string
The original MAC that was used when moving a physical device into an instance.
volatile.<name>.last_state.ip_addresses
Last used IP addresses
Key:
volatile.<name>.last_state.ip_addresses
Type:
string
Comma-separated list of the last used IP addresses of the network device.
volatile.<name>.last_state.mtu
Network device original MTU
Key:
volatile.<name>.last_state.mtu
Type:
string
The original MTU that was used when moving a physical device into an instance.
volatile.<name>.last_state.pci.driver
PCI original host driver
Key:
volatile.<name>.last_state.pci.driver
Type:
string
The original host driver for the PCI device.
volatile.<name>.last_state.pci.parent
PCI parent host device
Key:
volatile.<name>.last_state.pci.parent
Type:
string
The parent host device used when allocating a PCI device to an instance.
volatile.<name>.last_state.pci.slot.name
PCI parent slot name
Key:
volatile.<name>.last_state.pci.slot.name
Type:
string
The parent host device PCI slot name.
volatile.<name>.last_state.usb.bus
USB bus address
Key:
volatile.<name>.last_state.usb.bus
Type:
string
The original USB bus address.
volatile.<name>.last_state.usb.device
USB device identifier
Key:
volatile.<name>.last_state.usb.device
Type:
string
The original USB device identifier.
volatile.<name>.last_state.vdpa.name
VDPA device name
Key:
volatile.<name>.last_state.vdpa.name
Type:
string
The VDPA device name used when moving a VDPA device file descriptor into an instance.
volatile.<name>.last_state.vf.hwaddr
SR-IOV virtual function original MAC
Key:
volatile.<name>.last_state.vf.hwaddr
Type:
string
The original MAC used when moving a VF into an instance.
volatile.<name>.last_state.vf.id
SR-IOV virtual function ID
Key:
volatile.<name>.last_state.vf.id
Type:
string
The ID used when moving a VF into an instance.
volatile.<name>.last_state.vf.parent
SR-IOV parent host device
Key:
volatile.<name>.last_state.vf.parent
Type:
string
The parent host device used when allocating a VF into an instance.
volatile.<name>.last_state.vf.spoofcheck
SR-IOV virtual function original spoof check setting
Key:
volatile.<name>.last_state.vf.spoofcheck
Type:
string
The original spoof check setting used when moving a VF into an instance.
volatile.<name>.last_state.vf.trusted
SR-IOV virtual function original trusted setting
Key:
volatile.<name>.last_state.vf.trusted
Type:
string
The original trusted setting used when moving a VF into an instance.
volatile.<name>.last_state.vf.vlan
SR-IOV virtual function original VLAN
Key:
volatile.<name>.last_state.vf.vlan
Type:
string
The original VLAN used when moving a VF into an instance.
volatile.<name>.mig.uuid
MIG instance UUID
Key:
volatile.<name>.mig.uuid
Type:
string
The NVIDIA MIG instance UUID.
volatile.<name>.name
Network interface name inside of the instance
Key:
volatile.<name>.name
Type:
string
The network interface name inside of the instance when no
name
property is set on the device itself.
volatile.<name>.vgpu.uuid
virtual GPU instance UUID
Key:
volatile.<name>.vgpu.uuid
Type:
string
The NVIDIA virtual GPU instance UUID.
volatile.apply_nvram
Whether to regenerate VM NVRAM the next time the instance starts
Key:
volatile.apply_nvram
Type:
bool
volatile.apply_template
Template hook
Key:
volatile.apply_template
Type:
string
The template with the given name is triggered upon next startup.
volatile.base_image
Hash of the base image
Key:
volatile.base_image
Type:
string
The hash of the image that the instance was created from (empty if the instance was not created from an image).
volatile.cloud_init.instance-id
instance-id
(UUID) exposed to
cloud-init
Key:
volatile.cloud_init.instance-id
Type:
string
volatile.cluster.group
The original cluster group for the instance
Key:
volatile.cluster.group
Type:
string
The cluster group(s) that the instance was restricted to at creation time.
This is used during re-scheduling events like an evacuation to keep the instance within the requested set.
volatile.container.oci
Whether the container is an OCI application container
Key:
volatile.container.oci
Type:
bool
Default:
false
volatile.cpu.nodes
Instance NUMA node
Key:
volatile.cpu.nodes
Type:
string
The NUMA node that was selected for the instance.
volatile.evacuate.origin
The origin of the evacuated instance
Key:
volatile.evacuate.origin
Type:
string
The cluster member that the instance lived on before evacuation.
volatile.idmap.base
The first ID in the instance’s primary idmap range
Key:
volatile.idmap.base
Type:
integer
volatile.idmap.current
The idmap currently in use by the instance
Key:
volatile.idmap.current
Type:
string
volatile.idmap.next
The idmap to use the next time the instance starts
Key:
volatile.idmap.next
Type:
string
volatile.last_state.agent
Instance agent state as of last host shutdown
Key:
volatile.last_state.agent
Type:
string
volatile.last_state.idmap
Serialized instance UID/GID map
Key:
volatile.last_state.idmap
Type:
string
volatile.last_state.power
Instance state as of last host shutdown
Key:
volatile.last_state.power
Type:
string
volatile.last_state.ready
Instance marked itself as ready
Key:
volatile.last_state.ready
Type:
string
volatile.rebalance.last_move
Timestamp of last move by automatic live-migration
Key:
volatile.rebalance.last_move
Type:
integer
volatile.uuid
Instance UUID
Key:
volatile.uuid
Type:
string
The instance UUID is globally unique across all servers and projects.
volatile.uuid.generation
Instance generation UUID
Key:
volatile.uuid.generation
Type:
string
The instance generation UUID changes whenever the instance’s place in time moves backwards.
It is globally unique across all servers and projects.
volatile.vm.boot_state
JSON encoded VM properties used during live migration and other state restoration.
Key:
volatile.vm.boot_state
Type:
string
volatile.vm.needs_reset
Indicates that the VM needs a full reset on next reboot
Key:
volatile.vm.needs_reset
Type:
bool
volatile.vm.rtc_adjustment
Real Time Clock change adjustment
Key:
volatile.vm.rtc_adjustment
Type:
int64
Real Time Clock adjustment time to allow virtual machines to run on a different base than the host.
volatile.vm.rtc_offset
Real Time Clock change offset
Key:
volatile.vm.rtc_offset
Type:
int64
Real Time Clock offset to allow virtual machines to run on a different base than the host.
volatile.vsock_id
Instance
vsock
ID
used as of last start
Key:
volatile.vsock_id
Type:
string
Note
Volatile keys cannot be set by the user.
