Locate the network interface name associated with the Ethernet address 52:54:00:00:fa:0a. 
Record or remember this name and use it to replace the enX placeholder in subsequent commands.

[student@servera ~]$ ip link

##############################

If the name of the active connection is different, 
use that instead of Wired connection 1 for the rest of this exercise.

[student@servera ~]$ nmcli con show --active

################################

Display all configuration settings for the active connection.

[student@servera ~]$ nmcli con show "Wired connection 1"

#################################

Show device status.

[student@servera ~]$ nmcli dev status

##############################

Display the settings for the enX device.

[student@servera ~]$ nmcli dev show enX

GENERAL.DEVICE:              enX
GENERAL.TYPE:                ethernet
GENERAL.HWADDR:              52:54:00:00:FA:0A
GENERAL.MTU:                 1500
GENERAL.STATE:               100 (connected)
GENERAL.CONNECTION:          Wired connection 1
GENERAL.CON-PATH:            /org/freedesktop/NetworkManager/ActiveConnection/1
WIRED-PROPERTIES.CARRIER:    on
IP4.ADDRESS[1]:              172.25.250.10/24
IP4.GATEWAY:                 172.25.250.254
IP4.ROUTE[1]:                dst = 172.25.250.0/24, nh = 0.0.0.0, mt = 100
IP4.ROUTE[2]:                dst = 0.0.0.0/0, nh = 172.25.250.254, mt = 100
IP4.DNS[1]:                  172.25.250.254
IP6.ADDRESS[1]:              fe80::3059:5462:198:58b2/64
IP6.GATEWAY:                 --
IP6.ROUTE[1]:                dst = fe80::/64, nh = ::, mt = 100
IP6.ROUTE[2]:                dst = ff00::/8, nh = ::, mt = 256, table=255


#######################################
'Create a static connection with the same IPv4 address, network prefix, and default gateway. 
Name the new connection static-addr.'

sudo nmcli con add con-name "static-addr" ifname enX \
type ethernet ipv4.method manual \
ipv4.address 172.25.250.10/24 ipv4.gateway 172.25.250.254
#########################

'Modify the new connection to add the DNS setting.'

[student@servera ~]$ sudo nmcli con mod "static-addr" ipv4.dns 172.25.250.254

#############################
View the active connection.

[student@servera ~]$ nmcli con show --active
NAME                UUID                                  TYPE      DEVICE
Wired connection 1  03da038a-3257-4722-a478-53055cc90128  ethernet  enX

#################################

Activate the new static-addr connection.

[student@servera ~]$ sudo nmcli con up "static-addr"

##################################

Verify the new active connection.

[student@servera ~]$ nmcli con show --active
NAME         UUID                                  TYPE      DEVICE
static-addr  15aa3901-555d-40cb-94c6-cea6f9151634  ethernet  enX


####################################

Configure the original connection so that it does not start at boot, 
and verify that the static connection is used when the system reboots.

Disable the original connection from autostarting at boot.

[student@servera ~]$ sudo nmcli con mod "Wired connection 1" \
connection.autoconnect no

################################
Reboot the system.

[student@servera ~]$ sudo systemctl reboot

######################################

View the active connection.

[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ nmcli con show --active
NAME         UUID                                  TYPE      DEVICE
static-addr  15aa3901-555d-40cb-94c6-cea6f9151634  ethernet  enX

########################################
Test connectivity using the new network addresses.

Verify the IP address.

[student@servera ~]$ ip addr show enX
2: enX: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:00:fa:0a brd ff:ff:ff:ff:ff:ff
    inet 172.25.250.10/24 brd 172.25.250.255 scope global noprefixroute enX
       valid_lft forever preferred_lft forever
    inet6 fe80::6556:cdd9:ce15:1484/64 scope link noprefixroute
       valid_lft forever preferred_lft forever

################################################

Verify the default gateway.

[student@servera ~]$ ip route
default via 172.25.250.254 dev enX proto static metric 100
172.25.250.0/24 dev enX proto kernel scope link src 172.25.250.10 metric 100

#######################################
Ping the DNS address.

[student@servera ~]$ ping -c3 172.25.250.254



