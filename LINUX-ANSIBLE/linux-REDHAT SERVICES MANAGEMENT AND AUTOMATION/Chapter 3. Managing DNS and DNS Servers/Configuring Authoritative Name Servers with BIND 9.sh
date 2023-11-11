'Designing an Architecture for Authoritative Name Servers
'
Authoritative name servers store DNS resource records and provide official answers for the zones they manage. The Berkeley Internet Name Domain (BIND) software included in Red Hat Enterprise Linux allows you to implement authoritative name servers.

BIND allows you to configure an authoritative server as primary or secondary for a zone. 




                                                'BIND'

Installing BIND ---

Install BIND by installing the bind package. The name server itself runs as the named service. The bind package also installs comprehensive BIND documentation, in both HTML and PDF formats, in the /usr/share/doc/bind/ directory.

[root@host ~]# yum install bind


'The bind package in Red Hat Enterprise Linux 8 configures the service as a basic recursive caching name server by default. It is also 
configured as a primary server for localhost and related domains and addresses to take load off of the root name servers. This default 
configuration also limits access to programs on the local host only. It listens for connections on port 53 UDP/TCP of the IPv4 and IPv6 
loopback interfaces, 127.0.0.1 and ::1.'


Configuring BIND  ---   #####################

'The main configuration file used by named is '/etc/named.conf'. This file controls the basic operation of BIND. It should be owned by the root user, the named group, have octal permissions 0640, and have the named_conf_t SELinux type. 
'
The configuration file also specifies the location of the zone files for each zone managed by the authoritative server. 
On RHEL 8, these files are typically kept in '/var/named'.

Configuring a DNS server requires the following steps:

    Define address match lists for easier maintenance.

    Configure the IP addresses that named listens on.

    Configure access control for clients.

    Specify zone directives.

    Outside of the /etc/named.conf configuration file, write zone files. 


Defining Address Match Lists ---   ####################

'At the start of your '/etc/named.conf' file, you can use acl directives to define address match lists. These directives do not permit or block access to the server themselves. Instead, you can use them to define a name that expands to lists of IP addresses and networks'

'Entries can be complete IP addresses or networks denoted by either a trailing dot (192.168.0.) or CIDR notation (192.168.0/24 or 2001:db8::/32), or names of previously defined address match lists. '

 Consider the following ACL definitions:

acl trusted         { 192.168.1.21; };
acl classroom       { 192.168.0.0/24; trusted; };



Any directive that used classroom in its value would match hosts in the 192.168.0.0/24 network and 192.168.1.21. 
Using acl statements allows the same set of addresses to be referenced by multiple directives while only needing to be defined once.

There are four predefined ACLs built into named:

'Table 3.3. Predefined Address Match Lists
'
ACL 	Description
none 	Matches no hosts.
any 	Matches all hosts.
localhost 	Matches all IP addresses of the DNS server.
localnets 	Matches all hosts from the DNS servers local subnets. 


Configuring Server Interfaces ---   ##################33333



You can specify a number of global settings in the options directive in the '/etc/named.conf'file. The first two of these, listen-on and 
listen-on-v6, dictate the interfaces and ports on which named listens. The listen-on option takes a semicolon-separated list of IPv4 
addresses, and listen-on-v6 uses IPv6 addresses. 


 The following example configures BIND to listen on the 192.0.2.1 IPv4 address and the IPv6 address 2001:db8:2020::5300, in 
 addition to the default IPv4 and IPv6 loopback addresses.

'listen-on port 53 { 127.0.0.1; 192.0.2.1; };
listen-on-v6 port 53 { ::1; 2001:db8:2020::5300; };'

You could also define an acl and then use it in your listen-on and listen-on-v6 directives. This is a more complete example from 
'/etc/named.conf':

'acl interfaces    { 127.0.0.1; 192.0.2.1; };
acl interfacesv6  { ::1; 2001:db8:2020::5300; };

options {
        listen-on port 53 { interfaces; };
        listen-on-v6 port 53 { interfacesv6; };
...output omitted...
};'


Limiting Access --- ##########################

 Three additional options directives in /etc/named.conf are important to control access:

    'allow-query' controls all queries.

    'allow-recursion' controls recursive queries.

    'allow-transfer' controls zone transfers. 

By default, allow-query is set to localhost, so public authoritative servers must define allow-query { any; }; to permit internet hosts to get information from them. 




An authoritative server should not allow recursive queries. This prevents it from being used for DNS Amplification distributed denial of service attacks and better protects it against cache poisoning attacks. The easiest way to configure this is to turn off recursion entirely:

'recursion no;'


If you must allow trusted clients to perform recursion, you can turn on recursion and set allow-recursion for those specific hosts or networks:

'recursion yes;
allow-recursion { trusted-nets; };'


Your primary server must configure allow-transfer to allow your secondary servers to perform zone transfers. You should prohibit other hosts from performing zone transfers. You might allow localhost to perform zone transfers to aid troubleshooting. 


Declaring Authoritative Zones ---- ####################333

The following named.conf blocks configure a server to host the primary zone files for example.com and its corresponding 
reverse-lookup zone, 2.0.192.in-addr.arpa. It serves as a secondary server for the example.net domain, using a zone file 
retrieved from one of the servers identified by the examplenet ACL.

zone "example.com" IN {
    type master;
    file "example.com.zone";
};
zone "2.0.192.in-addr.arpa" IN {
    type master;
    file "2.0.192.zone";
};
zone "example.net" IN {
    type slave;
    file "slaves/example.net.zone";
    masters { examplenet; };
};

The file directives specify relative path names. The location of these files is determined by the directory setting in the options 
blocks, which is /var/named/ by default. Always configure named.conf to save secondary zone files in the slaves/ subdirectory, 
which has the SELinux type named_cache_t. SELinux prevents named from creating files in other locations. 


Editing Zone Files --- ########################

The location of zone files is controlled by the directory directive in the options block and the file directive in the zones 
configuration in /etc/named.conf.

If you keep secondary zone files in /var/named/slaves, then when the secondary server starts, it compares its cached version of the 
zone with the current version on the primary server, and uses it if it is up-to-date. If the zone is not up-to-date or the file
does not exist, named performs a zone transfer and caches the results in that file. 


You should configure a primary zone to get its data from a file in /var/named. BIND should be able to read those zone files but not to write them. The files should be owned by root so that they cannot be changed by the daemon if it is somehow compromised.

[root@host ~]# chmod 640 /var/named/*.zone
[root@host ~]# chcon -t named_zone_t /var/named/*.zone
[root@host ~]# chown root:named /var/named/*.zone

Zone File Format  ---- ########################

A BIND zone file is a text file that contains one directive or resource record per line. If the resource record contains a parenthesis in 
its data, it can span multiple lines. Everything to the right of a semicolon (;) on the same physical line is commented out.

A zone file may start with a $TTL directive that sets the default TTL for any resource record that does not have one listed. T
his allows you to adjust the TTL for many resource records at once without editing the entire file. If the TTL is a number, 
it is measured in seconds.

'$TTL 3600
'
A single letter can follow the number to specify longer periods of time:

    M for minutes (1M is 60)

    H for hours (1H is 3600)

    D for days (1D is 86400)

    W for weeks (1W is 604800) 

Every zone file contains exactly one SOA (Start of Authority) resource record. Consider the following SOA resource record for the example.com domain:

