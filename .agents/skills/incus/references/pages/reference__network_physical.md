# Physical network

Source: https://linuxcontainers.org/incus/docs/main/reference/network_physical/
Fetched: 2026-08-07

Physical network
¶
The
physical
network type connects to an existing physical network, which can be a network interface or a bridge, and serves as an uplink network for OVN.
This network type allows to specify presets to use when connecting OVN networks to a parent interface or to allow an instance to use a physical interface as a NIC.
In this case, the instance NICs can simply set the
network
option to the network they connect to without knowing any of the underlying configuration details.
Configuration options
¶
The following configuration key namespaces are currently supported for the
physical
network type:
bgp
(BGP peer configuration)
dns
(DNS server and resolution configuration)
ipv4
(L3 IPv4 configuration)
ipv6
(L3 IPv6 configuration)
ovn
(OVN configuration)
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
physical
network type:
BGP options
¶
These options configure BGP peering for OVN downstream networks:
bgp.peers.NAME.address
Peer address (IPv4 or IPv6) for use by
ovn
downstream networks
Key:
bgp.peers.NAME.address
Type:
string
Default:
Condition:
BGP server
bgp.peers.NAME.asn
Peer AS number for use by
ovn
downstream networks
Key:
bgp.peers.NAME.asn
Type:
integer
Default:
Condition:
BGP server
bgp.peers.NAME.holdtime
Peer session hold time (in seconds; optional)
Key:
bgp.peers.NAME.holdtime
Type:
integer
Default:
180
Condition:
BGP server
bgp.peers.NAME.interface
Interface name for BGP unnumbered peering (alternative to the peer address)
Key:
bgp.peers.NAME.interface
Type:
string
Default:
Condition:
BGP server
bgp.peers.NAME.password
Peer session password (optional) for use by
ovn
downstream networks
Key:
bgp.peers.NAME.password
Type:
string
Default:
(no password)
Condition:
BGP server
DNS options
¶
These keys control the DNS servers and search domains used by the physical network:
dns.nameservers
List of DNS server IPs on
physical
network
Key:
dns.nameservers
Type:
string
Condition:
standard mode
IPV4 options
¶
These options define the IPv4 configuration for the physical network:
ipv4.gateway
IPv4 address for the gateway and network (CIDR)
Key:
ipv4.gateway
Type:
string
Condition:
standard mode
ipv4.gateway.hwaddr
MAC address of the gateway (to avoid discovery)
Key:
ipv4.gateway.hwaddr
Type:
string
ipv4.ovn.ranges
Comma-separated list of IPv4 ranges to use for child OVN network routers (FIRST-LAST format)
Key:
ipv4.ovn.ranges
Type:
string
Condition:
ipv4.routes
Comma-separated list of additional IPv4 CIDR subnets that can be used with child OVN networks
ipv4.routes.external
setting
Key:
ipv4.routes
Type:
string
Condition:
IPv4 address
ipv4.routes.anycast
Allow the overlapping routes to be used on multiple networks/NIC at the same time
Key:
ipv4.routes.anycast
Type:
bool
Default:
‘false’
Condition:
IPv4 address
IPV6 options
¶
These options define the IPv6 configuration for the physical network:
ipv6.gateway
IPv6 address for the gateway and network (CIDR)
Key:
ipv6.gateway
Type:
string
Condition:
standard mode
ipv6.gateway.hwaddr
MAC address of the gateway (to avoid discovery)
Key:
ipv6.gateway.hwaddr
Type:
string
ipv6.ovn.ranges
Comma-separated list of IPv6 ranges to use for child OVN network routers (FIRST-LAST format)
Key:
ipv6.ovn.ranges
Type:
string
Condition:
ipv6.routes
Comma-separated list of additional IPv6 CIDR subnets that can be used with child OVN networks
ipv6.routes.external
setting
Key:
ipv6.routes
Type:
string
Condition:
IPv6 address
ipv6.routes.anycast
Allow the overlapping routes to be used on multiple networks/NIC at the same time
Key:
ipv6.routes.anycast
Type:
bool
Default:
‘false’
Condition:
IPv6 address
OVN options
¶
These options apply when using a physical network as an OVN uplink:
ovn.ingress_mode
Sets the method how OVN NIC external IPs will be advertised on uplink network:
l2proxy
(proxy ARP/NDP) or
routed
Key:
ovn.ingress_mode
Type:
string
Default:
l2proxy
Condition:
standard mode
Common options
¶
These apply to all physical networks regardless of other features:
gvrp
Register VLAN using GARP VLAN Registration Protocol
Key:
gvrp
Type:
bool
Default:
‘false’
Condition:
mtu
The MTU of the new interface
Key:
mtu
Type:
integer
Condition:
parent
Existing interface to use for network
Key:
parent
Type:
string
Condition:
Scope:
local
vlan
The VLAN ID to attach to
Key:
vlan
Type:
integer
Condition:
vlan.tagged
Comma-delimited list of VLAN IDs or VLAN ranges to join for tagged traffic
Key:
vlan.tagged
Type:
integer
Condition:
Parent must be an existing bridge
Supported features
¶
The following features are supported for the
physical
network type:
How to configure Incus as a BGP server
