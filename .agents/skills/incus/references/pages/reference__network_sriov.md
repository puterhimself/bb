# SR-IOV network

Source: https://linuxcontainers.org/incus/docs/main/reference/network_sriov/
Fetched: 2026-08-07

SR-IOV network
¶
SR-IOV
is a hardware standard that allows a single network card port to appear as several virtual network interfaces in a virtualized environment.
The
sriov
network type allows to specify presets to use when connecting instances to a parent interface.
In this case, the instance NICs can simply set the
network
option to the network they connect to without knowing any of the underlying configuration details.
Configuration options
¶
The following configuration key namespaces are currently supported for the
sriov
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
sriov
network type:
mtu
The MTU of the new interface
Key:
mtu
Type:
integer
Condition:
parent
Parent interface to create
sriov
NICs on
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
Condition:
vlan
The VLAN ID to attach to
Key:
vlan
Type:
integer
Condition:
