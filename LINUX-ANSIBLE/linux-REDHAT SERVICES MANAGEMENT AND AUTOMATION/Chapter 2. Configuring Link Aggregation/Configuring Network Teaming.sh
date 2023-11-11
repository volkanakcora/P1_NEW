'Introducing Network Teaming Concepts
'
Keeping network services available requires a solid foundation of high network availability. Having multiple, redundant network trunks 
keeps network services available when at least one of the trunks provides connectivity. Additionally, service access can be impacted when 
a single network interface is saturated with incoming network traffic.

In this case, spreading out the network traffic across multiple network interfaces might be the solution. Network teaming links multiple 
network interface cards together logically to allow for failover, or to allow higher throughput


Red Hat Enterprise Linux 8 implements network teaming with a small kernel driver and a user-space daemon, teamd. The kernel handles 
network packets efficiently and teamd handles logic and interface processing. Software, called runners, implements load balancing and 
active-backup logic, such as roundrobin. The following table summarizes the behavior of each of the runners:

Table 2.1. Teamd Runners
Runner 	Description
'activebackup' 	The failover runner that watches for link changes and selects an active port for data transfers.
'roundrobin' 	This runner transmits packets in a round-robin fashion from each of the ports.
'broadcast' 	This runner transmits each packet from all ports.
'loadbalance' 	This runner monitors traffic and uses a hash function to try to reach a perfect balance when selecting ports for packet transmission.
'lacp' 	This runner implements the 802.3ad Link Aggregation Control Protocol (LACP). It has the same transmit port selection possibilities as the loadbalance runner.
'random' 	This runner transmits packets on a randomly selected port. 





' When controlling a team interface using NetworkManager, or when troubleshooting it, you should keep the following facts in mind:
'
    Starting the team interface does not automatically start its port interfaces.

    Starting a port interface always starts the team interface.

    Stopping the team interface also stops the port interfaces.

    A team interface without ports can start static IP connections.

    A team interface without ports waits for ports when starting DHCP connections.

    If a team interface has a DHCP connection and is waiting for ports, it completes its activation when a port with a carrier signal is added.

    If a team interface has a DHCP connection and is waiting for ports, it continues to wait when a port without a carrier signal is added. 



'Configuring Network Teams':

 Create and manage team and port interfaces with the nmcli command. The following four steps create and activate a team interface:

    Create the team interface.

    Assign the IPv4 and/or IPv6 attributes of the team interface.

    Create the port interfaces.

    Bring the team and port interfaces up or down. 




'Create the Team Interface'

Use nmcli to create a connection for the team interface, with the following syntax:

[root@host ~]# nmcli con add type team con-name CONN_NAME ifname IFACE_NAME  team.runner RUNNER

where 'CONN_NAME' is the connection name, 'IFACE_NAME' names the interface, and 'RUNNER' specifies the teams runner, for example activebackup.

The following nmcli command creates a NetworkManager connection named team0. It creates a team interface named team0 that uses the loadbalance runner, which alternates between the active slave interfaces when it sends packets.

[root@host ~]# nmcli con add type team con-name team0 ifname team0  team.runner loadbalance


'Assign the IPv4/IPv6 Attributes of the Team Interface':

 The following example assigns a static IPv4 address to the team0 interface:

[root@host ~]# nmcli con mod team0 ipv4.addresses 192.0.2.4/24
[root@host ~]# nmcli con mod team0 ipv4.method manual



'Create the Port Interfaces':

 Create each of the port interfaces with the nmcli command, with the following syntax:.

[root@host ~]# nmcli con add type team-slave con-name CONN_NAME \
> ifname IFACE_NAME master TEAM

where CONN_NAME is the NetworkManager connection name, IFACE_NAME is an existing network interface, and TEAM specifies the connection name for the team interface. 


The connection name can be explicitly specified, or it will be team-slave-IFACE_NAME by default.

The following commands create the port interfaces for the team0 team interface, attaching them to the eth1 and eth2 network interfaces.

[root@host ~]# nmcli con add type team-slave con-name team0-eth1 \
> ifname eth1 master team0
[root@host ~]# nmcli con add type team-slave con-name team0-eth2 \
> ifname eth2 master team0


'Bring the Team and Port Interfaces Up or Down':

Bring the Team and Port Interfaces Up or Down

Use nmcli to manage the team and port connections with the following syntax:

[root@host ~]# nmcli con up CONN_NAME
[root@host ~]# nmcli con down CONN_NAME

where CONN_NAME is the connection name of the team or port interface.

The following example activates the team0 team interface and the team0-eth1 connections:

[root@host ~]# nmcli con up team0
[root@host ~]# nmcli con up team0-eth1







[[[[[[[[[[[[[[[[[[[[[[[[[[[[['NICE EXERCISE FOR FAILOVER TESTING']]]]]]]]]]]]]]]]]]]]]]]]]]]]]

'     Use the nmcli command to create the team0 connection.
'
    [root@servera ~]# nmcli con add type team con-name team0 ifname team0 \
    > team.runner activebackup
    Connection 'team0' (753ef82f-8e3a-49a2-a55c-dc7a7700a177) successfully added.

'    Assign the 192.168.0.100/24 address to the team0 connection.
'
    [root@servera ~]# nmcli con mod team0 ipv4.addresses 192.168.0.100/24
    [root@servera ~]# nmcli con mod team0 ipv4.method manual

'    Assign eth1 and eth2 as port interfaces for the team0 connection.
'
    [root@servera ~]# nmcli con add type ethernet slave-type team  con-name team0-port1 ifname eth1 master team0
    Connection 'team0-port1' (6c4240f2-9d24-4a7a-a148-5d58f9557a90) successfully added.
    [root@servera ~]# nmcli con add type ethernet slave-type team > con-name team0-port2 ifname eth2 master team0
    Connection 'team0-port2' (747845ad-214b-4867-8869-68499d6556de) successfully added.

'Activate the team0 connection and the two slave ports.
'
[root@servera ~]# nmcli con up team0
Connection successfully activated (master waiting for slaves) (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/26)
[root@servera ~]# nmcli con up team0-port1
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/27)
[root@servera ~]# nmcli con up team0-port2
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/28)


' Display the state of the teamed interface.
'
[root@servera ~]# teamdctl team0 state
setup:
  runner: activebackup
ports:
  eth1
    link watches:
      link summary: up
      instance[link_watch_0]:
        name: ethtool
        link: up
        down count: 0
  eth2
    link watches:
      link summary: up
      instance[link_watch_0]:
        name: ethtool
        link: up
        down count: 0
runner:
  active port: eth1



                                'HOW TO CHECK INF TRAFFIC AND OTHER STUFF'

' To confirm the IP connectivity, ping the network gateway, 192.168.0.254, on the 192.168.0.0/24 network through the team0 interface.
'
[root@servera ~]# ping -I team0 -c 4 192.168.0.254
PING 192.168.0.254 (192.168.0.254) from 192.168.0.100 team0: 56(84) bytes of data.

'Confirm that the TCP traffic only uses the active slave interface. Use ping to generate traffic. Let the command keep running.'
[root@servera ~]# ping 192.168.0.254

                        'MONITOR THE INTERFACE'

[root@servera ~]# tcpdump -i eth1

                            'BRING ONE OF THEM DOWN AND SEE SECOND INF IS TAKING OVER OR NOT '

                            [root@servera ~]# nmcli con down team0-port1

                            [root@servera ~]# teamdctl team0 state

'setup:
  runner: activebackup
ports:
  eth2
    link watches:
      link summary: up
      instance[link_watch_0]:
        name: ethtool
        link: up
        down count: 0
runner:
  active port: eth2'