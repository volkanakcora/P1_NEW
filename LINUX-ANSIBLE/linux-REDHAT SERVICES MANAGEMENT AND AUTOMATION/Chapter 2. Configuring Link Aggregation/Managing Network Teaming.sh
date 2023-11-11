'Network Teaming Configuration Files'

NetworkManager creates configuration files for network teaming in the /etc/sysconfig/network-scripts directory, the same way it does for other interfaces. It creates configuration 
files for each of the interfaces; for the team interface and for each of the ports. 



     'The value of the DEVICETYPE variable determines the type of interface being defined, in this case Team for a network team.

    The configuration file for the team interface defines the IP settings for the interface.

    The TEAM_CONFIG variable defines the teamd configuration parameters for the team interface, using JSON syntax. 
'
[root@host ~]# cat /etc/sysconfig/network-scripts/ifcfg-team0
TEAM_CONFIG="{ \"runner\": { \"name\": \"broadcast\" } }"
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
IPADDR=172.25.5.100
PREFIX=24
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=team0
UUID=f0813ead-3d0e-491e-89d6-2ec0fe616b68
DEVICE=team0
ONBOOT=yes
DEVICETYPE=Team


                    ' The following configuration file defines a port interface.'

    The DEVICETYPE variable informs the initialization scripts this is a port interface.

    The TEAM_MASTER variable defines the team interface for which this port is a slave. 

[root@host ~]# cat /etc/sysconfig/network-scripts/ifcfg-team0-ens4
NAME=team0-ens4
UUID=2f8a7ab3-e0ce-42d7-8357-20d90700f96f
DEVICE=ens4
ONBOOT=yes
TEAM_MASTER=team0
DEVICETYPE=TeamPort




                                'Setting and Adjusting Team Configuration'

Initial network team configuration is set when the team interface is created. The default runner is roundrobin, but if you specify a 
team.runner value then that runner will be assigned. Default values for runner parameters are used if they are not specified.         


' The nmcli con mod command assigns different runner parameters. Use the team.config option with either a JSON string 
 (in the case of simple changes) or the name of a file with a more complex JSON configuration. The nmcli command changes the value of the 
 TEAM_CONFIG variable in the initialization scripts file for the team interface.'

nmcli con mod CONN_NAME team.config JSON-configuration-file-or-string

- > Consider the following /tmp/team.conf file, which assigns different priorities to the port interfaces of an activebackup team:

[root@host ~]# cat /tmp/team.conf
{
    "device": "team0",
    "mcast_rejoin": {
        "count": 1
    },
    "notify_peers": {
        "count": 1
    },
    "ports": {
        "eth1": {
            "prio": -10,
            "sticky": true,
            "link_watch": {
                "name": "ethtool"
            }
        },
        "eth2": {
            "prio": 100,
            "link_watch": {
                "name": "ethtool"
            }
        }
    },
    "runner": {
        "name": "activebackup"
    }
}

You could use the following command to apply the settings from the /tmp/team.conf file:

--- >> to see it [root@host ~]# nmcli con mod team0 team.config /tmp/team.conf




[[[[[[[[[[[[[[[[[  'HEALTH CHECK ']]]]]]]]]]]]]]]]]

 The link_watch setting determines how the link states of the port interfaces are monitored. The default value is shown below, and uses functionality similar to the ethtool command to determine the link state of each interface:

"link_watch": {
    "name": "ethtool"
}

ARP ping packets can also determine the link state for remote connectivity. In this case, local and remote IP addresses and timeouts must be specified. The following example uses ARP ping packets to confirm link availability:

"link_watch":{
    "name": "arp_ping",
    "interval": 100,
    "missed_max": 30,
    "source_host": "192.168.23.2",
    "target_host": "192.168.23.1"
},



                    [[[[[[[[[[[[[[[[[[[[   'Troubleshooting Network Teams'   ]]]]]]]]]]]]]]]]]]]]

           'Use the teamnl and teamdctl commands to troubleshoot network teams'         

 Display the port interfaces of the team0 team interface:

[root@host ~]# teamnl team0 ports
 4: eth2: up 4294967295Mbit FD
 3: eth1: up 4294967295Mbit FD



Display the currently active port of team0:

[root@host ~]# teamnl team0 getoption activeport



Change the active port of team0:

[root@host ~]# teamdctl team0 state item set runner.active_port eth1




[[[[[[[[[[[[[[[  'TO SUM UP ']]]]]]]]]]]]]]]

 Modify the team0 connection to use the round-robin runner. With that runner, both port interfaces receive traffic.

[root@servera ~]# nmcli con mod team0 team.runner roundrobin

Restart the team0 connection.

[root@servera ~]# nmcli con down team0
Connection 'team0' successfully deactivated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/53)
[root@servera ~]# nmcli con up team0
Connection successfully activated (master waiting for slaves) (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/84)

!!!! SO BOTH PORTS GET TRAFFIC SIMUTANEOUSLY

