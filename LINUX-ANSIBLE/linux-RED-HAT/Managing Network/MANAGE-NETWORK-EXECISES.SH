Create a new connection with a static network connection using the settings in the table.

Parameter	Setting
Connection name	lab
Interface name	enX (might vary, use the interface that has 52:54:00:00:fa:0b as its MAC address)
IP address	172.25.250.11/24
Gateway address	172.25.250.254
DNS address	172.25.250.254


#########################

Determine the interface name and the current active connections name. The solution assumes that the interface name is enX and the connection name is Wired connection 1.

[root@serverb ~]# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enX: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:00:fa:0b brd ff:ff:ff:ff:ff:ff
[root@serverb ~]# nmcli con show --active
NAME                UUID                                  TYPE      DEVICE
Wired connection 1  03da038a-3257-4722-a478-53055cc90128  ethernet  enX


Create the new lab connection profile based on the information in the table described in the instructions. Associate the profile with your network interface name listed in the output of the previous ip link command.

[root@serverb ~]# nmcli con add con-name lab ifname enX type ethernet \
ipv4.method manual \
ipv4.address 172.25.250.11/24 ipv4.gateway 172.25.250.254
[root@serverb ~]# nmcli con mod "lab" ipv4.dns 172.25.250.254


########################

Configure the new connection to be autostarted. Other connections should not start automatically.

[root@serverb ~]# nmcli con mod "lab" connection.autoconnect yes
[root@serverb ~]# nmcli con mod "Wired connection 1" connection.autoconnect no


#################################

Modify the new connection so that it also uses the address 10.0.1.1/24.

[root@serverb ~]# nmcli con mod "lab" +ipv4.addresses 10.0.1.1/24
Or alternately:

[root@serverb ~]# echo "IPADDR1=10.0.1.1" \
>> /etc/sysconfig/network-scripts/ifcfg-lab
[root@serverb ~]# echo "PREFIX1=24" >> /etc/sysconfig/network-scripts/ifcfg-lab


###################################

Configure the hosts file so that 10.0.1.1 can be referenced as private.

[root@serverb ~]# echo "10.0.1.1 private" >> /etc/hosts


####################################
Reboot system 
#systemctl reboot

From workstation use the ping command to verify that serverb is initialized.

[student@workstation ~]$ ping -c3 serverb