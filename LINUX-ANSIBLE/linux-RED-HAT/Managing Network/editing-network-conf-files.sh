By default, changes made with nmcli con mod name are automatically saved to 
/etc/sysconfig/network-scripts/ifcfg-name. 
That file can also be manually edited with a text editor. After doing so, run nmcli con 
reload so that NetworkManager reads the configuration changes.

For backward-compatibility reasons, the directives saved in that file have different names 
and syntax than the nm-settings(5) names. The following table maps some of the key setting names to ifcfg-* 
directives.

#######################################

Table 12.7. Comparison of nm-settings and ifcfg-* Directives

nmcli con mod	ifcfg-* file	Effect
ipv4.method manual	BOOTPROTO=none	IPv4 addresses configured statically.
ipv4.method auto	BOOTPROTO=dhcp	Looks for configuration settings from a DHCPv4 server. If static addresses are also set, will not bring those up until we have information from DHCPv4.
ipv4.addresses 192.0.2.1/24	
IPADDR=192.0.2.1
PREFIX=24

Sets static IPv4 address and network prefix. If more than one address is set for the connection, then the second one is defined by the IPADDR1 and PREFIX1 directives, the third one by the IPADDR2 and PREFIX2 directives, and so on.
ipv4.gateway 192.0.2.254	
GATEWAY=192.0.2.254

Sets the default gateway.
ipv4.dns 8.8.8.8	DNS1=8.8.8.8	Modify /etc/resolv.conf to use this nameserver.
ipv4.dns-search example.com	DOMAIN=example.com	Modify /etc/resolv.conf to use this domain in the search directive.
ipv4.ignore-auto-dns true	PEERDNS=no	Ignore DNS server information from the DHCP server.
ipv6.method manual	IPV6_AUTOCONF=no	IPv6 addresses configured statically.
ipv6.method auto	IPV6_AUTOCONF=yes	Configures network settings using SLAAC from router advertisements.
ipv6.method dhcp	
IPV6_AUTOCONF=no
DHCPV6C=yes

Configures network settings by using DHCPv6, but not SLAAC.
ipv6.addresses 2001:db8::a/64	
IPV6ADDR=2001:db8::a/64

Sets static IPv6 address and network prefix. If more than one address is set for the connection, IPV6ADDR_SECONDARIES takes a double-quoted list of space-delimited address/prefix definitions.
ipv6.gateway 2001:db8::1	
IPV6_DEFAULTGW=2001:...

Sets the default gateway.
ipv6.dns fde2:6494:1e09:2::d	DNS1=fde2:6494:...	Modify /etc/resolv.conf to use this nameserver. Exactly the same as IPv4.
ipv6.dns-search example.com	IPV6_DOMAIN=example.com	Modify /etc/resolv.conf to use this domain in the search directive.
ipv6.ignore-auto-dns true	IPV6_PEERDNS=no	Ignore DNS server information from the DHCP server.
connection.autoconnect yes	ONBOOT=yes	Automatically activate this connection at boot.
connection.id ens3	NAME=ens3	The name of this connection.
connection.interface-name ens3	DEVICE=ens3	The connection is bound to the network interface with this name.
802-3-ethernet.mac-address ...	HWADDR=...	The connection is bound to the network interface with this MAC address.