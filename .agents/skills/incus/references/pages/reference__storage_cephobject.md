# Ceph Object - cephobject

Source: https://linuxcontainers.org/incus/docs/main/reference/storage_cephobject/
Fetched: 2026-08-07

Ceph Object -
cephobject
¶
Ceph
is an open-source storage platform that stores its data in a storage cluster based on
RADOS
.
It is highly scalable and, as a distributed system without a single point of failure, very reliable.
Ceph provides different components for block storage and for file systems.
Ceph Object Gateway
is an object storage interface built on top of
librados
to provide applications with a RESTful gateway to
Ceph Storage Clusters
.
It provides object storage functionality with an interface that is compatible with a large subset of the Amazon S3 RESTful API.
Terminology
¶
Ceph uses the term
object
for the data that it stores.
The daemon that is responsible for storing and managing data is the
Ceph
OSD
.
Ceph’s storage is divided into
pools
, which are logical partitions for storing objects.
They are also referred to as
data pools
,
storage pools
or
OSD pools
.
A
Ceph Object Gateway
consists of several OSD pools and one or more
Ceph Object Gateway daemon
(
radosgw
) processes that provide object gateway functionality.
cephobject
driver in Incus
¶
Note
The
cephobject
driver can only be used for buckets.
For storage volumes, use the
Ceph
or
CephFS
drivers.
Unlike other storage drivers, this driver does not set up the storage system but assumes that you already have a Ceph cluster installed.
You must set up a
radosgw
environment beforehand and ensure that its HTTP/HTTPS endpoint URL is reachable from the Incus server or servers.
See
Manual Deployment
for information on how to set up a Ceph cluster and
Ceph Object Gateway
on how to set up a
radosgw
environment.
The
radosgw
URL can be specified at pool creation time using the
cephobject.radosgw.endpoint
option.
Incus uses the
radosgw-admin
command to manage buckets. So this command must be available and operational on the Incus servers.
This driver also behaves differently than other drivers in that it provides remote storage.
As a result and depending on the internal network, storage access might be a bit slower than for local storage.
On the other hand, using remote storage has big advantages in a cluster setup, because all cluster members have access to the same storage pools with the exact same contents, without the need to synchronize storage pools.
Incus assumes that it has full control over the OSD storage pool.
Therefore, you should never maintain any file system entities that are not owned by Incus in an Incus OSD storage pool, because Incus might delete them.
Configuration options
¶
The following configuration options are available for storage pools that use the
cephobject
driver and for storage buckets in these pools.
Storage pool configuration
¶
cephobject.bucket_name_prefix
Prefix to add to bucket names in Ceph
Key:
cephobject.bucket_name_prefix
Type:
string
Default:
Scope:
global
cephobject.cluster_name
The Ceph cluster to use
Key:
cephobject.cluster_name
Type:
string
Default:
ceph
Scope:
global
cephobject.radosgw.endpoint
URL of the
radosgw
gateway process
Key:
cephobject.radosgw.endpoint
Type:
string
Default:
Scope:
global
cephobject.radosgw.endpoint_cert_file
Path to the file containing the TLS client certificate to use for endpoint communication
Key:
cephobject.radosgw.endpoint_cert_file
Type:
string
Default:
Scope:
global
cephobject.user.name
The Ceph user to use
Key:
cephobject.user.name
Type:
string
Default:
admin
Scope:
global
volatile.pool.pristine
Whether the
radosgw
incus-admin
user existed at creation time
Key:
volatile.pool.pristine
Type:
string
Default:
true
Scope:
global
Storage bucket configuration
¶
size
Quota of the storage bucket
Key:
size
Type:
string
Default:
