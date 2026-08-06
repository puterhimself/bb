# How to configure a network

Source: https://linuxcontainers.org/incus/docs/main/howto/network_configure/
Fetched: 2026-08-07

How to configure a network
¶
To configure an existing network, use either the
incus
network
set
and
incus
network
unset
commands (to configure single settings) or the
incus
network
edit
command (to edit the full configuration).
To configure settings for specific cluster members, add the
--target
flag.
For example, the following command configures a DNS server for a physical network:
```
incus network set UPLINK dns.nameservers=8.8.8.8

```
The available configuration options differ depending on the network type.
See
Network types
for links to the configuration options for each network type.
There are separate commands to configure advanced networking features.
See the following documentation:
How to configure network ACLs
How to configure network forwards
How to configure network integrations
How to configure network load balancers
How to configure network zones
How to create peer routing relationships
(OVN only)
