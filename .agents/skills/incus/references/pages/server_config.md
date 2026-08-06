# Server configuration

Source: https://linuxcontainers.org/incus/docs/main/server_config/
Fetched: 2026-08-07

Server configuration
¶
The Incus server can be configured through a set of key/value configuration options.
The key/value configuration is namespaced.
The following options are available:
Core configuration
ACME configuration
Cluster configuration
Images configuration
Logging configuration
Miscellaneous options
OpenID Connect configuration
Authorization configuration
See
How to configure the Incus server
for instructions on how to set the configuration options.
Note
Options marked with a
global
scope are immediately applied to all cluster members.
Options with a
local
scope must be set on a per-member basis.
Core configuration
¶
The following server options control the core daemon configuration:
core.bgp_address
Address to bind the BGP server to
Key:
core.bgp_address
Type:
string
Scope:
local
See
How to configure Incus as a BGP server
.
core.bgp_asn
BGP Autonomous System Number for the local server
Key:
core.bgp_asn
Type:
string
Scope:
global
core.bgp_routerid
A unique identifier for the BGP server
Key:
core.bgp_routerid
Type:
string
Scope:
local
The identifier must be formatted as an IPv4 address.
core.debug_address
Address to bind the
pprof
debug server to (HTTP)
Key:
core.debug_address
Type:
string
Scope:
local
core.dns_address
Address to bind the authoritative DNS server to
Key:
core.dns_address
Type:
string
Scope:
local
See
Enable the built-in DNS server
.
core.https_address
Address to bind for the remote API (HTTPS)
Key:
core.https_address
Type:
string
Scope:
local
See
How to expose Incus to the network
.
core.https_allowed_credentials
Whether to set
Access-Control-Allow-Credentials
Key:
core.https_allowed_credentials
Type:
bool
Default:
false
Scope:
global
If enabled, the
Access-Control-Allow-Credentials
HTTP header value is set to
true
.
core.https_allowed_headers
Access-Control-Allow-Headers
HTTP header value
Key:
core.https_allowed_headers
Type:
string
Scope:
global
core.https_allowed_methods
Access-Control-Allow-Methods
HTTP header value
Key:
core.https_allowed_methods
Type:
string
Scope:
global
core.https_allowed_origin
Access-Control-Allow-Origin
HTTP header value
Key:
core.https_allowed_origin
Type:
string
Scope:
global
core.https_allowed_websocket_origin
Allowed
Origin
values for WebSocket connections
Key:
core.https_allowed_websocket_origin
Type:
string
Scope:
global
core.https_trusted_proxy
Trusted servers to provide the client’s address
Key:
core.https_trusted_proxy
Type:
string
Scope:
global
Specify a comma-separated list of IP addresses of trusted servers that provide the client’s address through the proxy connection header.
core.metrics_address
Address to bind the metrics server to (HTTPS)
Key:
core.metrics_address
Type:
string
Scope:
local
See
How to monitor metrics
.
core.metrics_authentication
Whether to enforce authentication on the metrics endpoint
Key:
core.metrics_authentication
Type:
bool
Default:
true
Scope:
global
core.proxy_http
HTTP proxy to use
Key:
core.proxy_http
Type:
string
Scope:
global
If this option is not specified, the daemon falls back to the
HTTP_PROXY
environment variable (if set).
core.proxy_https
HTTPS proxy to use
Key:
core.proxy_https
Type:
string
Scope:
global
If this option is not specified, the daemon falls back to the
HTTPS_PROXY
environment variable (if set).
core.proxy_ignore_hosts
Hosts that don’t need the proxy
Key:
core.proxy_ignore_hosts
Type:
string
Scope:
global
Specify this option in a similar format to
NO_PROXY
(for example,
1.2.3.4,1.2.3.5
)
If this option is not specified, the daemon falls back to the
NO_PROXY
environment variable (if set).
core.remote_token_expiry
Time after which a remote add token expires
Key:
core.remote_token_expiry
Type:
string
Default:
no expiry
Scope:
global
core.shutdown_action
Action to perform on server shutdown
Key:
core.shutdown_action
Type:
string
Default:
shutdown
Scope:
global
Specify the action to take when the daemon is being shut down.
Supported values are
shutdown
(stop all instances) and
evacuate
(attempt to evacuate the clustered server).
core.shutdown_timeout
How long to wait before shutdown
Key:
core.shutdown_timeout
Type:
integer
Default:
5
Scope:
global
Specify the number of minutes to wait for running operations to complete before the daemon shuts down.
core.storage_buckets_address
Address to bind the storage object server to (HTTPS)
Key:
core.storage_buckets_address
Type:
string
Scope:
local
See
How to manage storage buckets and keys
.
core.syslog_socket
Whether to enable the syslog unixgram socket listener
Key:
core.syslog_socket
Type:
bool
Default:
false
Scope:
local
Set this option to
true
to enable the syslog unixgram socket to receive log messages from external processes.
core.trust_ca_certificates
Whether to automatically trust clients signed by the CA
Key:
core.trust_ca_certificates
Type:
bool
Default:
false
Scope:
global
ACME configuration
¶
The following server options control the
ACME
configuration:
acme.agree_tos
Agree to ACME terms of service
Key:
acme.agree_tos
Type:
bool
Default:
false
Scope:
global
acme.ca_url
URL to the directory resource of the ACME service
Key:
acme.ca_url
Type:
string
Default:
https://acme-v02.api.letsencrypt.org/directory
Scope:
global
acme.challenge
ACME challenge type to use
Key:
acme.challenge
Type:
string
Default:
HTTP-01
Scope:
global
Possible values are
DNS-01
and
HTTP-01
.
acme.domain
Domain for which the certificate is issued
Key:
acme.domain
Type:
string
Scope:
global
acme.eab.hmac
HMAC key for External Account Binding
Key:
acme.eab.hmac
Type:
string
Scope:
global
acme.eab.kid
Key identifier for External Account Binding
Key:
acme.eab.kid
Type:
string
Scope:
global
acme.email
Email address used for the account registration
Key:
acme.email
Type:
string
Scope:
global
acme.http.port
Port and interface for HTTP server (used by HTTP-01)
Key:
acme.http.port
Type:
string
Default:
:80
Scope:
global
Set the port and interface to use for HTTP-01 based challenges to listen on
acme.provider
Backend provider for the challenge (used by DNS-01)
Key:
acme.provider
Type:
string
Default:
``
Scope:
global
acme.provider.environment
Environment variables to set during the challenge (used by DNS-01)
Key:
acme.provider.environment
Type:
string
Default:
``
Scope:
global
acme.provider.resolvers
Comma-separated list of DNS resolvers (used by DNS-01)
Key:
acme.provider.resolvers
Type:
string
Default:
``
Scope:
global
DNS resolvers to use for performing (recursive)
CNAME
resolving and apex domain determination during DNS-01 challenge.
OpenID Connect configuration
¶
The following server options configure external user authentication through
OpenID Connect authentication
:
oidc.audience
Expected audience value for the application
Key:
oidc.audience
Type:
string
Scope:
global
This value is required by some providers.
oidc.claim
OpenID Connect claim to use as the username
Key:
oidc.claim
Type:
string
Scope:
global
Note that the claim must be contained in the access token.
oidc.client.id
OpenID Connect client ID
Key:
oidc.client.id
Type:
string
Scope:
global
oidc.issuer
OpenID Connect Discovery URL for the provider
Key:
oidc.issuer
Type:
string
Scope:
global
oidc.scopes
Comma separated list of OpenID Connect scopes
Key:
oidc.scopes
Type:
string
Scope:
global
Authorization configuration
¶
The following server options configure user
Authorization
, either through
Open Fine-Grained Authorization (OpenFGA)
or a
Scriptlet authorization
:
authorization.client.default
Authorization driver for clients without a more specific class route
Key:
authorization.client.default
Type:
string
Scope:
global
Routes clients that do not match a more specific class to an authorization driver.
Possible values are
allow
,
deny
,
openfga
and
scriptlet
.
authorization.client.oidc
Authorization driver for OIDC-authenticated clients
Key:
authorization.client.oidc
Type:
string
Scope:
global
Routes OIDC-authenticated clients to an authorization driver.
Possible values are
allow
,
deny
,
openfga
and
scriptlet
.
authorization.client.tls
Authorization driver for unrestricted TLS clients
Key:
authorization.client.tls
Type:
string
Scope:
global
Routes clients using an unrestricted client certificate to an authorization driver.
Possible values are
allow
,
deny
,
openfga
and
scriptlet
.
authorization.client.tls-restricted
Authorization driver for restricted TLS clients
Key:
authorization.client.tls-restricted
Type:
string
Scope:
global
Routes clients using a restricted (project-scoped) client certificate to an authorization driver.
Possible values are
allow
,
deny
,
tls
,
openfga
and
scriptlet
.
authorization.client.unix
Authorization driver for local (
unix
socket) clients
Key:
authorization.client.unix
Type:
string
Scope:
global
Routes local clients connecting over the
unix
socket to an authorization driver.
Possible values are
allow
,
deny
,
openfga
and
scriptlet
.
authorization.openfga.api.token
API token of the OpenFGA server
Key:
authorization.openfga.api.token
Type:
string
Scope:
global
authorization.openfga.api.url
URL of the OpenFGA server
Key:
authorization.openfga.api.url
Type:
string
Scope:
global
authorization.openfga.store.id
ID of the OpenFGA permission store
Key:
authorization.openfga.store.id
Type:
string
Scope:
global
authorization.openfga.tls.identifier
Certificate attribute used as the OpenFGA user for TLS clients
Key:
authorization.openfga.tls.identifier
Type:
string
Default:
name
Scope:
global
When a TLS client is authorized by OpenFGA, this selects the certificate
attribute used as the OpenFGA user:
fingerprint
or
name
.
authorization.scriptlet
Authorization scriptlet
Key:
authorization.scriptlet
Type:
string
Scope:
global
When using scriptlet-based authorization, this option stores the scriptlet.
Cluster configuration
¶
The following server options control
Clustering
:
cluster.healing_threshold
Threshold when to evacuate an offline cluster member
Key:
cluster.healing_threshold
Type:
integer
Default:
0
Scope:
global
Specify the number of seconds after which an offline cluster member is to be evacuated.
To disable evacuating offline members, set this option to
0
.
cluster.https_address
Address to use for clustering traffic
Key:
cluster.https_address
Type:
string
Scope:
local
See
Separate REST API and clustering networks
.
cluster.images_minimal_replica
Number of cluster members that replicate an image
Key:
cluster.images_minimal_replica
Type:
integer
Default:
3
Scope:
global
Specify the minimal number of cluster members that keep a copy of a particular image.
Set this option to
1
for no replication, or to
-1
to replicate images on all members.
cluster.join_token_expiry
Time after which a cluster join token expires
Key:
cluster.join_token_expiry
Type:
string
Default:
3H
Scope:
global
cluster.max_standby
Number of database stand-by members
Key:
cluster.max_standby
Type:
integer
Default:
2
Scope:
global
Specify the maximum number of cluster members that are assigned the database stand-by role.
This must be a number between
0
and
5
.
cluster.max_voters
Number of database voter members
Key:
cluster.max_voters
Type:
integer
Default:
3
Scope:
global
Specify the maximum number of cluster members that are assigned the database voter role.
This must be an odd number >=
3
.
cluster.offline_threshold
Threshold when an unresponsive member is considered offline
Key:
cluster.offline_threshold
Type:
integer
Default:
20
Scope:
global
Specify the number of seconds after which an unresponsive member is considered offline.
cluster.rebalance.batch
Maximum number of instances to move during one re-balancing run
Key:
cluster.rebalance.batch
Type:
integer
Default:
1
Scope:
global
cluster.rebalance.cooldown
Amount of time during which an instance will not be moved again
Key:
cluster.rebalance.cooldown
Type:
string
Default:
6H
Scope:
global
cluster.rebalance.interval
How often (in minutes) to consider re-balancing things. 0 to disable (default)
Key:
cluster.rebalance.interval
Type:
integer
Default:
0
Scope:
global
cluster.rebalance.threshold
Percentage load difference between most and least busy server needed to trigger a migration
Key:
cluster.rebalance.threshold
Type:
integer
Default:
20
Scope:
global
Images configuration
¶
The following server options configure how to handle
Images
:
images.auto_update_cached
Whether to automatically update cached images
Key:
images.auto_update_cached
Type:
bool
Default:
true
Scope:
global
images.auto_update_interval
Interval at which to look for updates to cached images
Key:
images.auto_update_interval
Type:
integer
Default:
6
Scope:
global
Specify the interval in hours.
To disable looking for updates to cached images, set this option to
0
.
images.compression_algorithm
Compression algorithm to use for new images
Key:
images.compression_algorithm
Type:
string
Default:
gzip
Scope:
global
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
When an unused cached remote image is flushed
Key:
images.remote_cache_expiry
Type:
integer
Default:
10
Scope:
global
Specify the number of days after which the unused cached image expires.
Logging configuration
¶
The logging system now supports multiple configurable targets, each identified by a unique name (e.g.,
loki01
,
syslog01
).
Each target can be independently configured and assigned specific log types.
Supported Targets
¶
loki
-  For sending logs to a Grafana Loki server
syslog
- For sending logs to remote syslog endpoint
Example configuration
¶
```
logging.loki01.target.type: loki
logging.loki01.target.address: https://loki01.int.example.net
logging.loki01.target.username: foo
logging.loki01.target.password: bar
logging.loki01.types: lifecycle,network-acl
logging.loki01.lifecycle.types: instance

logging.syslog01.target.type: syslog
logging.syslog01.target.address: syslog01.int.example.net
logging.syslog01.target.facility: security
logging.syslog01.types: logging
logging.syslog01.logging.level: warning

```
logging.NAME.lifecycle.projects
Comma separate list of projects, empty means all
Key:
logging.NAME.lifecycle.projects
Type:
string
Scope:
global
logging.NAME.lifecycle.types
E.g.,
instance
, comma separate, empty means all
Key:
logging.NAME.lifecycle.types
Type:
string
Scope:
global
logging.NAME.logging.level
Minimum log level to send to the logger
Key:
logging.NAME.logging.level
Type:
string
Default:
info
Scope:
global
logging.NAME.target.address
Address of the logger
Key:
logging.NAME.target.address
Type:
string
Scope:
global
Specify the protocol, name or IP and port. For example
tcp://syslog01.int.example.net:514
.
logging.NAME.target.ca_cert
CA certificate for the server
Key:
logging.NAME.target.ca_cert
Type:
string
Scope:
global
logging.NAME.target.facility
The syslog facility defines the category of the log message
Key:
logging.NAME.target.facility
Type:
string
Scope:
global
logging.NAME.target.instance
Name to use as the instance field in Loki events.
Key:
logging.NAME.target.instance
Type:
string
Default:
Local server host name or cluster member name
Scope:
global
This allows replacing the default instance value (server host name) by a more relevant value like a cluster identifier.
logging.NAME.target.labels
Labels for a Loki log entry
Key:
logging.NAME.target.labels
Type:
string
Scope:
global
Specify a comma-separated list of values that should be used as labels for a Loki log entry.
logging.NAME.target.password
Password used for authentication
Key:
logging.NAME.target.password
Type:
string
Scope:
global
logging.NAME.target.retry
number of delivery retries, default 3
Key:
logging.NAME.target.retry
Type:
integer
Scope:
global
logging.NAME.target.type
The type of the logger. One of
loki
,
syslog
or
webhook
.
Key:
logging.NAME.target.type
Type:
string
Scope:
global
logging.NAME.target.username
User name used for authentication
Key:
logging.NAME.target.username
Type:
string
Scope:
global
logging.NAME.types
Events to send to the logger
Key:
logging.NAME.types
Type:
string
Default:
lifecycle,logging
Scope:
global
Specify a comma-separated list of events to send to the logger.
The events can be any combination of
lifecycle
,
logging
, and
network-acl
.
Miscellaneous options
¶
The following server options configure server-specific settings for
Instances
,
OVN
integration,
Backups
and
Storage
:
backups.compression_algorithm
Compression algorithm to use for backups
Key:
backups.compression_algorithm
Type:
string
Default:
gzip
Scope:
global
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
instances.lxcfs.per_instance
Whether to run LXCFS on a per-instance basis
Key:
instances.lxcfs.per_instance
Type:
bool
Default:
false
Scope:
global
LXCFS is used to provide overlays for common
/proc
and
/sys
files which reflect the resource limits applied to the container.
It normally operates through a single file system mount on the host which is then shared by all containers.
This is very efficient but comes with the downside that a crash of LXCFS will break all containers.
With this option, it’s now possible to run a LXCFS instance per
container instead, using more system resources but reducing the impact
of a crash.
instances.nic.host_name
How to set the host name for a NIC
Key:
instances.nic.host_name
Type:
string
Default:
random
Scope:
global
Possible values are
random
and
mac
.
If set to
random
, use the random host interface name as the host name.
If set to
mac
, generate a host name in the form
inc<mac_address>
(MAC without leading two digits).
instances.placement.scriptlet
Instance placement scriptlet for automatic instance placement
Key:
instances.placement.scriptlet
Type:
string
Scope:
global
When using custom automatic instance placement logic, this option stores the scriptlet.
See
Instance placement scriptlet
for more information.
instances.tpm.platform_cert
Platform CA certificate used to provision TPM Endorsement Keys
Key:
instances.tpm.platform_cert
Type:
string
Scope:
global
PEM encoded platform CA certificate used to sign the Endorsement
Key and platform certificate of newly created TPM devices.
Must be set together with
instances.tpm.platform_key
.
instances.tpm.platform_key
Private key for the TPM platform CA certificate
Key:
instances.tpm.platform_key
Type:
string
Scope:
global
PEM encoded private key matching
instances.tpm.platform_cert
.
Used to sign the Endorsement Key and platform certificate of newly
created TPM devices.
network.ovn.ca_cert
OVN SSL certificate authority
Key:
network.ovn.ca_cert
Type:
string
Default:
Content of
/etc/ovn/ovn-central.crt
if present
Scope:
global
network.ovn.client_cert
OVN SSL client certificate
Key:
network.ovn.client_cert
Type:
string
Default:
Content of
/etc/ovn/cert_host
if present
Scope:
global
network.ovn.client_key
OVN SSL client key
Key:
network.ovn.client_key
Type:
string
Default:
Content of
/etc/ovn/key_host
if present
Scope:
global
network.ovn.integration_bridge
OVS integration bridge to use for OVN networks
Key:
network.ovn.integration_bridge
Type:
string
Default:
br-int
Scope:
global
network.ovn.northbound_connection
OVN northbound database connection string
Key:
network.ovn.northbound_connection
Type:
string
Default:
unix:/run/ovn/ovnnb_db.sock
Scope:
global
network.ovs.connection
OVS socket path
Key:
network.ovs.connection
Type:
string
Default:
unix:/run/openvswitch/db.sock
Scope:
global
storage.backups_volume
Volume to use to store backup tarballs
Key:
storage.backups_volume
Type:
string
Scope:
local
Specify the volume using the syntax
POOL/VOLUME
.
storage.images_volume
Volume to use to store the image tarballs
Key:
storage.images_volume
Type:
string
Scope:
local
Specify the volume using the syntax
POOL/VOLUME
.
storage.linstor.ca_cert
LINSTOR SSL certificate authority
Key:
storage.linstor.ca_cert
Type:
string
Scope:
global
storage.linstor.client_cert
LINSTOR SSL client certificate
Key:
storage.linstor.client_cert
Type:
string
Scope:
global
storage.linstor.client_key
LINSTOR SSL client key
Key:
storage.linstor.client_key
Type:
string
Scope:
global
storage.linstor.controller_connection
LINSTOR controller connection string
Key:
storage.linstor.controller_connection
Type:
string
Scope:
global
storage.linstor.satellite.name
LINSTOR satellite node name override
Key:
storage.linstor.satellite.name
Type:
string
Scope:
global
Set this option to the name of the local LINSTOR satellite node, should it be different from the Incus server name.
storage.logs_volume
Volume to use to store instance log directories
Key:
storage.logs_volume
Type:
string
Scope:
local
Specify the volume using the syntax
POOL/VOLUME
.
User options
¶
Additional user defined configuration keys are available within the
user.
namespace.
User defined configuration keys are always of type
string
and have
global
scope.
Note that keys starting with
user.ui.
are used for web UI configuration options and are visible even to unauthenticated users.
