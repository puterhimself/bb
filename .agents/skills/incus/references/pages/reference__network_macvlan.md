# Macvlan network

Source: https://linuxcontainers.org/incus/docs/main/reference/network_macvlan/
Fetched: 2026-08-07

Macvlan network
¶
Macvlan is a virtual
LAN
that you can use if you want to assign several IP addresses to the same network interface, basically splitting up the network interface into several sub-interfaces with their own IP addresses.
You can then assign IP addresses based on the randomly generated MAC addresses.
The
macvlan
network type allows to specify presets to use when connecting instances to a parent interface.
In this case, the instance NICs can simply set the
network
option to the network they connect to without knowing any of the underlying configuration details.
Note
If you are using a
macvlan
network, communication between the Incus host and the instances is not possible.
Both the host and the instances can talk to the gateway, but they cannot communicate directly.
Configuration options
¶
The following configuration key namespaces are currently supported for the
macvlan
network type:
user
(free-form key/value for user metadata)
Note
Incus uses the
CIDR notation
where network subnet information is required, for example,
192.0.2.0/24
or
2001:db8::/32
. This does not apply to cases where a single address is required, for example, local/remote addresses of tunnels, NAT addresses or specific addresses to apply to an instance.
The following configuration options are available for the
macvlan
network type:
gvrp
Register VLAN using GARP VLAN Registration Protocol
Key:
gvrp
Type:
bool
Default:
false
Condition:
mtu
The MTU of the new interface
Key:
mtu
Type:
int
Condition:
parent
Parent interface to create macvlan NICs on
Key:
parent
Type:
string
Condition:
Scope:
local
user.*
User-provided free-form key/value pairs
Key:
user.*
Type:
string
vlan
The VLAN ID to attach to
Key:
vlan
Type:
int
Condition:
