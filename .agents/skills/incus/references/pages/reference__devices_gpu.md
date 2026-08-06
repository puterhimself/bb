# Type: gpu

Source: https://linuxcontainers.org/incus/docs/main/reference/devices_gpu/
Fetched: 2026-08-07

Type:
gpu
¶
GPU devices make the specified GPU device or devices appear in the instance.
Note
For containers, a
gpu
device may match multiple GPUs at once.
For VMs, each device can match only a single GPU.
The following types of GPUs can be added using the
gputype
device option:
physical
(container and VM): Passes an entire GPU through into the instance.
This value is the default if
gputype
is unspecified.
mdev
(VM only): Creates and passes a virtual GPU through into the instance.
mig
(container only): Creates and passes a MIG (Multi-Instance GPU) through into the instance.
sriov
(VM only): Passes a virtual function of an SR-IOV-enabled GPU into the instance.
native-context
(VM only): Gives the VM GPU acceleration through
virtio-gpu
DRM native context, without passing the GPU through.
The available device options depend on the GPU type and are listed in the tables in the following sections.
gputype
:
physical
¶
Note
The
physical
GPU type is supported for both containers and VMs.
It supports hotplugging only for containers, not for VMs.
A
physical
GPU device passes an entire GPU through into the instance.
Device options
¶
GPU devices of type
physical
have the following device options:
gid
GID of the device owner in the instance (container only)
Key:
gid
Type:
int
Default:
0
Required:
no
id
The DRM card ID of the GPU device
Key:
id
Type:
string
Required:
no
mode
Mode of the device in the instance (container only)
Key:
mode
Type:
int
Default:
0660
Required:
no
pci
The PCI address of the GPU device
Key:
pci
Type:
string
Required:
no
productid
The product ID of the GPU device
Key:
productid
Type:
string
Required:
no
uid
UID of the device owner in the instance (container only)
Key:
uid
Type:
int
Default:
0
Required:
no
vendorid
The vendor ID of the GPU device
Key:
vendorid
Type:
string
Required:
no
gputype
:
mdev
¶
Note
The
mdev
GPU type is supported only for VMs.
It does not support hotplugging.
An
mdev
GPU device creates and passes a virtual GPU through into the instance.
You can check the list of available
mdev
profiles by running
incus
info
--resources
.
Device options
¶
GPU devices of type
mdev
have the following device options:
id
The DRM card ID of the GPU device
Key:
id
Type:
string
Required:
no
mdev
The mediated device profile to use (required - for example,
i915-GVTg_V5_4
)
Key:
mdev
Type:
string
Required:
yes
productid
The product ID of the GPU device
Key:
productid
Type:
string
Required:
no
vendorid
The vendor ID of the GPU device
Key:
vendorid
Type:
string
Required:
no
gputype
:
mig
¶
Note
The
mig
GPU type is supported only for containers.
It does not support hotplugging.
A
mig
GPU device creates and passes a MIG compute instance through into the instance.
Currently, this requires NVIDIA MIG instances to be pre-created.
Device options
¶
GPU devices of type
mig
have the following device options:
id
The DRM card ID of the GPU device
Key:
id
Type:
string
Required:
no
mig.ci
Existing MIG compute instance ID
Key:
mig.ci
Type:
int
Required:
no
mig.gi
Existing MIG GPU instance ID
Key:
mig.gi
Type:
int
Required:
no
mig.uuid
Existing MIG device UUID (MIG- prefix can be omitted)
Key:
mig.uuid
Type:
string
Required:
no
pci
The PCI address of the GPU device
Key:
pci
Type:
string
Required:
no
productid
The product ID of the GPU device
Key:
productid
Type:
string
Required:
no
vendorid
The vendor ID of the GPU device
Key:
vendorid
Type:
string
Required:
no
You must set either
mig.uuid
(NVIDIA drivers 470+) or both
mig.ci
and
mig.gi
(old NVIDIA drivers).
gputype
:
sriov
¶
Note
The
sriov
GPU type is supported only for VMs.
It does not support hotplugging.
An
sriov
GPU device passes a virtual function of an SR-IOV-enabled GPU into the instance.
Device options
¶
GPU devices of type
sriov
have the following device options:
id
The DRM card ID of the parent GPU device
Key:
id
Type:
string
Required:
no
pci
The PCI address of the parent GPU device
Key:
pci
Type:
string
Required:
no
productid
The product ID of the parent GPU device
Key:
productid
Type:
string
Required:
no
vendorid
The vendor ID of the parent GPU device
Key:
vendorid
Type:
string
Required:
no
gputype
:
native-context
¶
Note
The
native-context
GPU type is supported only for VMs.
It does not support hotplugging.
A
native-context
GPU device gives the VM GPU acceleration through
virtio-gpu
DRM native context.
The host GPU is not passed through or rebound to
vfio-pci
; it stays owned by the host and is shared with the guest, so the host can keep using it at the same time.
This requires QEMU 11.0.0 or newer and
virglrenderer
on the host built with DRM native context support.
DRM native context was introduced in
virglrenderer
1.0.0, but the version needed in practice depends on the GPU and kernel (for example, AMD support became usable around 1.1 and Intel around 1.3).
It also needs a host GPU and guest driver that support DRM native context, and a guest with a matching
virtio-gpu
DRM driver.
The selector options below are optional.
If a GPU is selected, its DRM render node is used as the render node for the QEMU
egl-headless
display.
If no GPU is selected, QEMU uses its default render node.
Device options
¶
GPU devices of type
native-context
have the following device options:
blob.size
Size of the host-visible blob memory window for the
virtio-gpu
device
Key:
blob.size
Type:
string
Default:
2GiB
Required:
no
id
The DRM card ID of the GPU device
Key:
id
Type:
string
Required:
no
pci
The PCI address of the GPU device
Key:
pci
Type:
string
Required:
no
productid
The product ID of the GPU device
Key:
productid
Type:
string
Required:
no
vendorid
The vendor ID of the GPU device
Key:
vendorid
Type:
string
Required:
no
