'timedatectl' -> to see the zone

'timedatectl list-timezones'

The command 'tzselect' is useful for identifying correct zoneinfo time zone names.

The superuser can change the system setting to update the current time zone using the 'timedatectl set-timezone' command. 
The following 'timedatectl' command updates the current time zone to America/Phoenix.

[root@host ~]' timedatectl set-timezone America/Phoenix'

Use the 'timedatectl set-timezone UTC' command to set the systems current time zone to UTC.

Use the timedatectl set-time command to change the systems current time. The time is specified in the "YYYY-MM-DD hh:mm:ss" format, where either date or time can be omitted. 
The following timedatectl command changes the time to 09:00:00.

[root@host ~]'timedatectl set-time 9:00:00'
[root@host ~] 'timedatectl'


The 'timedatectl set-ntp' command enables or disables NTP synchronization for automatic time adjustment. 
The option requires either a true or false argument to turn it on or off. The following timedatectl command turns on NTP synchronization.

[root@host ~] 'timedatectl set-ntp true'


sudo timedatectl set-timezone
#### Configuring and monitoring the Chronyd

The stratum of the NTP time source determines its quality. The stratum determines the number of hops the machine is away from a high-performance reference clock. 
The reference clock is a stratum 0 time source. An NTP server directly attached to it is a stratum 1, while a machine synchronizing time from the NTP server is a stratum 2 time source.

how to see The 30 min ago: date -d "-30 minutes"



