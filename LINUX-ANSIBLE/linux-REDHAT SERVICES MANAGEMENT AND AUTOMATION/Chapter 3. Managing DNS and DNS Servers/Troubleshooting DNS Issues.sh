                            'Troubleshooting DNS'

Working name resolution depends on correct:

    Name resolution and /etc/resolv.conf on the client.

    Operation of the caching name server used by the client.

    Operation of the authoritative name server that provides data to the caching name server.

    Data on the authoritative name servers.

    Configuration of the network used to communicate between these systems. 


'Confirming the Source of Name Resolution Issues'

You can use the getent command, from the glibc-common package, to perform name resolution, mirroring the process used by most applications in following the order of host name resolution as dictated by /etc/nsswitch.conf.

[user@host ~]$ getent hosts example.com
172.25.254.254  example.com


                                    'Investigating DNS Issues'


One of the best tools for investigating DNS issues is dig. The dig command performs DNS lookups and provides a detailed response that 
includes diagnostic information about the request and the results.

In the following example, dig is called with a name to resolve. By default, it looks for an A record for that name: 

[user@host ~]$ #dig servera.lab.example.com   /  [user@host ~]$ dig AAAA servera.lab.example.com  / [user@host ~]$ dig A example.com 
'; <<>> DiG 9.11.4-RedHat-9.11.4-26.P2.el8 <<>> servera.lab.example.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 3241
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;servera.lab.example.com.       IN  A

;; ANSWER SECTION:
servera.lab.example.com.  3600  IN  A           172.25.250.10

;; Query time: 0 msec
;; SERVER: 172.25.250.254#53(172.25.250.254)
;; WHEN: Wed May 13 15:20:31 CDT 2020
;; MSG SIZE  rcvd: 68'


!!!  was NOERROR, which means it completed successfully. One record was provided as an answer. The QUESTION SECTION restates the query, and the ANSWER SECTION displays the resource records that were returned: servera.lab.example.com has an A record pointing to 172.25.250.10, and has a time-to-live (TTL) indicating that the answer should be cached for 3600 seconds. 


!!! This example returned two AAAA records for the host. If the ANSWER SECTION is missing and ANSWER is 0, then the lookup did not find a resource record of that type for the name. 

 Normally, dig uses the DNS name servers listed in /etc/resolv.conf. You can specify a different name server by adding an @ followed by the name of the server on the command line. The following example looks up an MX record for example.com on classroom.example.com. The results also report some related information about the name server, which a caching name server would also cache.

[user@host ~]# dig @classroom.example.com mx example.com
'; <<>> DiG 9.11.4-RedHat-9.11.4-26.P2.el8 <<>> @classroom.example.com mx example.com
 global options: +cmd
 Got answer:'


                                        'Diagnosing Network Connectivity Issues'


For DNS name resolution to work properly, the client must be able to communicate with the resolving name server, and the resolving name server with other authoritative name servers.

For example, the following error occurs if dig cannot reach any DNS server in /etc/resolv.conf. This could be because the name server is down, an issue with the network or firewall on the client, or a misconfiguration of /etc/resolv.conf.


[user@host ~]$ # dig A example.com

;' <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el8 <<>> A example.com
;; global options: +cmd
;; connection timed out; no servers could be reached'

If you allow traffic on port 53/UDP but not port 53/TCP, you will see truncation notices followed by host unreachable errors when the resolver encounters a response that is larger than it can handle over UDP:

[user@host ~]$ # dig @dns.example.com A labhost1.example.com
;; Truncated, retrying in TCP mode.
;; Connection to 172.25.1.11#53(172.25.1.11) for labhost1.example.com failed:
host unreachable.

Use the tcp or vc options with dig to help determine if DNS queries can succeed with TCP. These options force dig to use TCP, rather than the default behavior of using UDP first and falling back to TCP only for large responses.

[user@host ~]$ # dig +tcp A example.com


NOTE:  Another useful tool for diagnosing network-related issues is a network packet analyzer such as tcpdump or wireshark. 



                                            'Interpreting DNS Response Codes'

If DNS client-server communication is successful, dig generates much more verbose output detailing the nature of the response received from the DNS server. The status field in the HEADER section of the dig output reports the response code generated by the DNS server in response to the clients query.

[user@host ~]$ dig A example.com

'; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el8 <<>> A example.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 30523
...output omitted...      '                                    

A NOERROR status indicates the query was resolved successfully. If the server encounters problems fulfilling the clients query, one of the following common error status codes is displayed:

Table 3.2. DNS Status Codes
Code 	Meaning
""SERVFAIL"" 	The name server encountered a problem while processing the query.
""NXDOMAIN"" 	The queried name does not exist in the zone.
""REFUSED"" 	The name server refused the clients DNS request due to policy restrictions. 


insert into computed_total (id, period_from, period_to, total, granularity, metrics_type, report, row_inserted)
values (nextval('computed_total_id_seq'), '2021-04-01 00:00:00', '2021-05-01 00:00:00', 51, 'MONTH', 'SUM_OUTAGE', 'AMP', now());