'Managing Server Firewalls
'

'Firewall Architecture Concepts
'

'Linux kernel includes 'netfilter', a framework for network traffic operations such as packet filtering, network address 
translation and port translation. By implementing handlers in the kernel that intercept function calls and messages, 
netfilter allows other kernel modules to interface directly with the kernels networking stack.'


--> 'Nftables enhances netfilter'


'The Linux kernel also includes nftables, a new filter and packet classification subsystem that has enhanced portions of netfilters code,
but retaining the netfilter architecture such as networking stack hooks, connection tracking system, and the logging facility'


--> 'Introducing firewalld'

'Firewalld is a dynamic firewall manager, a front end to the nftables framework using the nft command. 
Until the introduction of nftables, firewalld used the iptables command to configure netfilter directly, 
as an improved alternative to the iptables service.
In RHEL 8, firewalld remains the recommended front end, managing firewall rulesets using nft. '

'Firewalld checks the source address for every packet coming into the system. If that source address is assigned to a 
specific zone, the rules for that zone apply. If the source address is not assigned to a zone, firewalld associates the packet 
with the zone for the incoming network interface and the rules for that zone apply. If the network interface is not associated with 
a zone for some reason, then firewalld associates the packet with the default zone.

'


Table 11.1. Default Configuration of Firewalld Zones

Zone name	Default configuration
trusted	'Allow all incoming traffic.'
home	'Reject incoming traffic unless related to outgoing traffic or matching the ssh, mdns, ipp-client, samba-client, or dhcpv6-client pre-defined services.'
internal	'Reject incoming traffic unless related to outgoing traffic or matching the ssh, mdns, ipp-client, samba-client, or dhcpv6-client pre-defined services (same as the home zone to start with).'
work	'Reject incoming traffic unless related to outgoing traffic or matching the ssh, ipp-client, or dhcpv6-client pre-defined services.'
public	'Reject incoming traffic unless related to outgoing traffic or matching the ssh or dhcpv6-client pre-defined services. The default zone for newly added network interfaces.'
external	'Reject incoming traffic unless related to outgoing traffic or matching the ssh pre-defined service. Outgoing IPv4 traffic forwarded through this zone is masqueraded to look like it originated from the IPv4 address of the outgoing network interface.'
dmz	'Reject incoming traffic unless related to outgoing traffic or matching the ssh pre-defined service.'
block	'Reject all incoming traffic unless related to outgoing traffic.'
drop	'Drop all incoming traffic unless related to outgoing traffic (do not even respond with ICMP errors).'

#For a list of available pre-defined zones and intended use, see firewalld.zones(5).

'Pre-defined Services
''
Firewalld has a number of pre-defined services. These service definitions help you identify particular network services to 
configure. Instead of having to research relevant ports for the samba-client service, for example, specify the pre-built samba-client 
service to configure the correct ports and protocols. The following table lists the pre-defined services used in the initial firewall 
zones configuration.'

Table 11.2. Selected Pre-defined Firewalld Services

Service name	Configuration
ssh	             'Local SSH server. Traffic to 22/tcp'
dhcpv6-client	 'Local DHCPv6 client. Traffic to 546/udp on the fe80::/64 IPv6 network'
ipp-client	     'Local IPP printing. Traffic to 631/udp.'
samba-client	 'Local Windows file and print sharing client. Traffic to 137/udp and 138/udp.'
mdns	         'Multicast DNS (mDNS) local-link name resolution. Traffic to 5353/udp to the 224.0.0.251 (IPv4) or ff02::fb (IPv6) multicast addresses.
'

#Many pre-defined services are included in the firewalld package. Use firewall-cmd --get-services to list them. Configuration files for pre-defined services are found in /usr/lib/firewalld/services, in a format defined by firewalld.zone(5).




### Configuring the Firewall from the Command Line

The firewall-cmd command interacts with the firewalld dynamic firewall manager. It is installed as part of the main firewalld package 
and is available for administrators who prefer to work on the command line, for working on systems without a graphical environment, 
or for scripting a firewall setup.

The following table lists a number of frequently used firewall-cmd commands, along with an explanation. Note that unless otherwise 
specified, almost all commands will work on the runtime configuration, unless the --permanent option is specified. If the --permanent 
option is specified, you must activate the setting by also running the firewall-cmd --reload command, which reads the current permanent 
configuration and applies it as the new runtime configuration. Many of the commands listed take the --zone=ZONE option to determine which 
zone they affect. Where a netmask is required, use CIDR notation, such as 192.168.1/24.

firewall-cmd commands	Explanation
#--get-default-zone	
Query the current default zone.

#--set-default-zone=ZONE	
Set the default zone. This changes both the runtime and the permanent configuration.

#--get-zones	
List all available zones.

#--get-active-zones	
List all zones currently in use (have an interface or source tied to them), along with their interface and source information.

#--add-source=CIDR [--zone=ZONE]	
Route all traffic coming from the IP address or network/netmask to the specified zone. If no --zone= option is provided, the default zone is used.

#--remove-source=CIDR [--zone=ZONE]	
Remove the rule routing all traffic from the zone coming from the IP address or network/netmask network. If no --zone= option is provided, the default zone is used.

#--add-interface=INTERFACE [--zone=ZONE]	
Route all traffic coming from INTERFACE to the specified zone. If no --zone= option is provided, the default zone is used.

#--change-interface=INTERFACE [--zone=ZONE]	
Associate the interface with ZONE instead of its current zone. If no --zone= option is provided, the default zone is used.

#--list-all [--zone=ZONE]	
List all configured interfaces, sources, services, and ports for ZONE. If no --zone= option is provided, the default zone is used.

#--list-all-zones	
Retrieve all information for all zones (interfaces, sources, ports, services).

#--add-service=SERVICE [--zone=ZONE]	
Allow traffic to SERVICE. If no --zone= option is provided, the default zone is used.

#--add-port=PORT/PROTOCOL [--zone=ZONE]	
Allow traffic to the PORT/PROTOCOL port(s). If no --zone= option is provided, the default zone is used.

#--remove-service=SERVICE [--zone=ZONE]	
Remove SERVICE from the allowed list for the zone. If no --zone= option is provided, the default zone is used.

#--remove-port=PORT/PROTOCOL [--zone=ZONE]	
Remove the PORT/PROTOCOL port(s) from the allowed list for the zone. If no --zone= option is provided, the default zone is used.

#--reload	
Drop the runtime configuration and apply the persistent configuration.

[root@host ~]# firewall-cmd --set-default-zone=dmz
[root@host ~]# firewall-cmd --permanent --zone=internal --add-source=192.168.0.0/24
[root@host ~]# firewall-cmd --permanent --zone=internal --add-service=mysql
[root@host ~]# firewall-cmd --reload



''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Controlling SELinux Port Labeling''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'SELinux does more than just file and process labeling. Network traffic is also tightly enforced by the SELinux policy. One of the methods 
that SELinux uses for controlling network traffic is labeling network ports; for example, in the targeted policy, port 22/TCP has the label 
ssh_port_t associated with it. The default HTTP ports, 80/TCP and 443/TCP, have the label http_port_t associated with them.'

---> Managing SELinux Port Labeling

'Listing Port Labels

To get an overview of all the current port label assignments, run the semanage port -l command. The -l option lists all 
current assignments in this form:'

port_label_t     tcp|udp    comma,separated,list,of,ports
Example output:

[root@host ~]# semanage port -l
...output omitted...
http_cache_port_t       tcp   8080, 8118, 8123, 10001-10010
http_cache_port_t       udp   3130
http_port_t             tcp   80, 81, 443, 488, 8008, 8009, 8443, 9000
...output omitted...


-> 'Managing Port Labels'


Use the 'semanage' command to assign new port labels

'To add a port to an existing port label (type), use the following syntax. The -a adds a new port label, the -t denotes the type, the -p denotes the protocol.'
[root@host ~]# semanage port -a -t port_label -p tcp|udp PORTNUMBER

'For example, to allow a gopher service to listen on port 71/TCP:'
[root@host~]# semanage port -a -t gopher_port_t -p tcp 71

'To view local changes to the default policy, administrators can add the -C option to the semanage command.'
[root@host~]# semanage port -l -C 
SELinux Port Type              Proto    Port Number

gopher_port_t                  tcp      71


-> 'Removing Port Labels'

'For example, to remove the binding of port 71/TCP to gopher_port_t:'
[root@host ~]# semanage port -d -t gopher_port_t -p tcp 71


-> 'Modifying Port Bindings'

'To change a port binding, perhaps because requirements changed, use the -m (Modify) option.
'

'For example, to modify port 71/TCP from gopher_port_t to http_port_t, an administrator can use the following command:
'
[root@server ~]# semanage port -m -t http_port_t -p tcp 71



''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''EXAMPLE''

Use the systemctl command to restart the httpd.service. This command is expected to fail.

[root@servera ~]# systemctl restart httpd.service
Job for httpd.service failed because the control process exited with error code.
See "systemctl status httpd.service" and "journalctl -xe" for details.



Use the systemctl status -l command to reveal the status of the httpd service. Note the permission denied error.

[root@servera ~]# systemctl status -l httpd.service
● httpd.service - The Apache HTTP Server


Use the sealert command to check if SELinux is blocking httpd from binding to port 82/TCP.

[root@servera ~]# sudo sealert -a /var/log/audit/audit.log
100% done
found 1 alerts in /var/log/audit/audit.log
--------------------------------------------------------------------------------

'SELinux is preventing /usr/sbin/httpd from name_bind access on the tcp_socket port 82.
'



Configure SELinux to allow httpd to bind to port 82/TCP, then restart the httpd.service service.

Use the semanage command to find an appropriate port type for port 82/TCP.

[root@servera ~]# semanage port -l | grep http
http_cache_port_t              tcp      8080, 8118, 8123, 10001-10010
http_cache_port_t              udp      3130
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000



Confirm your configuration.

#[student@serverb ~]$ sudo firewall-cmd --permanent --zone=public --list-all    <-- see the conf


example = #[student@serverb ~]$ sudo firewall-cmd --permanent --zone=public --add-port=1001/tcp




Use the semanage command to assign port 82/TCP the http_port_t type.

[root@servera ~]# semanage port -a -t http_port_t -p tcp 82
Use the systemctl command to restart the httpd.service service. This command should succeed.

[root@servera ~]# systemctl restart httpd.service



'Check if you can now access the web server running on port 82/TCP. Use the curl command to access the web service from servera.
'
[root@servera ~]# curl http://servera.lab.example.com:82
Hello

'In a different terminal window, check whether you can access the new web service from workstation. Use the curl command to access 
the web service from workstation.
'
[student@workstation ~]$ curl http://servera.lab.example.com:82
curl: (7) Failed to connect to servera.example.com:82; No route to host



'Use the firewall-cmd command to open port 82/TCP in the permanent configuration for the default zone on the firewall on servera.
'
[root@servera ~]# firewall-cmd --permanent --add-port=82/tcp   (you might add --zone=public)
success 
Activate your firewall changes on servera.

[root@servera ~]# firewall-cmd --reload
success   
Use the curl command to access the web service from workstation.

[student@workstation ~]$ curl http://servera.lab.example.com:82
Hello



