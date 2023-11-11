'After completing this section, you should be able to improve web site performance by using HAProxy as a load balancer and an HTTPS terminator in front of your Varnish Cache. '


Describing HAProxy:


 One feature you can offload from a busy web server is the HTTPS decryption and encryption process. TLS processing is CPU intensive. 
 By delegating that operation to a different system, you free some resources from the web server, which then has more processing power to 
 manage its workload.

Another approach to reducing the load on a web server is to deploy a farm of identical web servers and then distribute, 
or load balance, the incoming web requests between them. 


'HAProxy is a load balancer that you can also configure as an HTTPS terminator to offload TLS processing from the back-end web servers. 
You deploy HAProxy in front of those web servers. Instead of accessing the web servers directly, web clients contact HAProxy. 
On behalf of those clients, HAProxy retrieves and returns the requested objects from the back-end web servers.'



     The web client uses HTTPS to request a web document from HAProxy. For the client, HAProxy behaves as a web server.

    HAProxy uses its TLS certificate and private key to decrypt the HTTPS traffic.

    HAProxy forwards the request to the back-end web server in plain text.

    The back-end web server sends its reply to HAProxy.

    HAProxy uses its TLS certificate and private key to encrypt the reply and then sends it back to the web client. 


                                'Selecting a Load-balancing Algorithm'

'roundrobin'
    This algorithm sends requests to each of the web servers in turn. You use it when the web farm delivers static content or when the web application running on the back-end servers keeps the user sessions in a global store. 



'source'

 This algorithm uses the IP address of the client to select a back-end server. With this algorithm, HAProxy always forwards the client requests to the same server. You use this algorithm when the web application running on the back-end servers cannot globally manage sessions. 
.

                                'Deploying and Configuring HAProxy'

 Install the haproxy package.



[root@host ~]# yum install haproxy

Enable and start the haproxy systemd service.

[root@host ~]# systemctl enable --now haproxy


 HAProxy uses the /etc/haproxy/haproxy.cfg configuration file. This file groups the configuration parameters under the following sections:

'global'     
  The global section defines the parameters related to the haproxy process, such as the Linux user account to use for the daemon. You usually do not have to change anything in that section. 

'defaults'

    The defaults section sets default values for parameters for the other sections. You can overwrite those parameters in following sections. 
'frontend name'
    A frontend section configures the client-facing side of HAProxy. In this section, you specify the network port to listen on for incoming requests. This is also where you configure HAProxy as an HTTPS terminator. 
'backend name'
    A backend section lists all the back-end web servers. In this section you specify the load-balancing algorithm and the mechanism to check the health of the back-end servers. 
'listen name'
    A listen section allows for a more compact way to define the front-end and back-end configurations. When your setup is simple, you can use a single listen section instead of frontend and backend sections. 











facing-end

'The following example shows the declaration of frontend and backend sections.
    '
    frontend my-clients
    bind *:80  '1'
    default_backend my-web-farm  '2'

    backend my-web-farm
    balance roundrobin  '3'
    server web1 192.168.0.101:80 check inter 1s '4'
    server web2 192.168.0.102:80 check inter 1s
    server web3 192.168.0.103:80 check inter 1s

    1 HAProxy listens on all its interfaces on port 80 for incoming requests.

    2 HAProxy distributes the requests to the web servers in the backend my-web-farm section.

    3 The load-balancing algorithm is roundrobin.

    4 HAProxy distributes the requests between three back-end web servers. Also, HAProxy checks every second the health of those servers so that it does not send requests to web servers that are down. 

facing-end


'If you prefer, you can use a listen section for a more compact version of the preceding configuration.'


    listen my-clients-and-web-farm
    bind *:80
    balance roundrobin
    server web1 192.168.0.101:80 check inter 1s
    server web2 192.168.0.102:80 check inter 1s
    server web3 192.168.0.103:80 check inter 1s
    
.


.                                        'Configuring HAProxy as an HTTPS Terminator'
                                        
Before configuring HAProxy as an HTTPS terminator, obtain a TLS certificate and private key for your server. 
HAProxy expects the certificate and the key in a single file, so you may have to create that file. Because the file contains the private key,
store it in a secured directory:

[root@host ~]# mkdir /etc/pki/haproxy/
[root@host ~]# chmod 700 /etc/pki/haproxy/
[root@host ~]# cat www.example.com.crt www.example.com.key > \
> /etc/pki/haproxy/haproxy.pem

'In the /etc/haproxy/haproxy.cfg configuration file, you define the HTTPS terminator configuration under the frontend section':

    frontend my-clients
    bind *:443 ssl crt /etc/pki/haproxy/haproxy.pem  '1'
    bind *:80  '2'
    redirect scheme https if !{ ssl_fc }  '3'
    option forwardfor  '4'
    http-request add-header X-Forwarded-Proto https  '5'
    default_backend my-web-farm

    1 HAProxy listens on port 443 for incoming HTTPS requests. The traffic on that port uses TLS. The certificate and private key are in the /etc/pki/haproxy/haproxy.pem file.

    2 HAProxy also listens on port 80 for HTTP requests that do not use TLS encryption.

    3 If a request arrives that does not use TLS encryption, HAProxy replies with a 302 HTTP redirection to instruct clients to use HTTPS instead.

    4 HAProxy inserts the X-Forwarded-For HTTP header into the request when forwarding it to the back-end web servers, to provide them with the IP address of the client. The default configuration file defines the option forwardfor directive under the defaults section. You can therefore omit it in your frontend sections.

    5 HAProxy inserts the X-Forwarded-Proto HTTP header into the request when forwarding it to the back-end web servers so that they are aware that the initial connection uses HTTPS. 
.


                                        'Configuring HAProxy in Front of Varnish'

Because Varnish cannot work as an HTTPS terminator, it is a typical configuration to use HAProxy together with Varnish. 
In that setup, HAProxy terminates HTTPS connections and then forwards the traffic to Varnish in plain text. Varnish forwards the 
requests to the back-end web server, caches the replies, and then send them back to HAProxy for delivery to the web clients. 


Because both HAProxy and Varnish insert the X-Forwarded-For HTTP header into the requests, and because Varnish sees HAProxy as 
a web client, properly configuring the header is complex. To simplify that setup, the HAProxy developers have created the HTTP PROXY protocol. 

'Configuring HAProxy for the PROXY Protocol'
    Under the backend section, set the send-proxy-v2 option to activate the HTTP PROXY protocol with Varnish.

    backend my-varnish
    server varnish 192.168.0.42:6081 send-proxy-v2 check inter 1s
.

'Configuring Varnish for the PROXY Protocol'
     For Varnish, add the PROXY keyword at the end of the -a option of the varnishd command. To do so, reconfigure the varnish systemd service by creating a drop-in file.

    [root@host ~]# mkdir /etc/systemd/system/varnish.service.d/
    [root@host ~]# vim /etc/systemd/system/varnish.service.d/httpport.conf
    [Service]
    ExecStart=
    ExecStart=/usr/sbin/varnishd -a :6081,PROXY -f /etc/varnish/default.vcl -s malloc,256m
    [root@host ~]# systemctl daemon-reload
    [root@host ~]# systemctl restart varnish
.



                                            'Monitoring and Managing HAProxy'

HAProxy provides an HTML statistics reporting page. From that page, you can inspect and monitor the behavior of your installation. 
If you activate admin mode, then you can temporarily disable a back-end server so that it does not receive traffic any more. 
This feature is useful for maintenance purposes. 

' The default configuration dis


        frontend stat-page
        bind *:8080  '1'
        stats enable  '2'
        stats uri /haproxystats  '3'
        stats auth operator1:redhat123  '4'
        stats admin if TRUE  '5'

    1        You can create a dedicated frontend section and listen on a specific port just for the statistics reporting page. You can also use an existing frontend section.

    2        The stats enable directive activates the statistics reporting page.

    3         By default, you access the reporting page with the /haproxy?stats URL path. You can change that default path with the stats uri directive. In the example, you access the page with the http://www.example.com:8080/haproxystats URL.

    4         Because the statistics reporting page provides some information on your configuration, use the stats auth directive to protect it with a login and a password.

    5         By default, the statistics reporting page is read-only. By activating admin mode, you can also disable and enable back-end web servers directly from the web interface. 

.'
address


git remote add origin https://github.com/volkanakcora/adsad.git
git branch -M main
git push -u origin main















[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ EXERCISE ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

 On serverb, deploy and configure Varnish according to the following table.

Table 9.1. Varnish Parameters
Parameter 	Value
Back-end web server 	serverc.lab.example.com, port 80
TTL for all objects 	Two days
Purge requests 	Only accepted when originating from localhost on port 80
HTTP PROXY protocol 	Enabled on port 9000 for the traffic with HAProxy running on servera

Make sure that the service is running and starts at boot and that the firewall allows connections on port 9000.

If you need help, install the varnish-docs package on workstation. The documentation under the /usr/share/doc/varnish-docs/html/users-guide/ directory provides some configuration examples.

    Connect to serverb and become the root user.

    [student@workstation ~]$ ssh serverb
    ...output omitted...
    [student@serverb ~]$ sudo -i
    [sudo] password for student: student
    [root@serverb ~]# 

    Install the varnish package.

    [root@serverb ~]# yum install varnish
    ...output omitted...
    Is this ok [y/N]: y
    ...output omitted...
    Complete!

    Edit the /etc/varnish/default.vcl configuration file, locate the backend default section, and then update the .host and .port parameters.

    backend default {
        .host = "serverc.lab.example.com";
        .port = "80";
    }

    Do not close the file yet.

    Locate the vcl_backend_response routine and then set the beresp.ttl parameter to two days.

    sub vcl_backend_response {
      set beresp.ttl = 2d;
    }

    Add an acl purge section and then edit the vcl_recv routine. When done, save and exit the file.

    acl purge {
      "localhost";
    }

    sub vcl_recv {
      if (req.method == "PURGE") {
        if (!client.ip ~ purge) {
          return(synth(405,"Not allowed."));
        }
        return (purge);
      }
    }

    To configure the varnishd daemon to listen on ports 80 and 9000, overwrite the default systemd service configuration. Create a drop-in directory for the varnish service.

    [root@serverb ~]# mkdir /etc/systemd/system/varnish.service.d

    Overwrite the command that starts the service. To do so, create the /etc/systemd/system/varnish.service.d/port.conf file with the following content:

    [Service]
    ExecStart=
    ExecStart=/usr/sbin/varnishd -a :9000,PROXY -a :80 -f /etc/varnish/default.vcl -s malloc,256m

    Use the systemctl daemon-reload command to ensure that systemd is aware of the change.

    [root@serverb ~]# systemctl daemon-reload

    Enable and start the service.

    [root@serverb ~]# systemctl enable --now varnish
    Created symlink /etc/systemd/system/multi-user.target.wants/varnish.service → /usr/lib/systemd/system/varnish.service.

    Confirm that the service is running.

    [root@serverb ~]# systemctl status varnish
    ● varnish.service - Varnish Cache, a high-performance HTTP accelerator
       Loaded: loaded (/usr/lib/systemd/system/varnish.service; enabled; vendor preset: disabled)
      Drop-In: /etc/systemd/system/varnish.service.d
               └─port.conf
       Active: active (running) since Fri 2020-04-17 09:50:17 EDT; 31s ago
      Process: 25493 ExecStart=/usr/sbin/varnishd -a :9000,PROXY -a :80 -f /etc/varnish/default.vcl -s malloc,256m (code=exited, status=0/SUCCESS)
    ...output omitted...

    Use the firewall-cmd command to add port 9000 to the firewall rules.

    [root@serverb ~]# firewall-cmd --permanent --add-port=9000/tcp
    success
    [root@serverb ~]# firewall-cmd --reload
    success

    Use the curl command to validate your configuration. When done, log off from serverb.

    [root@serverb ~]# curl http://localhost/index.html
    This is serverc
    [root@serverb ~]# curl -X PURGE http://localhost/index.html
    <!DOCTYPE html>
    <html>
      <head>
        <title>200 Purged</title>
    ...output omitted...
    [root@serverb ~]# logout
    [student@serverb ~]$ logout
    [student@workstation ~]$ 

On servera, deploy and configure HAProxy according to the following table.

Table 9.2. HAProxy Parameters
Parameter 	Value
Front-end section name 	web
Ports 	

    443 for incoming HTTPS traffic

    80 to redirect incoming HTTP traffic to HTTPS (port 443) 

HTTPS terminator certificate and key 	/root/optimizeweb-review/servera.lab.example.com.crt and /root/optimizeweb-review/servera.lab.example.com.key on servera.
Additional header 	X-Forwarded-Proto set to https
Back-end section name 	lab
Load-balancing algorithm 	roundrobin
Back-end server 	serverb.lab.example.com (172.25.250.11), port 9000
Back-end server protocol 	HTTP PROXY protocol

Make sure that the service is running and starts at boot and that the firewall allows the HTTP and HTTPS traffic.

If you need help, the haproxy package deploys the HAProxy documentation into the /usr/share/doc/haproxy/ directory. The configuration.txt file lists all the configuration parameters and provides some examples.

    Connect to servera and become the root user.

    [student@workstation ~]$ ssh servera
    ...output omitted...
    [student@servera ~]$ sudo -i
    [sudo] password for student: student
    [root@servera ~]# 

    Install the haproxy package.

    [root@servera ~]# yum install haproxy
    ...output omitted...
    Is this ok [y/N]: y
    ...output omitted...
    Complete!

    To configure HAProxy HTTPS termination, prepare the SSL file with the servera.lab.example.com certificate and key. Create the /etc/pki/haproxy/ directory to store the SSL file for HAProxy. Protect the directory so that only the root user has access to its contents.

    [root@servera ~]# mkdir /etc/pki/haproxy
    [root@servera ~]# chmod 700 /etc/pki/haproxy

    The lab script has prepared the SSL certificate and the key files for servera.lab.example.com under the /root/optimizeweb-review/ directory. Concatenate the certificate file and the key file, in that order, into /etc/pki/haproxy/haproxy.pem.

    [root@servera ~]# cd optimizeweb-review
    [root@servera optimizeweb-review]# cat servera.lab.example.com.crt \
    servera.lab.example.com.key > /etc/pki/haproxy/haproxy.pem
    [root@servera optimizeweb-review]# cd ~
    [root@servera ~]# 

    Edit the /etc/haproxy/haproxy.cfg configuration file as shown below. Only keep the global and defaults sections. Remove all the existing frontend and backend sections.

    At the end of the file, add the frontend section named web. In that section, listen on port 443 and use the /etc/pki/haproxy/haproxy.pem SSL file. Redirect the HTTP traffic to HTTPS. Add the HTTP X-Forwarded-Proto header to all incoming requests to let the back-end web server know that the clients use HTTPS. Associate the web frontend section with the lab backend section.

    frontend web
        bind *:443 ssl crt /etc/pki/haproxy/haproxy.pem
        bind *:80
        redirect scheme https if !{ ssl_fc }
        http-request add-header X-Forwarded-Proto https
        default_backend lab

    Do not close the file yet.

    Declare the back-end server in a backend section named lab. Use the roundrobin load-balancing algorithm and enable the HTTP PROXY protocol.

    backend lab
        balance roundrobin
        server serverb.lab.example.com 172.25.250.11:9000 send-proxy-v2

    In the defaults section, comment out or remove the forwardfor option. That option instructs HAProxy to add the X-Forwarded-For header to each request that it sends to the back-end server. Because HAProxy communicates with Varnish using the HTTP PROXY protocol, you do not need that header.

    defaults
    ...output omitted...
        option http-server-close
    #    option forwardfor       except 127.0.0.0/8
        option                  redispatch
    ...output omitted...

    Save and close the file.

    Enable and start the service.

    [root@servera ~]# systemctl enable --now haproxy
    Created symlink /etc/systemd/system/multi-user.target.wants/haproxy.service → /usr/lib/systemd/system/haproxy.service.

    Confirm that the service is running.

    [root@servera ~]# systemctl status haproxy
    ● haproxy.service - HAProxy Load Balancer
       Loaded: loaded (/usr/lib/systemd/system/haproxy.service; enabled; vendor preset: disabled)
       Active: active (running) since Tue 2020-04-21 04:57:02 EDT; 26s ago
      Process: 8488 ExecStartPre=/usr/sbin/haproxy -f $CONFIG -c -q (code=exited, status=0/SUCCESS)
     Main PID: 8490 (haproxy)
    ...output omitted...

    Use the firewall-cmd command to add the http and https services to the firewall rules. When done, log off from servera.

    [root@servera ~]# firewall-cmd --permanent --add-service=http --add-service=https
    success
    [root@servera ~]# firewall-cmd --reload
    success
    [root@servera ~]# logout
    [student@servera ~]$ logout
    [student@workstation ~]$ 

Test your work from workstation. To do so, use the https://servera.lab.example.com/ link with the /home/student/optimizeweb-review/cacert.pem CA certificate. The page returns the following message:

This is serverc

    On workstation, use the curl command with the --cacert option to access the https://servera.lab.example.com/ page.

    [student@workstation ~]$ curl --cacert ~/optimizeweb-review/cacert.pem \
    > https://servera.lab.example.com/
    This is serverc

