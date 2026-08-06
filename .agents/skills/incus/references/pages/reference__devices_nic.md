# Type: nic

Source: https://linuxcontainers.org/incus/docs/main/reference/devices_nic/
Fetched: 2026-08-07

Type:
nic
¶
Note
The
nic
device type is supported for both containers and VMs.
NICs support hotplugging for both containers and VMs (with the exception of the
ipvlan
NIC type).
Network devices, also referred to as
Network Interface Controllers
or
NICs
, supply a connection to a network.
Incus supports several different types of network devices (
NIC types
).
Note
When using a USB network adapter with a VM, mainline QEMU will replace the leading two bytes of a MAC address with
40:
.
Those affected by this may want to manually set the
hwaddr
property to a MAC address starting with
40:
to align the host and guest reporting of the MAC.
nictype
vs.
network
¶
When adding a network device to an instance, there are two methods to specify the type of device that you want to add: through the
nictype
device option or the
network
device option.
These two device options are mutually exclusive, and you can specify only one of them when you create a device.
However, note that when you specify the
network
option, the
nictype
option is derived automatically from the network type.
nictype
When using the
nictype
device option, you can specify a network interface that is not controlled by Incus.
Therefore, you must specify all information that Incus needs to use the network interface.
When using this method, the
nictype
option must be specified when creating the device, and it cannot be changed later.
network
When using the
network
device option, the NIC is linked to an existing
managed network
.
In this case, Incus has all required information about the network, and you need to specify only the network name when adding the device.
When using this method, Incus derives the
nictype
option automatically.
The value is read-only and cannot be changed.
Other device options that are inherited from the network are marked with a “yes” in the “Managed” column of the NIC-specific tables of device options.
You cannot customize these options directly for the NIC if you’re using the
network
method.
See
About networking
for more information.
Available NIC types
¶
The following NICs can be added using the
nictype
or
network
options:
bridged
: Uses an existing bridge on the host and creates a virtual device pair to connect the host bridge to the instance.
macvlan
: Sets up a new network device based on an existing one, but using a different MAC address.
sriov
: Passes a virtual function of an SR-IOV-enabled physical network device into the instance.
physical
: Passes a physical device from the host through to the instance.
The targeted device will vanish from the host and appear in the instance.
The following NICs can be added using only the
network
option:
ovn
: Uses an existing OVN network and creates a virtual device pair to connect the instance to it.
The following NICs can be added using only the
nictype
option:
ipvlan
: Sets up a new network device based on an existing one, using the same MAC address but a different IP.
p2p
: Creates a virtual device pair, putting one side in the instance and leaving the other side on the host.
routed
: Creates a virtual device pair to connect the host to the instance and sets up static routes and proxy ARP/NDP entries to allow the instance to join the network of a designated parent interface.
The available device options depend on the NIC type and are listed in the tables in the following sections.
nictype
:
bridged
¶
Note
You can select this NIC type through the
nictype
option or the
network
option (see
Bridge network
for information about the managed
bridge
network).
A
bridged
NIC uses an existing bridge on the host and creates a virtual device pair to connect the host bridge to the instance.
Device options
¶
NIC devices of type
bridged
have the following device options:
attached
Whether the NIC is plugged in or not
Key:
attached
Type:
bool
Default:
true
Required:
no
boot.priority
Boot priority for VMs (higher value boots first)
Key:
boot.priority
Type:
integer
Managed:
no
connected
Whether the NIC is connected to the host network
Key:
connected
Type:
bool
Default:
true
Required:
no
host_name
The name of the interface on the host
Key:
host_name
Type:
string
Default:
randomly assigned
Managed:
no
hwaddr
The MAC address of the new interface
Key:
hwaddr
Type:
string
Default:
randomly assigned
Managed:
no
io.bus
Override the bus for the device (can be
virtio
or
usb
) (VM only)
Key:
io.bus
Type:
string
Default:
virtio
Managed:
no
ipv4.address
An IPv4 address to assign to the instance through DHCP (can be
none
to restrict all IPv4 traffic when
security.ipv4_filtering
is set, or a CIDR value to statically configure the address inside an OCI container)
Key:
ipv4.address
Type:
string
Managed:
no
ipv4.gateway
IPv4 default gateway to statically configure inside an OCI container (
none
to prevent a default gateway from being applied)
Key:
ipv4.gateway
Type:
string
Managed:
no
ipv4.routes
Comma-delimited list of IPv4 static routes to add on host to NIC
Key:
ipv4.routes
Type:
string
Managed:
no
ipv4.routes.external
Comma-delimited list of IPv4 static routes to route to the NIC and publish on uplink network (BGP)
Key:
ipv4.routes.external
Type:
string
Managed:
no
ipv6.address
An IPv6 address to assign to the instance through DHCP (can be
none
to restrict all IPv6 traffic when
security.ipv6_filtering
is set, or a CIDR value to statically configure the address inside an OCI container)
Key:
ipv6.address
Type:
string
Managed:
no
ipv6.gateway
IPv6 default gateway to statically configure inside an OCI container (
none
to prevent a default gateway from being applied)
Key:
ipv6.gateway
Type:
string
Managed:
no
ipv6.routes
Comma-delimited list of IPv6 static routes to add on host to NIC
Key:
ipv6.routes
Type:
string
Managed:
no
ipv6.routes.external
Comma-delimited list of IPv6 static routes to route to the NIC and publish on uplink network (BGP)
Key:
ipv6.routes.external
Type:
string
Managed:
no
limits.egress
I/O limit in bit/s for outgoing traffic (various suffixes supported, see
Units for storage, memory and network limits
)
Key:
limits.egress
Type:
string
Managed:
no
limits.ingress
I/O limit in bit/s for incoming traffic (various suffixes supported, see
Units for storage, memory and network limits
)
Key:
limits.ingress
Type:
string
Managed:
no
limits.max
I/O limit in bit/s for both incoming and outgoing traffic (same as setting both limits.ingress and limits.egress)
Key:
limits.max
Type:
string
Managed:
no
limits.priority
The priority for outgoing traffic, to be used by the kernel queuing discipline to prioritize network packets
Key:
limits.priority
Type:
integer
Managed:
no
mtu
The Maximum Transmit Unit (MTU) of the new interface
Key:
mtu
Type:
integer
Default:
MTU of the parent device
Managed:
yes
name
The name of the interface inside the instance
Key:
name
Type:
string
Default:
kernel assigned
Managed:
no
network
The managed network to link the device to (instead of specifying the
nictype
directly)
Key:
network
Type:
string
Managed:
no
parent
The name of the parent host device (required if specifying the
nictype
directly)
Key:
parent
Type:
string
Managed:
yes
queue.tx.length
The transmit queue length for the NIC
Key:
queue.tx.length
Type:
integer
Managed:
no
security.acls
Comma-separated list of network ACLs to apply
Key:
security.acls
Type:
string
Managed:
no
security.acls.default.egress.action
Action to use for egress traffic that doesn’t match any ACL rule
Key:
security.acls.default.egress.action
Type:
string
Default:
drop
Managed:
no
security.acls.default.egress.logged
Whether to log egress traffic that doesn’t match any ACL rule
Key:
security.acls.default.egress.logged
Type:
bool
Default:
false
Managed:
no
security.acls.default.ingress.action
Action to use for ingress traffic that doesn’t match any ACL rule
Key:
security.acls.default.ingress.action
Type:
string
Default:
drop
Managed:
no
security.acls.default.ingress.logged
Whether to log ingress traffic that doesn’t match any ACL rule
Key:
security.acls.default.ingress.logged
Type:
bool
Default:
false
Managed:
no
security.ipv4_filtering
Prevent the instance from spoofing another instance’s IPv4 address (enables
security.mac_filtering
)
Key:
security.ipv4_filtering
Type:
bool
Default:
false
Managed:
no
security.ipv6_filtering
Prevent the instance from spoofing another instance’s IPv6 address (enables
security.mac_filtering
)
Key:
security.ipv6_filtering
Type:
bool
Default:
false
Managed:
no
security.mac_filtering
Prevent the instance from spoofing another instance’s MAC address
Key:
security.mac_filtering
Type:
bool
Default:
false
Managed:
no
security.port_isolation
Prevent the NIC from communicating with other NICs in the network that have port isolation enabled
Key:
security.port_isolation
Type:
bool
Default:
false
Managed:
no
vlan
The VLAN ID to use for non-tagged traffic (can be none to remove port from default VLAN)
Key:
vlan
Type:
integer
Managed:
no
vlan.tagged
Comma-delimited list of VLAN IDs or VLAN ranges to join for tagged traffic
Key:
vlan.tagged
Type:
integer
Managed:
no
nictype
:
macvlan
¶
Note
You can select this NIC type through the
nictype
option or the
network
option (see
Macvlan network
for information about the managed
macvlan
network).
A
macvlan
NIC sets up a new network device based on an existing one, but using a different MAC address.
If you are using a
macvlan
NIC, communication between the Incus host and the instances is not possible.
Both the host and the instances can talk to the gateway, but they cannot communicate directly.
Device options
¶
NIC devices of type
macvlan
have the following device options:
attached
Whether the NIC is plugged in or not
Key:
attached
Type:
bool
Default:
true
Required:
no
boot.priority
Boot priority for VMs (higher value boots first)
Key:
boot.priority
Type:
integer
Managed:
no
connected
Whether the NIC is connected to the host network (VM only)
Key:
connected
Type:
bool
Default:
true
Required:
no
gvrp
Register VLAN using GARP VLAN Registration Protocol
Key:
gvrp
Type:
bool
Default:
false
Managed:
no
hwaddr
The MAC address of the new interface
Key:
hwaddr
Type:
string
Default:
randomly assigned
Managed:
no
io.bus
Override the bus for the device (can be
virtio
or
usb
) (VM only)
Key:
io.bus
Type:
string
Default:
virtio
Managed:
no
mode
Macvlan mode (one of
bridge
,
vepa
,
passthru
or
private
)
Key:
mode
Type:
string
Default:
bridge
Managed:
no
mtu
The Maximum Transmit Unit (MTU) of the new interface
Key:
mtu
Type:
integer
Default:
MTU of the parent device
Managed:
yes
name
The name of the interface inside the instance
Key:
name
Type:
string
Default:
kernel assigned
Managed:
no
network
The managed network to link the device to (instead of specifying the
nictype
directly)
Key:
network
Type:
string
Managed:
no
parent
The name of the parent host device (required if specifying the
nictype
directly)
Key:
parent
Type:
string
Managed:
yes
vlan
The VLAN ID to attach to
Key:
vlan
Type:
integer
Managed:
no
nictype
:
sriov
¶
Note
You can select this NIC type through the
nictype
option or the
network
option (see
SR-IOV network
for information about the managed
sriov
network).
An
sriov
NIC passes a virtual function of an SR-IOV-enabled physical network device into the instance.
An SR-IOV-enabled network device associates a set of virtual functions (VFs) with the single physical function (PF) of the network device.
PFs are standard PCIe functions.
VFs, on the other hand, are very lightweight PCIe functions that are optimized for data movement.
They come with a limited set of configuration capabilities to prevent changing properties of the PF.
Given that VFs appear as regular PCIe devices to the system, they can be passed to instances just like a regular physical device.
VF allocation
The
sriov
interface type expects to be passed the name of an SR-IOV enabled network device on the system via the
parent
property.
Incus then checks for any available VFs on the system.
By default, Incus allocates the first free VF it finds.
If it detects that either none are enabled or all currently enabled VFs are in use, it bumps the number of supported VFs to the maximum value and uses the first free VF.
If all possible VFs are in use or the kernel or card doesn’t support incrementing the number of VFs, Incus returns an error.
Note
If you need Incus to use a specific VF, use a
physical
NIC instead of a
sriov
NIC and set its
parent
option to the VF name.
Device options
¶
NIC devices of type
sriov
have the following device options:
attached
Whether the NIC is plugged in or not
Key:
attached
Type:
bool
Default:
true
Required:
no
boot.priority
Boot priority for VMs (higher value boots first)
Key:
boot.priority
Type:
integer
Managed:
no
hwaddr
The MAC address of the new interface
Key:
hwaddr
Type:
string
Default:
randomly assigned
Managed:
no
mtu
The Maximum Transmit Unit (MTU) of the new interface
Key:
mtu
Type:
integer
Default:
kernel assigned
Managed:
yes
name
The name of the interface inside the instance
Key:
name
Type:
string
Default:
kernel assigned
Managed:
no
network
The managed network to link the device to (instead of specifying the
nictype
directly)
Key:
network
Type:
string
Managed:
no
parent
The name of the parent host device (required if specifying the
nictype
directly)
Key:
parent
Type:
string
Managed:
yes
pci
The PCI address of the parent host device
Key:
pci
Type:
string
Required:
no
productid
The product ID of the parent host device
Key:
productid
Type:
string
Required:
no
security.mac_filtering
Prevent the instance from spoofing another instance’s MAC address
Key:
security.mac_filtering
Type:
bool
Default:
false
Managed:
no
security.trusted
Allows the instance to configure the NIC in ways that may negatively impact security.
Key:
security.trusted
Type:
bool
Default:
false, if supported by parent device
Managed:
no
vendorid
The vendor ID of the parent host device
Key:
vendorid
Type:
string
Required:
no
vlan
The VLAN ID to attach to
Key:
vlan
Type:
integer
Managed:
no
nictype
:
ovn
¶
Note
You can select this NIC type only through the
network
option (see
OVN network
for information about the managed
ovn
network).
An
ovn
NIC uses an existing OVN network and creates a virtual device pair to connect the instance to it.
SR-IOV hardware acceleration
To use
acceleration=sriov
, you must have a compatible SR-IOV physical NIC that supports the Ethernet switch device driver model (
switchdev
) in your Incus host.
Incus assumes that the physical NIC (PF) is configured in
switchdev
mode and connected to the OVN integration OVS bridge, and that it has one or more virtual functions (VFs) active.
To achieve this, follow these basic prerequisite setup steps:
Set up PF and VF:
Activate some VFs on PF (called
enp9s0f0np0
in the following example, with a PCI address of
0000:09:00.0
) and unbind them.
Enable
switchdev
mode and
hw-tc-offload
on the PF.
Rebind the VFs.
```
echo 4 > /sys/bus/pci/devices/0000:09:00.0/sriov_numvfs
for i in $(lspci -nnn | grep "Virtual Function" | cut -d' ' -f1); do echo 0000:$i > /sys/bus/pci/drivers/mlx5_core/unbind; done
devlink dev eswitch set pci/0000:09:00.0 mode switchdev
ethtool -K enp9s0f0np0 hw-tc-offload on
for i in $(lspci -nnn | grep "Virtual Function" | cut -d' ' -f1); do echo 0000:$i > /sys/bus/pci/drivers/mlx5_core/bind; done

```
Set up OVS by enabling hardware offload and adding the PF NIC to the integration bridge (normally called
br-int
):
```
ovs-vsctl set open_vswitch . other_config:hw-offload=true
systemctl restart openvswitch-switch
ovs-vsctl add-port br-int enp9s0f0np0
ip link set enp9s0f0np0 up

```
VDPA hardware acceleration
To use
acceleration=vdpa
, you must have a compatible VDPA physical NIC.
The setup is the same as for SR-IOV hardware acceleration, except that you must also enable the
vhost_vdpa
module and check that you have some available VDPA management devices :
```
modprobe vhost_vdpa && vdpa mgmtdev show

```
Device options
¶
NIC devices of type
ovn
have the following device options:
acceleration
Enable hardware offloading (either
none
,
sriov
or
vdpa
)
Key:
acceleration
Type:
string
Default:
none
Managed:
no
attached
Whether the NIC is plugged in or not
Key:
attached
Type:
bool
Default:
true
Required:
no
boot.priority
Boot priority for VMs (higher value boots first)
Key:
boot.priority
Type:
integer
Managed:
no
connected
Whether the NIC is connected to the host network (requires
acceleration
set to
none
)
Key:
connected
Type:
bool
Default:
true
Required:
no
host_name
The name of the interface inside the host
Key:
host_name
Type:
string
Default:
randomly assigned
Managed:
no
hwaddr
The MAC address of the new interface
Key:
hwaddr
Type:
string
Default:
randomly assigned
Managed:
no
io.bus
Override the bus for the device (can be
virtio
or
usb
, requires
acceleration
set to
none
) (VM only)
Key:
io.bus
Type:
string
Default:
virtio
Managed:
no
ipv4.address
An IPv4 address to assign to the instance through DHCP,
none
can be used to disable IP allocation (or a CIDR value to statically configure the address inside an OCI container)
Key:
ipv4.address
Type:
string
Managed:
no
ipv4.address.external
Select a specific external address (typically from a network forward)
Key:
ipv4.address.external
Type:
string
Managed:
no
ipv4.gateway
IPv4 default gateway to statically configure inside an OCI container (
none
to prevent a default gateway from being applied)
Key:
ipv4.gateway
Type:
string
Managed:
no
ipv4.routes
Comma-delimited list of IPv4 static routes to route to the NIC
Key:
ipv4.routes
Type:
string
Managed:
no
ipv4.routes.external
Comma-delimited list of IPv4 static routes to route to the NIC and publish on uplink network
Key:
ipv4.routes.external
Type:
string
Managed:
no
ipv6.address
An IPv6 address to assign to the instance through DHCP,
none
can be used to disable IP allocation (or a CIDR value to statically configure the address inside an OCI container)
Key:
ipv6.address
Type:
string
Managed:
no
ipv6.address.external
Select a specific external address (typically from a network forward)
Key:
ipv6.address.external
Type:
string
Managed:
no
ipv6.gateway
IPv6 default gateway to statically configure inside an OCI container (
none
to prevent a default gateway from being applied)
Key:
ipv6.gateway
Type:
string
Managed:
no
ipv6.routes
Comma-delimited list of IPv6 static routes to route to the NIC
Key:
ipv6.routes
Type:
string
Managed:
no
ipv6.routes.external
Comma-delimited list of IPv6 static routes to route to the NIC and publish on uplink network
Key:
ipv6.routes.external
Type:
string
Managed:
no
limits.egress
I/O limit in bit/s for outgoing traffic (various suffixes supported, see
Units for storage, memory and network limits
)
Key:
limits.egress
Type:
string
Managed:
no
limits.ingress
I/O limit in bit/s for incoming traffic (various suffixes supported, see
Units for storage, memory and network limits
)
Key:
limits.ingress
Type:
string
Managed:
no
limits.max
I/O limit in bit/s for both incoming and outgoing traffic. (same as setting both limits.ingress and limits.egress / mutually exclusive with limits.ingress and limits.egress)
Key:
limits.max
Type:
string
Managed:
no
limits.priority
The priority for outgoing traffic, to be used by the kernel queuing discipline to prioritize network packets
Key:
limits.priority
Type:
integer
Default:
100
Managed:
no
mtu
The Maximum Transmit Unit (MTU) of the new interface
Key:
mtu
Type:
integer
Default:
MTU of the parent network
Managed:
yes
name
The name of the interface inside the instance
Key:
name
Type:
string
Default:
kernel assigned
Managed:
no
nested
The parent NIC name to nest this NIC under (see also
vlan
)
Key:
nested
Type:
string
Managed:
no
network
The managed network to link the device to (required)
Key:
network
Type:
string
Managed:
yes
security.acls
Comma-separated list of network ACLs to apply
Key:
security.acls
Type:
string
Managed:
no
security.acls.default.egress.action
Action to use for egress traffic that doesn’t match any ACL rule
Key:
security.acls.default.egress.action
Type:
string
Default:
reject
Managed:
no
security.acls.default.egress.logged
Whether to log egress traffic that doesn’t match any ACL rule
Key:
security.acls.default.egress.logged
Type:
bool
Default:
false
Managed:
no
security.acls.default.ingress.action
Action to use for ingress traffic that doesn’t match any ACL rule
Key:
security.acls.default.ingress.action
Type:
string
Default:
reject
Managed:
no
security.acls.default.ingress.logged
Whether to log ingress traffic that doesn’t match any ACL rule
Key:
security.acls.default.ingress.logged
Type:
bool
Default:
false
Managed:
no
security.promiscuous
Have OVN send unknown network traffic to this network interface (required for some nesting cases)
Key:
security.promiscuous
Type:
bool
Default:
false
Managed:
no
vlan
The VLAN ID to use when nesting (see also
nested
)
Key:
vlan
Type:
integer
Managed:
no
Note
Note that using
none
with either
ipv4.address
or
ipv6.address
needs the other protocol to also be disabled.
There is currently no way for OVN to disable IP allocation just on IPv4 or IPv6.
nictype
:
physical
¶
Note
You can select this NIC type through the
nictype
option or the
network
option (see
Physical network
for information about the managed
physical
network).
You can have only one
physical
NIC for each parent device.
A
physical
NIC provides straight physical device pass-through from the host.
The targeted device will vanish from the host and appear in the instance (which means that you can have only one
physical
NIC for each targeted device).
Device options
¶
NIC devices of type
physical
have the following device options:
attached
Whether the NIC is plugged in or not
Key:
attached
Type:
bool
Default:
true
Required:
no
boot.priority
Boot priority for VMs (higher value boots first)
Key:
boot.priority
Type:
integer
Managed:
no
gvrp
Register VLAN using GARP VLAN Registration Protocol
Key:
gvrp
Type:
bool
Default:
false
Condition:
container
Managed:
no
hwaddr
The MAC address of the new interface
Key:
hwaddr
Type:
string
Default:
randomly assigned
Condition:
container
Managed:
no
mtu
The Maximum Transmit Unit (MTU) of the new interface
Key:
mtu
Type:
integer
Default:
MTU of the parent device
Condition:
container
Managed:
no
name
The name of the interface inside the instance
Key:
name
Type:
string
Default:
kernel assigned
Managed:
no
network
The managed network to link the device to (instead of specifying the
nictype
directly)
Key:
network
Type:
string
Managed:
no
parent
The name of the parent host device (required if specifying the
nictype
directly)
Key:
parent
Type:
string
Managed:
yes
vlan
The VLAN ID to attach to
Key:
vlan
Type:
integer
Condition:
container
Managed:
no
vlan.tagged
Comma-delimited list of VLAN IDs or VLAN ranges to join for tagged traffic
Key:
vlan.tagged
Type:
integer
Condition:
container
Managed:
no
nictype
:
ipvlan
¶
Note
This NIC type is available only for containers, not for virtual machines.
You can select this NIC type only through the
nictype
option.
This NIC type does not support hotplugging.
An
ipvlan
NIC sets up a new network device based on an existing one, using the same MAC address but a different IP.
If you are using an
ipvlan
NIC, communication between the Incus host and the instances is not possible.
Both the host and the instances can talk to the gateway, but they cannot communicate directly.
Incus currently supports IPVLAN in L2 and L3S mode.
In this mode, the gateway is automatically set by Incus, but the IP addresses must be manually specified using the
ipv4.address
and/or
ipv6.address
options before the container is started.
DNS
The name servers must be configured inside the container, because they are not set automatically.
To do this, set the following
sysctls
:
When using IPv4 addresses:
```
net.ipv4.conf.<parent>.forwarding=1

```
When using IPv6 addresses:
```
net.ipv6.conf.<parent>.forwarding=1
net.ipv6.conf.<parent>.proxy_ndp=1

```
Device options
¶
NIC devices of type
ipvlan
have the following device options:
attached
Whether the NIC is plugged in or not
Key:
attached
Type:
bool
Default:
true
Required:
no
gvrp
Register VLAN using GARP VLAN Registration Protocol
Key:
gvrp
Type:
bool
Default:
false
hwaddr
The MAC address of the new interface
Key:
hwaddr
Type:
string
Default:
randomly assigned
ipv4.address
Comma-delimited list of IPv4 static addresses to add to the instance (in l2 mode, these can be specified as CIDR values or singular addresses using a subnet of /24)
Key:
ipv4.address
Type:
string
ipv4.gateway
In
l3s
mode, whether to add an automatic default IPv4 gateway (can be
auto
or
none
). In
l2
mode, the IPv4 address of the gateway
Key:
ipv4.gateway
Type:
string
Default:
auto
(in
l3s
mode),
-
(in
l2
mode)
ipv4.host_table
The custom policy routing table ID to add IPv4 static routes to (in addition to the main routing table)
Key:
ipv4.host_table
Type:
integer
ipv6.address
Comma-delimited list of IPv6 static addresses to add to the instance (in
l2
mode, these can be specified as CIDR values or singular addresses using a subnet of /64)
Key:
ipv6.address
Type:
string
ipv6.gateway
In
l3s
mode, whether to add an automatic default IPv6 gateway (can be
auto
or
none
). In
l2
mode, the IPv6 address of the gateway
Key:
ipv6.gateway
Type:
string
Default:
auto
(in
l3s
mode),
-
(in
l2
mode)
ipv6.host_table
The custom policy routing table ID to add IPv6 static routes to (in addition to the main routing table)
Key:
ipv6.host_table
Type:
integer
mode
The IPVLAN mode (either
l2
or
l3s
)
Key:
mode
Type:
string
Default:
l3s
mtu
The Maximum Transmit Unit (MTU) of the new interface
Key:
mtu
Type:
integer
Default:
MTU of the parent device
name
The name of the interface inside the instance
Key:
name
Type:
string
Default:
kernel assigned
parent
The name of the host device (required)
Key:
parent
Type:
string
vlan
The VLAN ID to attach to
Key:
vlan
Type:
integer
nictype
:
p2p
¶
Note
You can select this NIC type only through the
nictype
option.
A
p2p
NIC creates a virtual device pair, putting one side in the instance and leaving the other side on the host.
Device options
¶
NIC devices of type
p2p
have the following device options:
attached
Whether the NIC is plugged in or not
Key:
attached
Type:
bool
Default:
true
Required:
no
boot.priority
Boot priority for VMs (higher value boots first)
Key:
boot.priority
Type:
integer
connected
Whether the NIC is connected to the host network
Key:
connected
Type:
bool
Default:
true
Required:
no
host_name
The name of the interface on the host
Key:
host_name
Type:
string
Default:
randomly assigned
hwaddr
The MAC address of the new interface
Key:
hwaddr
Type:
string
Default:
randomly assigned
io.bus
Override the bus for the device (can be
virtio
or
usb
) (VM only)
Key:
io.bus
Type:
string
Default:
virtio
ipv4.routes
Comma-delimited list of IPv4 static routes to add on host to NIC
Key:
ipv4.routes
Type:
string
ipv6.routes
Comma-delimited list of IPv6 static routes to add on host to NIC
Key:
ipv6.routes
Type:
string
limits.egress
I/O limit in bit/s for outgoing traffic (various suffixes supported, see
Units for storage, memory and network limits
)
Key:
limits.egress
Type:
string
limits.ingress
I/O limit in bit/s for incoming traffic (various suffixes supported, see
Units for storage, memory and network limits
)
Key:
limits.ingress
Type:
string
limits.max
I/O limit in bit/s for both incoming and outgoing traffic (same as setting both limits.ingress and limits.egress)
Key:
limits.max
Type:
string
limits.priority
The priority for outgoing traffic, to be used by the kernel queuing discipline to prioritize network packets
Key:
limits.priority
Type:
integer
mtu
The Maximum Transmit Unit (MTU) of the new interface
Key:
mtu
Type:
integer
Default:
kernel assigned
name
The name of the interface inside the instance
Key:
name
Type:
string
Default:
kernel assigned
queue.tx.length
The transmit queue length for the NIC
Key:
queue.tx.length
Type:
integer
nictype
:
routed
¶
Note
You can select this NIC type only through the
nictype
option.
A
routed
NIC creates a virtual device pair to connect the host to the instance and sets up static routes and proxy ARP/NDP entries to allow the instance to join the network of a designated parent interface.
For containers it uses a virtual Ethernet device pair, and for VMs it uses a TAP device.
This NIC type is similar in operation to
ipvlan
, in that it allows an instance to join an external network without needing to configure a bridge and shares the host’s MAC address.
However, it differs from
ipvlan
because it does not need IPVLAN support in the kernel, and the host and the instance can communicate with each other.
This NIC type respects
netfilter
rules on the host and uses the host’s routing table to route packets, which can be useful if the host is connected to multiple networks.
IP addresses, gateways and routes
You must manually specify the IP addresses (using
ipv4.address
and/or
ipv6.address
) before the instance is started.
For containers, the NIC configures the following link-local gateway IPs on the host end and sets them as the default gateways in the container’s NIC interface:
```
169.254.0.1
fe80::1

```
For VMs, the gateways must be configured manually or via a mechanism like
cloud-init
(see the
how to guide
).
Note
If your container image is configured to perform DHCP on the interface, it will likely remove the automatically added configuration.
In this case, you must configure the IP addresses and gateways manually or via a mechanism like
cloud-init
.
The NIC type configures static routes on the host pointing to the instance’s
veth
interface for all of the instance’s IPs.
Multiple IP addresses
Each NIC device can have multiple IP addresses added to it.
However, it might be preferable to use multiple
routed
NIC interfaces instead.
In this case, set the
ipv4.gateway
and
ipv6.gateway
values to
none
on any subsequent interfaces to avoid default gateway conflicts.
Also consider specifying a different host-side address for these subsequent interfaces using
ipv4.host_address
and/or
ipv6.host_address
.
Parent interface
This NIC can operate with and without a
parent
network interface set.
With the
parent
network interface set, proxy ARP/NDP entries of the instance’s IPs are added to the parent interface, which allows the instance to join the parent interface’s network at layer 2.
To enable this, the following network configuration must be applied on the host via
sysctl
:
When using IPv4 addresses:
```
net.ipv4.conf.<parent>.forwarding=1

```
When using IPv6 addresses:
```
net.ipv6.conf.all.forwarding=1
net.ipv6.conf.<parent>.forwarding=1
net.ipv6.conf.all.proxy_ndp=1
net.ipv6.conf.<parent>.proxy_ndp=1

```
Device options
¶
NIC devices of type
routed
have the following device options:
attached
Whether the NIC is plugged in or not
Key:
attached
Type:
bool
Default:
true
Required:
no
connected
Whether the NIC is connected to the host network
Key:
connected
Type:
bool
Default:
true
Required:
no
gvrp
Register VLAN using GARP VLAN Registration Protocol
Key:
gvrp
Type:
bool
Default:
false
host_name
The name of the interface on the host
Key:
host_name
Type:
string
Default:
randomly assigned
hwaddr
The MAC address of the new interface
Key:
hwaddr
Type:
string
Default:
randomly assigned
io.bus
Override the bus for the device (can be
virtio
or
usb
) (VM only)
Key:
io.bus
Type:
string
Default:
virtio
ipv4.address
Comma-delimited list of IPv4 static addresses to add to the instance
Key:
ipv4.address
Type:
string
ipv4.gateway
Whether to add an automatic default IPv4 gateway (can be
auto
or
none
)
Key:
ipv4.gateway
Type:
string
Default:
auto
ipv4.host_address
The IPv4 address to add to the host-side
veth
interface
Key:
ipv4.host_address
Type:
string
Default:
169.254.0.1
ipv4.host_table
Deprecated: Use
ipv4.host_tables
instead
Key:
ipv4.host_table
Type:
integer
The custom policy routing table ID to add IPv4 static routes to (in addition to the main routing table)
ipv4.host_tables
Comma-delimited list of routing tables IDs to add IPv4 static routes to
Key:
ipv4.host_tables
Type:
string
Default:
254
ipv4.neighbor_probe
Whether to probe the parent network for IP address availability
Key:
ipv4.neighbor_probe
Type:
bool
Default:
true
ipv4.routes
Comma-delimited list of IPv4 static routes to add on host to NIC (without L2 ARP/NDP proxy)
Key:
ipv4.routes
Type:
string
ipv6.address
Comma-delimited list of IPv6 static addresses to add to the instance
Key:
ipv6.address
Type:
string
ipv6.gateway
Whether to add an automatic default IPv6 gateway (can be
auto
or
none
)
Key:
ipv6.gateway
Type:
string
Default:
auto
ipv6.host_address
The IPv6 address to add to the host-side
veth
interface
Key:
ipv6.host_address
Type:
string
Default:
fe80::1
ipv6.host_table
Deprecated: Use
ipv6.host_tables
instead
Key:
ipv6.host_table
Type:
integer
The custom policy routing table ID to add IPv6 static routes to (in addition to the main routing table)
ipv6.host_tables
Comma-delimited list of routing tables IDs to add IPv6 static routes to
Key:
ipv6.host_tables
Type:
string
Default:
254
ipv6.neighbor_probe
Whether to probe the parent network for IP address availability
Key:
ipv6.neighbor_probe
Type:
bool
Default:
true
ipv6.routes
Comma-delimited list of IPv6 static routes to add on host to NIC (without L2 ARP/NDP proxy)
Key:
ipv6.routes
Type:
string
limits.egress
I/O limit in bit/s for outgoing traffic (various suffixes supported, see
Units for storage, memory and network limits
)
Key:
limits.egress
Type:
string
limits.ingress
I/O limit in bit/s for incoming traffic (various suffixes supported, see
Units for storage, memory and network limits
)
Key:
limits.ingress
Type:
string
limits.max
I/O limit in bit/s for both incoming and outgoing traffic (same as setting both limits.ingress and limits.egress)
Key:
limits.max
Type:
string
limits.priority
The priority for outgoing traffic, to be used by the kernel queuing discipline to prioritize network packets
Key:
limits.priority
Type:
integer
mtu
The Maximum Transmit Unit (MTU) of the new interface
Key:
mtu
Type:
integer
Default:
parent MTU
name
The name of the interface inside the instance
Key:
name
Type:
string
Default:
kernel assigned
parent
The name of the parent host device to join the instance to
Key:
parent
Type:
string
queue.tx.length
The transmit queue length for the NIC
Key:
queue.tx.length
Type:
integer
vlan
The VLAN ID to attach to
Key:
vlan
Type:
integer
vrf
The VRF on the host in which the host-side interface and routes are created
Key:
vrf
Type:
string
bridged
,
macvlan
or
ipvlan
for connection to physical network
¶
The
bridged
,
macvlan
and
ipvlan
interface types can be used to connect to an existing physical network.
macvlan
effectively lets you fork your physical NIC, getting a second interface that is then used by the instance.
This method saves you from creating a bridge device and virtual Ethernet device pairs and usually offers better performance than a bridge.
The downside to this method is that
macvlan
devices, while able to communicate between themselves and to the outside, cannot talk to their parent device.
This means that you can’t use
macvlan
if you ever need your instances to talk to the host itself.
In such case, a
bridge
device is preferable.
A bridge also lets you use MAC filtering and I/O limits, which cannot be applied to a
macvlan
device.
ipvlan
is similar to
macvlan
, with the difference being that the forked device has IPs statically assigned to it and inherits the parent’s MAC address on the network.
