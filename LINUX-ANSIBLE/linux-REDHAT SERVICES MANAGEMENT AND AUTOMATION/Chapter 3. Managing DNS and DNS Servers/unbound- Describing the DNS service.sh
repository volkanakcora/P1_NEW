'Configuring a Caching Name Server with Unbound'

'Installing and Configuring Unbound'

Caching name servers store DNS query results in a local cache and remove resource records from the cache when their TTLs expire. It is 
common to set up caching name servers to perform queries on behalf of clients on the local network. This greatly improves the efficiency 
of DNS name resolution by reducing DNS traffic across the internet.


Installing Unbound

To configure Unbound as a caching name server, make sure the unbound package is installed:

[root@host ~]# yum install unbound



'Editing the Unbound Configuration File'

As root, edit the '/etc/unbound/unbound.conf' file as shown below:

    In the server clause, define the network interfaces that Unbound will listen on.

    interface: 192.0.2.100
    interface: 2001:db8:1001::f0



'By default, Unbound only listens on the localhost network interface. To allow remote clients to use Unbound as a caching name server, 
use the interface option in the server clause of '/etc/unbound/unbound.conf' to specify the network interfaces to listen on. You can 
specify multiple interface directives.'



!!!!!  'If you set interface to 0.0.0.0 or ::0 to listen on all network interfaces, you must set interface-automatic to yes. Otherwise, 
set interface-automatic to no.

If the libvirtd service is running on the same machine as Unbound and you attempt to bind to all interfaces, Unbound might not start. 
This is because, by default, libvirtd runs dnsmasq on port 53 (the DNS server port for UDP and TCP) on the local interfaces connected 
to its virtual networks. '  !!!!!!!!!




->>>>  Permit or block access by clients.

By default, unbound refuses recursive queries from all clients except localhost. In the server clause of '/etc/unbound/unbound.conf', 
use access-control options to specify which clients can make recursive queries. 

access-control: 172.25.0.0/24 allow
access-control: 2001:db8:1001::/32 allow
access-control: 10.0.0.0/8 refuse


--->>> Optionally, forward queries to another caching name server.

'You might need to do this if this name server cannot access the internet, but can access a name server that can. You might also do this to 
send queries for your internal domain directly to the name server that is authoritative for that domain.'

'In '/etc/unbound/unbound.conf', create a forward-zone clause to specify what domain you want to forward and which DNS servers to forward 
the queries to. Set the name value to "." to forward all queries'


forward-zone:
  name: "."
  forward-addr: 172.25.254.254



--->>> Generate a private key and server certificates.

[root@host ~]# unbound-control-setup

-->>>>>> Test the /etc/unbound/unbound.conf file for syntax errors.

[root@host ~]# unbound-checkconf
unbound-checkconf: no errors in /etc/unbound/unbound.conf


'                           Enabling the Caching Name Server
'
Configure the firewall to allow DNS traffic. DNS uses ports 53/UDP and 53/TCP. If you are using firewalld you can configure it to 
allow the dns service.

[root@host ~]# firewall-cmd --permanent --add-service=dns
success
[root@host ~]# firewall-cmd --reload
success

Start and enable Unbound.

[root@host ~]# systemctl enable --now unbound

                            'Managing Unbound'

Once an Unbound DNS server has been installed, sometimes administrators need to manipulate its cache. The unbound-control utility 
manages the cache of an Unbound server.
Dumping and Loading the Unbound Cache

Administrators of caching name servers might need to dump cache data when troubleshooting DNS issues, such as those resulting 
from stale resource records. Dump the cache of an Unbound DNS server by running the unbound-control utility in conjunction with 
he dump_cache subcommand. 

[root@host ~]# unbound-control dump_cache
START_RRSET_CACHE



 Executing unbound-control with the dump_cache command dumps the cache to stdout in a text format. This output can be directed to a 
 file for storage and be loaded back into cache later with unbound-control load_cache, if desired. The unbound-control load_cache 
 command reads from stdin to populate the cache.

[root@host ~]# unbound-control load_cache < dump.out



                    'Flushing the Unbound Cache'

Administrators of caching name servers might also need to periodically purge outdated resource records from the cache. 
Erroneous and outdated resource records in the cache prevent corrected counterparts from becoming available to clients 
until the TTLs on the resource records expire. Rather than waiting for the TTL to expire, you can purge outdated records 
from the cache by executing unbound-control flush on the records:

[root@host ~]# unbound-control flush www.example.com
ok

Execute unbound-control with the flush_zone subcommand to purge all resource records belonging to a domain from an Unbound DNS server.

[root@host ~]# unbound-control flush_zone example.com
ok removed 3 rrsets, 1 messages and 0 key entries

