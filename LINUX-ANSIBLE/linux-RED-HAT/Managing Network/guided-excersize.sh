Locate the network interface name associated with the 
Ethernet address 52:54:00:00:fa:0a. Record or remember 
this name and use it to replace the enX placeholder in subsequent commands.

[student@servera ~]$ ip link


###############

Display the current IP address and netmask for all interfaces.

[student@servera ~]$ ip addr



################

Display the statistics for the enX interface.

[student@servera ~]$ ip -s link show enX

#################

Display the routing information.

[student@servera ~]$ ip route

###################

Verify that the router is accessible.

[student@servera ~]$ ping -c3 172.25.250.254

##################

Show all the hops between the local system and classroom.example.com.

[student@servera ~]$ tracepath classroom.example.com

##################
Display the listening TCP sockets on the local system.

[student@servera ~]$ ss -lt
