
################
'Locate the network interface name associated with the 
Ethernet address 52:54:00:00:fa:0a. Record or remember 
this name and use it to replace the enX placeholder in subsequent commands. 
The active connection is also named Wired connection 1 
(and therefore is managed by the file /etc/sysconfig/network-scripts/ifcfg-Wired_connection_1).'

If you have done previous exercises in this chapter and this was true for your system, 
it should be true for this exercise as well.

[student@servera ~]$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enX: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:00:fa:0a brd ff:ff:ff:ff:ff:ff

[student@servera ~]$ nmcli con show --active
NAME                UUID                                  TYPE      DEVICE
Wired connection 1  03da038a-3257-4722-a478-53055cc90128  ethernet  enX
[student@servera ~]$ ls \
/etc/sysconfig/network-scripts/ifcfg-Wired_connection_1
/etc/sysconfig/network-scripts/ifcfg-Wired_connection_1

##########################