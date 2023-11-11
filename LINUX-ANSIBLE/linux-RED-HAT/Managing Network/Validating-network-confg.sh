ip link show "to see the network interfaces"

ip addr show  enx083a88550e35

 ip addr show enx083a88550e35
3: enx083a88550e35: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
                                "An active interface is UP."
    link/ether 08:3a:88:55:0e:35 brd ff:ff:ff:ff:ff:ff
            "The link/ether line specifies the hardware (MAC) address of the device."

    inet 172.23.48.62/24 brd 172.23.48.255 scope global dynamic noprefixroute enx083a88550e35
    "The inet line shows an IPv4 address, its network prefix length, and scope."
       valid_lft 13348sec preferred_lft 13348sec

    inet6 fe80::b635:a7a2:907b:159/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
    
       "This inet6 line shows that the interface has an IPv6 address of link scope that can only be used for communication on the local Ethernet link."

Example: "inet6 2001:db8:0:1:5054:ff:fe00:b/64 scope global
       valid_lft forever preferred_lft forever"

    The inet6 line shows an IPv6 address, its network prefix length, and scope. This address is of global scope and is normally used.


ip -s link show ens3 "Displaying Performance Statistics

The ip command may also be used to show statistics about network performance. Counters for each network interface can be used to identify the presence of network issues. 
The counters record statistics for things like the number of received (RX) and transmitted (TX) packets, packet errors, and packets that were dropped."


"" how to check ping "" : ping -c3 192.0.2.254



""""The ping6 command is the IPv6 version of ping in Red Hat Enterprise Linux. It communicates over IPv6 and takes IPv6 addresses, but otherwise works like ping.

[user@host ~]$ ping6 2001:db8:0:1::1""""

#######    Tracing Routes Taken by Traffic  ####


To trace the path that network traffic takes to reach a remote host through multiple routers, use either traceroute or tracepath. 
This can identify whether an issue is with one of your routers or an intermediate one. 
Both commands use UDP packets to trace a path by default; however, many networks block UDP and ICMP traffic. 
The 'traceroute' command has options to trace the path with UDP (default), ICMP (-I), or TCP (-T) packets. Typically, however, the traceroute command is not installed by default.

The tracepath6 and traceroute -6 commands are the equivalent to tracepath and traceroute for IPv6.

