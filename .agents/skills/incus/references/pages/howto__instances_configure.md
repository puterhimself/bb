# How to configure instances

Source: https://linuxcontainers.org/incus/docs/main/howto/instances_configure/
Fetched: 2026-08-07

How to configure instances
¶
You can configure instances by setting
Instance properties
,
Instance options
, or by adding and configuring
Devices
.
See the following sections for instructions.
Note
To store and reuse different instance configurations, use
profiles
.
Configure instance options
¶
You can specify instance options when you
create an instance
.
Alternatively, you can update the instance options after the instance is created.
CLI
API
Use the
incus
config
set
command to update instance options.
Specify the instance name and the key and value of the instance option:
```
incus config set <instance_name> <option_key>=<option_value> <option_key>=<option_value> ...

```
Send a PATCH request to the instance to update instance options.
Specify the instance name and the key and value of the instance option:
```
incus query --request PATCH /1.0/instances/<instance_name> --data '{"config": {"<option_key>":"<option_value>","<option_key>":"<option_value>"}}'

```
See
PATCH
/1.0/instances/{name}
for more information.
See
Instance options
for a list of available options and information about which options are available for which instance type.
For example, change the memory limit for your container:
CLI
API
To set the memory limit to 8 GiB, enter the following command:
```
incus config set my-container limits.memory=8GiB

```
To set the memory limit to 8 GiB, send the following request:
```
incus query --request PATCH /1.0/instances/my-container --data '{"config": {"limits.memory":"8GiB"}}'

```
Note
Some of the instance options are updated immediately while the instance is running.
Others are updated only when the instance is restarted.
See the “Live update” information in the
Instance options
reference for information about which options are applied immediately while the instance is running.
Configure instance properties
¶
CLI
API
To update instance properties after the instance is created, use the
incus
config
set
command with the
--property
flag.
Specify the instance name and the key and value of the instance property:
```
incus config set <instance_name> <property_key>=<property_value> <property_key>=<property_value> ... --property

```
Using the same flag, you can also unset a property just like you would unset a configuration option:
```
incus config unset <instance_name> <property_key> --property

```
You can also retrieve a specific property value with:
```
incus config get <instance_name> <property_key> --property

```
To update instance properties through the API, use the same mechanism as for configuring instance options.
The only difference is that properties are on the root level of the configuration, while options are under the
config
field.
Therefore, to set an instance property, send a PATCH request to the instance:
```
incus query --request PATCH /1.0/instances/<instance_name> --data '{"<property_key>":"<property_value>","<property_key>":"property_value>"}}'

```
To unset an instance property, send a PUT request that contains the full instance configuration that you want except for the property that you want to unset.
See
PATCH
/1.0/instances/{name}
and
PUT
/1.0/instances/{name}
for more information.
Configure devices
¶
Generally, devices can be added or removed for a container while it is running.
VMs support hotplugging for some device types, but not all.
See
Devices
for a list of available device types and their options.
Note
Every device entry is identified by a name unique to the instance.
Devices from profiles are applied to the instance in the order in which the profiles are assigned to the instance.
Devices defined directly in the instance configuration are applied last.
At each stage, if a device with the same name already exists from an earlier stage, the whole device entry is overridden by the latest definition.
Device names are limited to a maximum of 64 characters.
CLI
API
To add and configure an instance device for your instance, use the
incus
config
device
add
command.
Specify the instance name, a device name, the device type and maybe device options (depending on the
device type
):
```
incus config device add <instance_name> <device_name> <device_type> <device_option_key>=<device_option_value> <device_option_key>=<device_option_value> ...

```
For example, to add the storage at
/share/c1
on the host system to your instance at path
/opt
, enter the following command:
```
incus config device add my-container disk-storage-device disk source=/share/c1 path=/opt

```
To configure instance device options for a device that you have added earlier, use the
incus
config
device
set
command:
```
incus config device set <instance_name> <device_name> <device_option_key>=<device_option_value> <device_option_key>=<device_option_value> ...

```
Note
You can also specify device options by using the
--device
flag when
creating an instance
.
This is useful if you want to override device options for a device that is provided through a
profile
.
To remove a device, use the
incus
config
device
remove
command.
See
incus
config
device
--help
for a full list of available commands.
To add and configure an instance device for your instance, use the same mechanism of patching the instance configuration.
The device configuration is located under the
devices
field of the configuration.
Specify the instance name, a device name, the device type and maybe device options (depending on the
device type
):
```
incus query --request PATCH /1.0/instances/<instance_name> --data '{"devices": {"<device_name>": {"type":"<device_type>","<device_option_key>":"<device_option_value>","<device_option_key>":"device_option_value>"}}}'

```
For example, to add the storage at
/share/c1
on the host system to your instance at path
/opt
, enter the following command:
```
incus query --request PATCH /1.0/instances/my-container --data '{"devices": {"disk-storage-device": {"type":"disk","source":"/share/c1","path":"/opt"}}}'

```
See
PATCH
/1.0/instances/{name}
for more information.
Display instance configuration
¶
CLI
API
To display the current configuration of your instance, including writable instance properties, instance options, devices and device options, enter the following command:
```
incus config show <instance_name> --expanded

```
To retrieve the current configuration of your instance, including writable instance properties, instance options, devices and device options, send a GET request to the instance:
```
incus query /1.0/instances/<instance_name>

```
See
GET
/1.0/instances/{name}
for more information.
Edit the full instance configuration
¶
CLI
API
To edit the full instance configuration, including writable instance properties, instance options, devices and device options, enter the following command:
```
incus config edit <instance_name>

```
Note
For convenience, the
incus
config
edit
command displays the full configuration including read-only instance properties.
However, you cannot edit those properties.
Any changes are ignored.
To update the full instance configuration, including writable instance properties, instance options, devices and device options, send a PUT request to the instance:
```
incus query --request PUT /1.0/instances/<instance_name> --data '<instance_configuration>'

```
See
PUT
/1.0/instances/{name}
for more information.
Note
If you include changes to any read-only instance properties in the configuration you provide, they are ignored.
