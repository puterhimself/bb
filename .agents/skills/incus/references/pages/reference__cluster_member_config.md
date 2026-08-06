# Cluster member configuration

Source: https://linuxcontainers.org/incus/docs/main/reference/cluster_member_config/
Fetched: 2026-08-07

Cluster member configuration
¶
Each cluster member has its own key/value configuration with the following supported namespaces:
user
(free form key/value for user metadata)
scheduler
(options related to how the member is automatically targeted by the cluster)
The following keys are currently supported:
scheduler.instance
Controls how instances are scheduled to run on this member
Key:
scheduler.instance
Type:
string
Default:
all
Possible values are
all
,
manual
, and
group
. See
Automatic placement of instances
for more information.
user.*
Free form user key/value storage
Key:
user.*
Type:
string
User keys can be used in search.
