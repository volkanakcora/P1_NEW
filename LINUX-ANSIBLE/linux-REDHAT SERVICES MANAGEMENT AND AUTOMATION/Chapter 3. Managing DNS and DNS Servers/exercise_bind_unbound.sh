 Make serverb a primary name server for backend.lab.example.com and reverse zones for 192.168.0.0/24 and fde2:6494:1e09:2::/64.

Install BIND 9 on serverb. Configure BIND according to the following specifications:

    Listen on any interfaces for IPv4 and IPv6 queries.

    Allow localhost, 172.25.250.254, and 192.168.0.0/24 to request resource data.

    Disable recursion.

    Remove the root (.) hint stanza.

    Add an include statement for /etc/named.backend.conf.

    Configure zone directives in /etc/named.backend.conf to reference your zone files. You can copy this file from ~/dns-review/files/primary-named.backend.conf on workstation.

    Copy existing zone files from ~/dns-review/files/zones on workstation to /var/named on serverb and ensure that named can read them. 



     On workstation, log in to serverb as student and then become the root user.

    [student@workstation ~]$ ssh serverb
    ...output omitted...
    [student@serverb ~]$ sudo -i
    [sudo] password for student: student
    [root@serverb ~]# 

    Install the bind package.

    [root@serverb ~]# yum install bind
    ...output omitted...
    Is this ok [y/N]: y
    ...output omitted...
    Complete!

    Edit /etc/named.conf to match the following:

    ...output omitted...
    options {
            listen-on port 53 { any; };
            listen-on-v6 port 53 { any; };
            directory       "/var/named";
            dump-file       "/var/named/data/cache_dump.db";
            statistics-file "/var/named/data/named_stats.txt";
            memstatistics-file "/var/named/data/named_mem_stats.txt";
            allow-query     { localhost; 172.25.250.254; 192.168.0.0/24; };
            recursion no;

            pid-file "/run/named/named.pid";
            session-keyfile "/run/named/session.key";

            /* https://fedoraproject.org/wiki/Changes/CryptoPolicy */
            include "/etc/crypto-policies/back-ends/bind.config";
    };

    logging {
            channel default_debug {
                    file "data/named.run";
                    severity dynamic;
            };
    };

    include "/etc/named.rfc1912.zones";
    include "/etc/named.root.key";
    include "/etc/named.backend.conf";

    Create the /etc/named.backend.conf include file that identifies the forward and reverse zones for the backend.lab.example.com subdomain.

    zone "backend.lab.example.com" IN {
            type master;
            file "backend.lab.example.com.zone";
            forwarders {};
    };

    zone "0.168.192.in-addr.arpa" IN {
            type master;
            file "192.168.0.zone";
            forwarders {};
    };

    zone "2.0.0.0.9.0.E.1.4.9.4.6.2.E.D.F.ip6.arpa" IN {
            type master;
            file "fde2.6494.1e09.2.zone";
            forwarders {};
    };

    Ensure the /etc/named.backend.conf file is readable, not writable, by the named group.

    [root@serverb ~]# chmod 640 /etc/named.backend.conf
    [root@serverb ~]# chgrp named /etc/named.backend.conf

    Copy the three zone files in the ~/dns-review/files/zones directory on workstation to /var/named on serverb.

        /var/named/backend.lab.example.com.zone

        /var/named/192.168.0.zone

        /var/named/fde2.6494.1e09.2.zone 

    The contents of the zone files should match the following:

    /var/named/backend.lab.example.com.zone

 '   $TTL 300
    @ IN SOA serverb.backend.lab.example.com. root.serverb.backend.lab.example.com. (
                        0     ;serial number
                        1H    ;refresh secondary
                        5M    ;retry refresh
                        1W    ;expire zone
                        1M )  ;cache time-to-live for negative answers

    ; owner                   TTL     CL  type    RDATA
                              600     IN  NS      serverb

    servera                           IN  A       192.168.0.10
    serverb                           IN  A       192.168.0.11
    serverc                           IN  A       192.168.0.12
    serverd                           IN  A       192.168.0.13

    servera                           IN  AAAA    fde2:6494:1e09:2::a
    serverb                           IN  AAAA    fde2:6494:1e09:2::b
    serverc                           IN  AAAA    fde2:6494:1e09:2::c
    serverd                           IN  AAAA    fde2:6494:1e09:2::d'

    /var/named/192.168.0.zone

   ' $TTL 300
    @ IN SOA serverb.backend.lab.example.com. root.serverb.backend.lab.example.com. (
                        0     ;serial number
                        1H    ;refresh secondary
                        5M    ;retry refresh
                        1W    ;expire zone
                        1M )  ;cache time-to-live for negative answers

    ; owner                 TTL     CL  type    RDATA
                            600     IN  NS      serverb.backend.lab.example.com.

    10.0.168.192.IN-ADDR.ARPA.      IN  PTR     servera.backend.lab.example.com.
    11                              IN  PTR     serverb.backend.lab.example.com.
    12                              IN  PTR     serverc.backend.lab.example.com.
    13                              IN  PTR     serverd.backend.lab.example.com.'

    /var/named/fde2.6494.1e09.2.zone
'
    $TTL 300
    @ IN SOA serverb.backend.lab.example.com. root.serverb.backend.lab.example.com. (
                        0     ;serial number
                        1H    ;refresh secondary
                        5M    ;retry refresh
                        1W    ;expire zone
                        1M )  ;cache time-to-live for negative answers

    ; owner                         TTL     CL type RDATA
                                    600     IN NS   serverb.backend.lab.example.com.

    A.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0         IN PTR  servera.backend.lab.example.com.
    B.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0         IN PTR  serverb.backend.lab.example.com.
    C.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0         IN PTR  serverc.backend.lab.example.com.
    D.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0         IN PTR  serverd.backend.lab.example.com.'

    Ensure the zone files are readable, not writable, by the named group.

    [root@serverb ~]# chmod 640 /var/named/*.zone
    [root@serverb ~]# chgrp named /var/named/*.zone

    Configure the firewall to allow DNS traffic, and then enable and start the named service on serverb.

    [root@serverb ~]# firewall-cmd --add-service=dns --permanent
    success
    [root@serverb ~]# firewall-cmd --reload
    success
    [root@serverb ~]# systemctl enable --now named
    Created symlink /etc/systemd/system/multi-user.target.wants/named.service → /usr/lib/systemd/system/named.service.
##############################################################################3




    As an alternative solution, the following configure_primary.yml playbook, when created in ~/dns-review on workstation, automates all of the preceding substeps of this step:

 '   ---
    - name: Configure primary nameserver
      hosts: primary_dns
      remote_user: devops
      become: yes

      tasks:
        - name: Install BIND9
          yum:
            name: bind
            state: present

        - name: Copy primary config file
          copy:
            src: files/primary-named.conf
            dest: /etc/named.conf
            owner: root
            group: named
            mode: 0640
          notify:
            - reload_named

        - name: Copy zone files to primary
          copy:
            src: files/zones/
            dest: /var/named
            owner: root
            group: named
            mode: 0640
          notify:
            - reload_named

        - name: Copy named.backend conf file
          copy:
            src: files/primary-named.backend.conf
            dest: /etc/named.backend.conf
            owner: root
            group: named
            mode: 0640
          notify:
            - reload_named

        - name: Add dns service on firewall
          firewalld:
            service: dns
            state: enabled
            immediate: yes
            permanent: yes

        - name: Make sure named is running
          service:
            name: named
            state: started
            enabled: yes

      handlers:
        - name: reload_named
          service:
            name: named
            state: reloaded'












                                        ['UNBOUNDDD']

                                         Make servera a caching name server that meets the following requirements:

    Install the unbound package on servera.

    Configure unbound to allow queries from the 172.25.250.0/24 subnet, exempt the example.com zone from DNSSEC validation, and forward all queries to 172.25.250.254.

    Start and enable unbound and configure the firewall to allow DNS traffic on servera. 

    On workstation, use SSH to log in to servera as student. Use sudo -i to switch to root.

    [student@workstation ~]$ ssh servera
    ...output omitted...
    [student@servera ~]$ sudo -i
    [sudo] password for student: student
    [root@servera ~]# 

    Install unbound.

    [root@servera ~]# yum install unbound
    ...output omitted...
    Is this ok [y/N]: y
    ...output omitted...
    Complete!

    Configure unbound to allow queries from the 172.25.250.0/24 subnet, exempt the example.com zone from DNSSEC validation, and forward all queries to 172.25.250.254.

    Create the following file in /etc/unbound/conf.d/server.conf, with permissions 0644, and owned by user root and group unbound:

    server:
            interface-automatic: yes
            access-control: 172.25.250.0/24 allow
            domain-insecure: "example.com"

    forward-zone:
            name: "."
            forward-addr: 172.25.250.254

    Generate private key and server certificates.

    [root@servera ~]# unbound-control-setup
    setup in directory /etc/unbound
    generating unbound_server.key
    Generating RSA private key, 3072 bit long modulus (2 primes)
    ..........................................................++++
    .....++++
    e is 65537 (0x010001)
    generating unbound_control.key
    Generating RSA private key, 3072 bit long modulus (2 primes)
    ....................................++++
    ......................................++++
    e is 65537 (0x010001)
    create unbound_server.pem (self signed certificate)
    create unbound_control.pem (signed client certificate)
    Signature ok
    subject=CN = unbound-control
    Getting CA Private Key
    Setup success. Certificates created. Enable in unbound.conf file to use

    Check the syntax of the Unbound configuration files.

    [root@servera ~]# unbound-checkconf
    unbound-checkconf: no errors in /etc/unbound/unbound.conf

    Start and enable unbound.

    [root@servera ~]# systemctl enable --now unbound
    Created symlink /etc/systemd/system/multi-user.target.wants/unbound.service → /usr/lib/systemd/system/unbound.service.

    Allow DNS traffic on servera.

    [root@servera ~]# firewall-cmd --permanent --add-service=dns
    success
    [root@servera ~]# firewall-cmd --reload
    success

    As an alternative solution, the following configure_caching.yml playbook, when created in ~/dns-review on workstation and supplemented with the following ~/dns-review/templates/unbound.conf.j2 template, automates all of the preceding substeps of this step.

    The ~/dns-review/templates/unbound.conf.j2 template should appear as follows:

    server:
            interface-automatic: {{ interface_automatic }}
            access-control: {{ access_control }}
            domain-insecure: "{{ domain_insecure }}"

    forward-zone:
            name: "{{ forward_zone_name }}"
            forward-addr: {{ forward_zone_addr }}

    The ~/dns-review/configure_caching.yml playbook should appear as follows:

    ---
    - name: Install cache only nameserver
      hosts: caching_dns
      remote_user: devops
      become: true

      vars:
        interface_automatic: "yes"
        access_control: "172.25.250.0/24 allow"
        domain_insecure: example.com
        forward_zone_name: .
        forward_zone_addr: "172.25.250.254"

      tasks:
        - name: Install cache only nameserver
          yum:
            name: unbound
            state: present

        - name: Create configuration file on caching server host
          template:
            src: unbound.conf.j2
            dest: /etc/unbound/conf.d/unbound.conf
          notify:
            - restart_unbound

        - name: Allow dns service on firewall
          firewalld:
            service: dns
            state: enabled
            immediate: yes
            permanent: yes

        - name: Make sure unbound is running and enabled
          service:
            name: unbound
            state: started
            enabled: yes

      handlers:
        - name: restart_unbound
          service:
            name: unbound
            state: restarted
            enabled: true



[[[[[[[[[[[[[[[[[[[[[[[[[[[[['TESTING']]]]]]]]]]]]]]]]]]]]]]]]]]]]]

     On servera, query localhost.localdomain from the lab.example.com address. The dig command fails because unbound was configured to only permit queries coming from the 172.25.250.0/24 network, which localhost (127.0.0.1) is not a member of.

    [student@servera ~]$ dig localhost.localdomain @172.25.250.11
    ; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el8 <<>> localhost.localdomain @172.25.250.11
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: REFUSED, id: 49470
    ;; flags: qr rd; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1
    ;; WARNING: recursion requested but not available

    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 4096
    ; COOKIE: 20589e1425bbea852112a38c5eaa4c0c9096b62efa266e2f (good)
    ;; QUESTION SECTION:
    ;localhost.localdomain.   IN    A

    ;; Query time: 0 msec
    ;; SERVER: 172.25.250.11#53(172.25.250.11)
    ;; WHEN: Wed Apr 29 22:54:52 CDT 2020
    ;; MSG SIZE  rcvd: 78

    Query localhost.localdomain from the backend.lab.example.com address. This succeeds because BIND permits all queries from that subnet.

    [student@servera ~]$ dig localhost.localdomain @192.168.0.11
    ; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el8 <<>> localhost.localdomain @192.168.0.11
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 59823
    ;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2
    ;; WARNING: recursion requested but not available

    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 4096
    ; COOKIE: 06e0042c651d6fcb872910945eaa4cdf4568f17a222783ec (good)
    ;; QUESTION SECTION:
    ;localhost.localdomain.        IN  A

    ;; ANSWER SECTION:
    localhost.localdomain.  86400  IN  A     127.0.0.1

    ;; AUTHORITY SECTION:
    localhost.localdomain.  86400  IN  NS    localhost.localdomain.

    ;; ADDITIONAL SECTION:
    localhost.localdomain.  86400  IN  AAAA  ::1

    ;; Query time: 0 msec
    ;; SERVER: 192.168.0.11#53(192.168.0.11)
    ;; WHEN: Wed Apr 29 22:58:23 CDT 2020
    ;; MSG SIZE  rcvd: 136

    As student on serverb, confirm that the caching name server on servera answers forward lookups. The caching name server on servera caches entries from the back-end network but only answers queries from the classroom network range 172.25.250.0/24.

    Look up the IP addresses for serverd.backend.lab.example.com. Use the servera classroom network address, 172.25.250.10.

    [student@serverb ~]$ dig serverd.backend.lab.example.com @172.25.250.10

    ; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el8 <<>> serverd.backend.lab.example.com @172.25.250.10
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 36733
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 4096
    ;; QUESTION SECTION:
    ;serverd.backend.lab.example.com.       IN  A

    ;; ANSWER SECTION:
    serverd.backend.lab.example.com.   300  IN  A    192.168.0.13

    ;; Query time: 1 msec
    ;; SERVER: 172.25.250.10#53(172.25.250.10)
    ;; WHEN: Sun Apr 26 21:53:37 CDT 2020
    ;; MSG SIZE  rcvd: 76

    Confirm that IPv4 reverse DNS lookups work for a host in the 192.168.0.0/24 range.

    [student@serverb ~]$ dig -x 192.168.0.13 @localhost
    ; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el8 <<>> -x 192.168.0.13 @localhost
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 23502
    ;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 3
    ;; WARNING: recursion requested but not available

    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 4096
    ; COOKIE: e8b5d5896badeb922369e3585eaa4fd74957bf93c5b3878e (good)
    ;; QUESTION SECTION:
    ;13.0.168.192.in-addr.arpa.            IN  PTR

    ;; ANSWER SECTION:
    13.0.168.192.in-addr.arpa.        300  IN  PTR   serverd.backend.lab.example.com.

    ;; AUTHORITY SECTION:
    0.168.192.in-addr.arpa.           600  IN  NS    serverb.backend.lab.example.com.

    ;; ADDITIONAL SECTION:
    serverb.backend.lab.example.com.  300  IN  AAAA  fde2:6494:1e09:2::b
    serverb.backend.lab.example.com.  300  IN  A     192.168.0.11

    ;; Query time: 0 msec
    ;; SERVER: ::1#53(::1)
    ;; WHEN: Wed Apr 29 23:11:03 CDT 2020
    ;; MSG SIZE  rcvd: 193

    Confirm that IPv6 reverse DNS lookups work for a host in the fde2:6494:1e09:2::0/64 range.

    [student@serverb ~]$ dig -x fde2:6494:1e09:2::d @localhost
    ; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el8 <<>> -x fde2:6494:1e09:2::d @localhost
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 37108
    ;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 3
    ;; WARNING: recursion requested but not available

    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 4096
    ; COOKIE: 70c1df0fa19083b7461ebf5b5eaa5102a9863371a8e23258 (good)
    ;; QUESTION SECTION:
    ;d.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.2.0.0.0.9.0.e.1.4.9.4.6.2.e.d.f.ip6.arpa. IN PTR

    ;; ANSWER SECTION:
    D.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.2.0.0.0.9.0.E.1.4.9.4.6.2.E.D.F.ip6.arpa. 300 IN PTR serverd.backend.lab.example.com.

    ;; AUTHORITY SECTION:
    2.0.0.0.9.0.E.1.4.9.4.6.2.E.D.F.ip6.arpa. 600 IN NS serverb.backend.lab.example.com.

    ;; ADDITIONAL SECTION:
    serverb.backend.lab.example.com.   300  IN  AAAA   fde2:6494:1e09:2::b
    serverb.backend.lab.example.com.   300  IN  A      192.168.0.11

    ;; Query time: 0 msec
    ;; SERVER: ::1#53(::1)
    ;; WHEN: Wed Apr 29 23:16:02 CDT 2020
    ;; MSG SIZE  rcvd: 304