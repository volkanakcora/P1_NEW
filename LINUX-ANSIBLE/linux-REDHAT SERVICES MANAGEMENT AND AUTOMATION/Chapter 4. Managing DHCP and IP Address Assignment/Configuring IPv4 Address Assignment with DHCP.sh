The DHCP server responds with a DHCPOFFER packet that contains its own IP address and an IP address that the client should use. The packet also includes a lease duration to indicate for how long the offered IP address is valid, and the additional network parameters, such as the default gateway and the DNS servers.


On the DHCP server, the systemd-journald service captures those exchanges. Use the journalctl --unit=dhcpd.service command 
to access the log messages. The following extract shows a client requesting an IP address with DHCP.

DHCPDISCOVER from 52:54:00:01:fa:0b via eth0 1
DHCPOFFER on 192.168.0.150 to 52:54:00:01:fa:0b (hosta) via eth0 2
DHCPREQUEST for 192.168.0.150 (192.168.0.2) from 52:54:00:01:fa:0b (hosta) via eth0 3
DHCPACK on 192.168.0.150 to 52:54:00:01:fa:0b (hosta) via eth0 4

1 The client with the 52:54:00:01:fa:0b MAC address sends a DHCPDISCOVER packet.

2 The server offers the 192.168.0.150 IP address.

3 The client requests that IP address.

4 The server acknowledges the request from the client. 


                                                'Managing Multiple DHCP Servers'


'Deploying a DHCP Server'