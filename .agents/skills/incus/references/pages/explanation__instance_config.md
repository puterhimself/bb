# Instance configuration

Source: https://linuxcontainers.org/incus/docs/main/explanation/instance_config/
Fetched: 2026-08-07

Instance configuration
¶
The instance configuration consists of different categories:
Instance properties
Instance properties are specified when the instance is created.
They include, for example, the instance name and architecture.
Some of the properties are read-only and cannot be changed after creation, while others can be updated by
setting their property value
or
editing the full instance configuration
.
In the YAML configuration, properties are on the top level.
See
Instance properties
for a reference of available instance properties.
Instance options
Instance options are configuration options that are related directly to the instance.
They include, for example, startup options, security settings, hardware limits, kernel modules, snapshots and user keys.
These options can be specified as key/value pairs during instance creation (through the
--config
key=value
flag).
After creation, they can be configured with the
incus
config
set
and
incus
config
unset
commands.
In the YAML configuration, options are located under the
config
entry.
See
Instance options
for a reference of available instance options, and
Configure instance options
for instructions on how to configure the options.
Instance devices
Instance devices are attached to an instance.
They include, for example, network interfaces, mount points, USB and GPU devices.
Devices are usually added after an instance is created with the
incus
config
device
add
command, but they can also be added to a profile or a YAML configuration file that is used to create an instance.
Each type of device has its own specific set of options, referred to as
instance device options
.
In the YAML configuration, devices are located under the
devices
entry.
See
Devices
for a reference of available devices and the corresponding instance device options, and
Configure devices
for instructions on how to add and configure instance devices.
