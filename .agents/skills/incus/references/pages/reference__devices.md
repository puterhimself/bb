# Devices

Source: https://linuxcontainers.org/incus/docs/main/reference/devices/
Fetched: 2026-08-07

Devices
¶
Devices are attached to an instance (see
Configure devices
) or to a profile (see
Edit a profile
).
They include, for example, network interfaces, mount points, USB and GPU devices.
These devices can have instance device options, depending on the type of the instance device.
Incus supports the following device types:
ID (database)
Name
Condition
Description
0
none
-
Inheritance blocker
1
nic
-
Network interface
2
disk
-
Mount point inside the instance
3
unix-char
container
Unix character device
4
unix-block
container
Unix block device
5
usb
-
USB device
6
gpu
-
GPU device
7
infiniband
container
InfiniBand device
8
proxy
container
Proxy device
9
unix-hotplug
container
Unix hotplug device
10
tpm
-
TPM device
11
pci
VM
PCI device
Each instance comes with a set of
Standard devices
.
