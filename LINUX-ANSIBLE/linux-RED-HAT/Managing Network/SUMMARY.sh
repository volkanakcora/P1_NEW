hostname ->  'display hostname '

hostnamectl status -> 'displays hostname status '

'Set a static host name to match the current transient host name.

Change the host name and host name configuration file.'

[student@servera ~]# sudo hostnamectl set-hostname \
#servera.lab.example.com

'Add local name for a specific server'

modify etc/hosts -> 172.25.254.254 classroom.example.com classroom 'class'


host class -> might not work 

getent hosts class -> for added short local nick names 

#### CONFIGURING NAME RESOLUTION AND CON UP&DOWN 

nmcli con mod ID 

nmcli con down ID 

nmcli con up ID  

'To add a new connections' : nmclide con mod ID +ipv4.dns IP


'Create a new connection with a static network connection using the settings in the table.
'
Parameter	Setting
Connection name	lab
Interface name	enX (might vary, use the interface that has
 52:54:00:00:fa:0b as its MAC address)

IP address	172.25.250.11/24
Gateway address	172.25.250.254
DNS address	172.25.250.254

'Determine the interface name and the current active connection name. The solution assumes that the interface name is enX and the connection name is Wired connection 1.
'
[root@serverb ~]# ip link

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enX: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:00:fa:0b brd ff:ff:ff:ff:ff:ff

[root@serverb ~]# ip addr show 


[root@serverb ~]# nmcli con show --active
NAME                UUID                                  TYPE      DEVICE
Wired connection 1  03da038a-3257-4722-a478-53055cc90128  ethernet  enX


'Configure the new connection to be autostarted. Other connections should not start automatically.
'
[root@serverb ~]# nmcli con mod "lab" connection.autoconnect yes
[root@serverb ~]# nmcli con mod "Wired connection 1" connection.autoconnect no

'ADD NEW CONNECTION'

#nmcli con add con-name lab ifname enX type ethernet \
#ipv4.method manual \
#ipv4.address 172.25.250.11/24 ipv4.gateway 172.25.250.254
[root@serverb ~]# nmcli con mod "lab" ipv4.dns 172.25.250.254 



## how to add another ip to the current ifname: 

[root@serverb ~]# nmcli con mod "lab" +ipv4.addresses 10.0.1.1/24
 'OR'
[root@serverb ~]# echo "IPADDR1=10.0.1.1" \
>> /etc/sysconfig/network-scripts/ifcfg-lab
[root@serverb ~]# echo "PREFIX1=24" >> /etc/sysconfig/network-scripts/ifcfg-lab








nmcli dev status 	Show the NetworkManager status of all network interfaces.
nmcli con show 	List all NetworkManager connections.
nmcli con show name 	List the current settings for the name connection.
nmcli con add con-name name [OPTIONS] 	Add a new connection named name.
nmcli con mod name [OPTIONS] 	Modify the name connection.
nmcli con reload 	Have NetworkManager reread the configuration files. This is useful after they have been edited by hand.
nmcli con up name 	Activate the name connection.
nmcli dev dis dev 	Deactivate and disconnect the current connection on the dev network interface.
nmcli con del name 	Delete the name connection and its configuration file.
ip addr show 	Show the current network interface address configuration. 


ssh root@192.168.0.31