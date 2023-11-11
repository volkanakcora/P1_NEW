'Describing Varnish'

 Web servers with heavy traffic often need to offload part of their workload to maintain their hit rate and provide an acceptable response 
 time for customers.

Varnish Cache is a web accelerator that you deploy in front of such web servers. Instead of accessing the web server directly, web clients 
contact Varnish. On behalf of those clients, Varnish retrieves and returns the requested objects from the back-end web server. Varnish also 
caches those objects so that it can serve requests for the same objects without having to contact the web server. This way, the web server 
has more available system resources to manage its workload. 


'Explaining Caching Behavior' --------------------------------------------


 For maximum performance, Varnish caches the objects in memory. As a consequence, a restart of the Varnish service clears the cache.
Note

Varnish provides a persistent storage plug-in that stores the objects on disk, but the Varnish developers have deprecated that plug-in and discourage its use. 



'Deploying Varnish' --------------------------------------------


 Install the varnish package.

[root@host ~]# yum install varnish

Enable and start the varnish systemd service.

[root@host ~]# systemctl enable --now varnish


'Configuring Varnish' --------------------------------------------


Varnish divides its configuration between two locations:

'    The varnishd daemon command-line parameters
'
'    The /etc/varnish/default.vcl configuration file 
'
Setting Varnish Daemon Command-line Parameters

The varnishd(1) man page lists all the configuration parameters that you define as command-line options to the varnishd daemon.

' Use the systemctl cat varnish command to display the current service details.
'


[root@host ~]# systemctl cat varnish
# /usr/lib/systemd/system/varnish.service

[Unit]
Description=Varnish Cache, a high-performance HTTP accelerator
After=network-online.target



[Service]
...output omitted...
ExecStart=/usr/sbin/varnishd -a :6081 -f /etc/varnish/default.vcl -s malloc,256m



### The -a [IP]:PORT option specifies the TCP port that Varnish listens to for incoming client requests.

### The -s option specifies the storage back end for the objects cache. The malloc parameter instructs Varnish to cache objects in memory. The size, 256 MiB in 





'Configuring Network Ports' --------------------------------------------

By default, Varnish listens to port 6081. Because web clients access your web application through Varnish, you usually configure Varnish to listen on port 80, the default HTTP port. 

To do so, modify the varnish systemd service as follows: 



'Create a systemd drop-in directory for the varnish service. Drop-in directories are used to add or override individual settings, 
without modifying the original unit configuration found in /usr/lib/systemd/. Never modify files in /usr/lib/systemd/, because 
package upgrades will overwrite your custom configuration. Instead, create a subdirectory in /etc/systemd/system/ using the original 
unit name with .d appended. Drop-in configuration files in that directory must end in .conf.'

[root@host ~]# mkdir /etc/systemd/system/varnish.service.d/


To override the ExecStart parameter in the [Service] section, create a systemd configuration file for the service. The name of the file must end with the .conf extension. Set the varnishd -a option to :80.

[root@host ~]# cat /etc/systemd/system/varnish.service.d/httpport.conf
[Service]
ExecStart=
ExecStart=/usr/sbin/varnishd -a :80 -f /etc/varnish/default.vcl -s malloc,256m

The first ExecStart parameter with no value clears the command that the default configuration defines. Otherwise, systemd sequentially executes all the ExecStart commands. 



     Force systemd to reload its configuration. 

[root@host ~]# systemctl daemon-reload

    Restart the varnish service. 

[root@host ~]# systemctl restart varnish

    Open the firewall port. 

[root@host ~]# firewall-cmd --permanent --add-service=http
[root@host ~]# firewall-cmd --reload


 SELinux allows Varnish to bind to the varnishd_port_t, http_cache_port_t, and http_port_t port types. You can list the associated port numbers with the semanage port -l command.

[root@host ~]# semanage port -l | \
> grep -w  -e varnishd_port_t -e http_cache_port_t -e http_port_t | grep tcp
http_cache_port_t       tcp      8080, 8118, 8123, 10001-10010
http_port_t             tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
varnishd_port_t         tcp      6081-6082

For Varnish to listen on any other port, set the varnishd_connect_any SELinux Boolean to on.

[root@host ~]# setsebool -P varnishd_connect_any on





'Configuring Caching Behavior with VCL' ----------------------------------

The /etc/varnish/default.vcl configuration file controls the object caching behavior. You write that configuration file in the Varnish Configuration Language (VCL). When Varnish starts, it converts that file into a binary format, then loads and executes the resulting code. 


'Introducing the Built-in Subroutines'


Varnish processes incoming requests and back-end replies through a series of built-in subroutines. In the /etc/varnish/default.vcl file, you can redefine those subroutines to modify the default behavior.

For example, the vcl_recv subroutine processes requests coming from web clients. In that subroutine, you access the incoming request details through the req object. The following example, in the /etc/varnish/default.vcl file, instructs Varnish to skip the cache for files with a .mp3 or .ogg file extension.
'
sub vcl_recv {
    if (req.url ~ "\.(mp3|ogg)$") {  1
      return (pass);  2
    }
}
'

#1 The url attribute of the req object contains the request URL, such as /index.html or /sound.mp3. The ~ operator tests the url attribute against a regular expression.

#2 If the test succeeds (that is, the URL ends in .mp3 or .ogg) then the subroutine returns the pass keyword. The keyword instructs Varnish to skip the cache and pass the request directly to the back-end web server. 






The vcl_backend_response subroutine processes the reply from the back-end web server. Varnish provides the reply details through the beresp object. The following example reduces the object TTL to two hours when the back-end web server tries to force it for longer than a day.

'sub vcl_backend_response {
  if (beresp.ttl > 1d) {  1
    set beresp.ttl = 2h;  2
  }
}
'
#1 The ttl attribute of the beresp object contains the object TTL. The test determines if that TTL is longer than a day. When entering that vcl_backend_response subroutine, Varnish sets the beresp.ttl attribute to its default value of two minutes. However, if the reply from the back-end web server includes the Cache-Control HTTP header, Varnish sets the ttl attribute from that header.

#2 The subroutine reduces the TTL to only two hours. 


'Declaring an Access Control List and Configuring Purge Requests' -------------------



 The /etc/varnish/default.vcl file can also include Access Control List (ACL) declarations. Those declarations define a list of hosts or IP addresses that you can use in subroutines. The following example defines the purge_allowed ACL and then uses that ACL in the vcl_recv subroutine.

'acl purge_allowed {  1
  "localhost";
  "172.25.250.12";
  "192.168.0.12";
}

sub vcl_recv {
  if (req.method == "PURGE") {  2
    if (!client.ip ~ purge_allowed) {  3
      return(synth(405, "This address is not allowed to send PURGE requests."));
    }
    return (purge);  4
  }
}'

#1 The acl declaration defines a list of three hosts.

#2 The method attribute of the req object contains the request HTTP method, such as GET, PUT, or POST. The test verifies that the incoming request uses the PURGE HTTP method.

#3 The client object provides the client details, such as its IP address. The test checks if the request is coming from a client listed in the purge_allowed ACL. The test uses the negation operator, !, so that Varnish returns the 405 HTTP error code to the client if its IP address is not in the list.

#4The subroutine returns the purge keyword. The keyword instructs Varnish to purge the object from its cache. Varnish identifies the object from the request URL, in req.url, and the host part of the request, in req.http.host. 




'Validating VCL Syntax' --------------------------------------------

Before restarting the varnish systemd service, test your configuration with the varnishd -﻿C -﻿f /etc/varnish/default.vcl command. That command compiles the VCL file and displays the resulting C code. Most importantly, the command returns a nonzero value when errors are detected.

[root@host ~]# varnishd -C -f /etc/varnish/default.vcl
...output omitted...





'Troubleshooting and Managing Varnish'===============================


 For best performance, the varnishd daemon does not write to a log file. Instead, it writes its log messages in a buffer in shared memory. The optional varnishncsa service monitors that buffer and writes the log messages to the /var/log/varnish/varnishncsa.log log file.

The log file has a format similar to the access_log file from Apache HTTP Server:

[root@host ~]# cat /var/log/varnish/varnishncsa.log
'172.25.250.9 - - [27/Apr/2020:07:06:31 -0400] "GET http://www.example.com/index.html HTTP/1.1" 200 32 "-" "curl/7.61.1"
172.25.250.9 - - [27/Apr/2020:07:12:26 -0400] "GET http://www.example.com/favicon.ico HTTP/1.1" 404 209 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0"
172.25.250.9 - - [27/Apr/2020:07:12:27 -0400] "GET http://www.example.com/ HTTP/1.1" 200 32 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0"
'
Enable and start the varnishncsa optional systemd service as follows:

[root@host ~]# systemctl enable --now varnishncsa





'Managing Varnish from the Command Line' ==================================

With the 'varnishadm' command-line tool, you can monitor and reconfigure Varnish without a restart of the daemon. The modifications you perform with that tool are not persistent across service restarts but allows you to modify a live configuration temporarily. 


[root@host ~]# varnishadm status
Child in state running
[root@host ~]# varnishadm
200
-----------------------------
Varnish Cache CLI 1.0
-----------------------------
Linux,4.18.0-147.el8.x86_64,x86_64,-junix,-smalloc,-sdefault,-hcritbit
varnish-6.0.2 revision 0458b54db26cfbea79af45ca5c4767c7c2925a91

Type 'help' for command list.
Type 'quit' to close CLI session.

varnish> status
200
Child in state running
varnish> quit
500
Closing CLI connection
[root@host ~]# 





varnishadm ban 'expression' ========================

    The ban subcommand purges objects from the cache. This subcommand is useful when the back-end web server has new content, and you want Varnish to serve this new content without waiting for the TTL. The following command purges all the objects where the URL part is /index.html.

[root@host ~]# varnishadm 'ban req.url == /index.html'

     You can also use a regular expression with the ~ operator to purge multiple objects. The following example purges all the PNG images.

[root@host ~]# varnishadm ban 'req.url ~ .*\\.png'






'varnishadm param.show parameter' =====================


    The param.show subcommand displays the value of a Varnish parameter. You can get the list of all those parameters from the varnishd(1) man page. The following command displays the default TTL value.

    [root@host ~]# varnishadm param.show default_ttl
    default_ttl
            Value is: 120.000 [seconds] (default)
            Minimum is: 0.000

            The TTL assigned to objects if neither the backend nor the VCL
            code assigns one.

            NB: This parameter is evaluated only when objects are created.
            To change it for all objects, restart or ban everything.



'varnishadm param.set parameter value
'
    The param.set subcommand changes the value of a Varnish parameter. That change is not persistent across service restarts. If you want to make that change persistent, update the varnish systemd service configuration to add a -p option to the varnishd daemon. The following command temporarily sets the default TTL to 12 hours (43200 seconds).

    [root@host ~]# varnishadm param.set default_ttl 43200

'varnishadm vcl.show boot
'
    The vcl.show subcommand, with the boot argument, displays the active VCL. 
















[[[[[[[     'EXERCISE ']]]]]]]

Guided Exercise: Caching Static Content with Varnish

In this exercise, you will configure Varnish to cache static web content.

Outcomes

You should be able to:

    Deploy Varnish Cache on a new server.

    Configure the Varnish Cache default TTL.

    Allow requests to purge cached objects. 

As the student user on the workstation machine, use the lab command to prepare your system for this exercise.

[student@workstation ~]$ lab optimizeweb-varnish start

This command installs Apache HTTP Server on serverc and deploys some web content.

In this exercise, you deploy Varnish Cache on serverb as a front end for the web server running on serverc.

    Explore the three test pages that the web server on serverc provides. You use those test pages in later steps to validate your Varnish installation.

        Use the curl command to query the static.html page on serverc. This file is a static HTML document.

        [student@workstation ~]$ curl http://serverc.lab.example.com/static.html
        This is serverc

        Query the dynamic set-cookie.php page. That page sets a cookie, named SESSIONID, in the HTTP header. Use the curl --head (or -I) option to display the header.

        [student@workstation ~]$ curl -I http://serverc.lab.example.com/set-cookie.php
        HTTP/1.1 200 OK
        Date: Fri, 17 Apr 2020 13:03:23 GMT
        Server: Apache/2.4.37 (Red Hat Enterprise Linux)
        X-Powered-By: PHP/7.2.11
        Set-Cookie: SESSIONID=123456789; expires=Sun, 17-May-2020 13:03:23 GMT; Max-Age=2592000; path=/
        Content-Type: text/html; charset=UTF-8

        Query the dynamic set-cache.php page. That script adds a header in its reply to indicate for how long a web cache should keep the document.

        [student@workstation ~]$ curl -I http://serverc.lab.example.com/set-cache.php
        HTTP/1.1 200 OK
        Date: Fri, 17 Apr 2020 13:04:02 GMT
        Server: Apache/2.4.37 (Red Hat Enterprise Linux)
        X-Powered-By: PHP/7.2.11
        Cache-Control: max-age=180
        Content-Type: text/html; charset=UTF-8

        That Cache-Control header instructs caches to store the document for 180 seconds. 

    Deploy Varnish on serverb.

        On workstation, open a second terminal window, connect to serverb, and become the root user.

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

    Configure Varnish to use serverc.lab.example.com as the back-end web server. Configure the varnish systemd service for the varnishd daemon to listen on port 80.

        Edit the /etc/varnish/default.vcl configuration file, locate the backend default section, and then update the .host and .port parameters.

        backend default {
            .host = "serverc.lab.example.com";
            .port = "80";
        }

        Run the varnishd -C -f /etc/varnish/default.vcl command to verify the syntax of the file. The command has an exit code of zero when the syntax is correct.

        [root@serverb ~]# varnishd -C -f /etc/varnish/default.vcl
        ...output omitted...
        [root@serverb ~]# echo $?
        0

        If the command reports any errors, correct them before proceeding.

        Display the default varnish systemd service configuration.

        [root@serverb ~]# systemctl cat varnish
        # /usr/lib/systemd/system/varnish.service
        ...output omitted...
        ExecStart=/usr/sbin/varnishd -a :6081 -f /etc/varnish/default.vcl -s malloc,256m
        ...output omitted...

        The -a option indicates that the varnishd daemon listens on port 6081 by default.

        To overwrite the default service configuration, start by creating a drop-in directory for the varnish service.

        [root@serverb ~]# mkdir /etc/systemd/system/varnish.service.d

        Overwrite the command that starts the service and set the -a parameter to :80. To do so, create the /etc/systemd/system/varnish.service.d/port.conf file with the following content:

        [Service]
        ExecStart=
        ExecStart=/usr/sbin/varnishd -a :80 -f /etc/varnish/default.vcl -s malloc,256m

        The first ExecStart parameter with no value clears the command that the default configuration defines. Otherwise, systemd sequentially executes all the ExecStart commands.

        Use the systemctl daemon-reload command to ensure that systemd is aware of the change.

        [root@serverb ~]# systemctl daemon-reload

    Enable and start the varnish service and then open the firewall port.

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
          Process: 25493 ExecStart=/usr/sbin/varnishd -a :80 -f /etc/varnish/default.vcl -s malloc,256m (code=exited, status=0/SUCCESS)
        ...output omitted...

        Use the firewall-cmd command to add the http service to the firewall rules.

        [root@serverb ~]# firewall-cmd --permanent --add-service=http
        success
        [root@serverb ~]# firewall-cmd --reload
        success

    Monitor the Apache HTTP Server log on serverc. This way, you can see the requests coming from your Varnish installation.

        On workstation, open a new terminal window, connect to serverc, and become the root user.

        [student@workstation ~]$ ssh serverc
        ...output omitted...
        [student@serverc ~]$ sudo -i
        [sudo] password for student: student
        [root@serverc ~]# 

        Use the tail -f command to monitor the /var/log/httpd/access_log file.

        [root@serverc ~]# tail -f /var/log/httpd/access_log
        ...output omitted...

        Leave the command running and do not close the terminal.
        Note

        Alternatively, and to better spot new messages in the log file, you can use the tail command with the nl command. This way, the output prefixes each new line with a number.

        [root@serverc ~]# tail -f /var/log/httpd/access_log | nl
          1  172.25.250.11 - - [20/Apr/2020:02:59:17 -0400] "GET ..."
          2  172.25.250.11 - - [20/Apr/2020:02:59:19 -0400] "GET ..."
          3  172.25.250.11 - - [20/Apr/2020:02:59:20 -0400] "GET ..."
        ...output omitted...

    From the first terminal on workstation, query the static.html web page through Varnish.

        Use the curl command to access the static.html page from serverb.lab.example.com.

        [student@workstation ~]$ curl http://serverb.lab.example.com/static.html
        This is serverc

        Notice the new log message in the /var/log/httpd/access_log file on serverc. Varnish has forwarded the request to its back-end web server, serverc. In that message, notice that the request is coming from 172.25.250.11. This is the address of serverb, where Varnish is running.

        [root@serverc ~]# tail -f /var/log/httpd/access_log
        ...output omitted...
        172.25.250.11 - - [17/Apr/2020:10:02:27 -0400] "GET /static.html HTTP/1.1" 200 16 "-" "curl/7.61.1"

        From workstation, query the static.html web page a couple more times.

        [student@workstation ~]$ curl http://serverb.lab.example.com/static.html
        This is serverc
        [student@workstation ~]$ curl http://serverb.lab.example.com/static.html
        This is serverc

        Notice on serverc that the /var/log/httpd/access_log file does not change and does not report those new requests. This indicates that the requests do not reach the back-end web server. Varnish returns the document from its cache.

        From the terminal with a session on serverb, retrieve the value of the default_ttl parameter. This parameter specifies how long Varnish should serve documents from its cache.

        [root@serverb ~]# varnishadm param.show default_ttl
        default_ttl
                Value is: 120.000 [seconds] (default)
                Minimum is: 0.000
        ...output omitted...

        The default value is 120 seconds.

        From the terminal on workstation, wait 120 seconds to let the document expire and then query the static.html page again.

        [student@workstation ~]# sleep 120
        [student@workstation ~]$ curl http://serverb.lab.example.com/static.html
        This is serverc

        Notice the new entry in the /var/log/httpd/access_log file on serverc.

        ...output omitted...
        172.25.250.11 - - [17/Apr/2020:10:04:58 -0400] "GET /static.html HTTP/1.1" 200 16 "-" "curl/7.61.1"

        Varnish requests the document again from the back-end web server because its copy has expired. 

    From workstation, query the set-cookie.php web page through Varnish to confirm that Varnish does not cache replies that include cookies.

        Use the curl command to query the set-cookie.php page. Run the command several times.

        [student@workstation ~]$ curl http://serverb.lab.example.com/set-cookie.php
        ...output omitted...
        [student@workstation ~]$ curl http://serverb.lab.example.com/set-cookie.php
        ...output omitted...
        [student@workstation ~]$ curl http://serverb.lab.example.com/set-cookie.php
        ...output omitted...

        On serverc, notice the new entries in the /var/log/httpd/access_log file.

        ...output omitted...
        172.25.250.11 - - [20/Apr/2020:02:59:17 -0400] "GET /set-cookie.php HTTP/1.1" 200 111 "-" "curl/7.61.1"
        172.25.250.11 - - [20/Apr/2020:02:59:19 -0400] "GET /set-cookie.php HTTP/1.1" 200 111 "-" "curl/7.61.1"
        172.25.250.11 - - [20/Apr/2020:02:59:20 -0400] "GET /set-cookie.php HTTP/1.1" 200 111 "-" "curl/7.61.1"

        Varnish queries the back-end web server for each request because it does not cache the replies that set cookies. 

    From workstation, query the set-cache.php web page through Varnish. The reply from this request includes a Cache-Control header that instructs Varnish to cache the document for 180 seconds rather than the default 120 seconds.

        Use the curl command to query the set-cache.php page. Only wait 120 seconds and then send the request again.

        [student@workstation ~]$ curl http://serverb.lab.example.com/set-cache.php
        <!DOCTYPE html>
        <html lang="en">
          <head>
            <title>Set Cache Expiration</title>
          </head>
          <body>
            Cached for three minutes.
          </body>
        </html>
        [student@workstation ~]$ sleep 120
        [student@workstation ~]$ curl http://serverb.lab.example.com/set-cache.php
        ...output omitted...

        On serverc, notice in the /var/log/httpd/access_log file that only the first request reaches the back-end web server. There is no new entry for the second request.

        ...output omitted...
        172.25.250.11 - - [20/Apr/2020:03:20:30 -0400] "GET /set-cache.php HTTP/1.1" 200 149 "-" "curl/7.61.1"

        Varnish does not send the second request to the back-end web server because it caches the document for 180 seconds.

        Wait for an extra 60 seconds and then send a new request.

        [student@workstation ~]$ sleep 60
        [student@workstation ~]$ curl http://serverb.lab.example.com/set-cache.php
        ...output omitted...

        On serverc, notice in the /var/log/httpd/access_log file that this time Varnish forwards the request to the back-end web server because its copy of the object has now expired.

        ...output omitted...
        172.25.250.11 - - [20/Apr/2020:03:23:45 -0400] "GET /set-cache.php HTTP/1.1" 200 149 "-" "curl/7.61.1"

    Update the Varnish configuration to cache objects for seven days.

        On serverb, edit the /etc/varnish/default.vcl configuration file, locate the vcl_backend_response routine, and then set the beresp.ttl parameter to seven days.

        ...output omitted...
        sub vcl_backend_response {
          if (beresp.ttl == 120s) { 1
            set beresp.ttl = 7d;
          }
        }
        ...output omitted...

        1
        	

        The code only forces the object TTL to seven days when the object has the default TTL of 120 seconds. This test prevents overriding the TTL for replies that explicitly set it with the Cache-Control header.

        Run the varnishd -C -f /etc/varnish/default.vcl command to verify the syntax of the file. The command returns 0 when the syntax is correct.

        [root@serverb ~]# varnishd -C -f /etc/varnish/default.vcl
        ...output omitted...
        [root@serverb ~]# echo $?
        0

        If the command reports any errors, correct them before proceeding.

        Restart the varnish service.

        [root@serverb ~]# systemctl restart varnish

        To verify your work, query the static.html web page from workstation and then wait for 120 seconds. Query the page again.

        [student@workstation ~]$ curl http://serverb.lab.example.com/static.html
        This is serverc
        [student@workstation ~]$ sleep 120
        [student@workstation ~]$ curl http://serverb.lab.example.com/static.html
        This is serverc

        For the first request, notice the new log message in the /var/log/httpd/access_log file on serverc.

        ...output omitted...
        172.25.250.11 - - [20/Apr/2020:04:19:26 -0400] "GET /static.html HTTP/1.1" 200 16 "-" "curl/7.61.1"

        There is no new entry for the second request. This is because the object TTL is now seven days and therefore Varnish returns the document from its cache. 

    Because you now keep objects in the cache for a long time, enable the HTTP PURGE request method. With that configuration, a web application can send purge requests when it needs to refresh documents.

        On serverb, edit the /etc/varnish/default.vcl configuration file and locate the vcl_recv routine. Add an acl purge section before the routine and then edit the vcl_recv routine.

        ...output omitted...
        acl purge {
          "localhost";
          "172.25.250.12"; # serverc
        }

        sub vcl_recv {
          if (req.method == "PURGE") {
            if (!client.ip ~ purge) {
              return(synth(405,"Not allowed."));
            }
            return (purge);
          }
        }
        ...output omitted...

        With this configuration, Varnish only accepts purge requests from localhost and serverc.

        Run the varnishd -C -f /etc/varnish/default.vcl command to verify the syntax of the file. The command returns 0 when the syntax is correct.

        [root@serverb ~]# varnishd -C -f /etc/varnish/default.vcl
        ...output omitted...
        [root@serverb ~]# echo $?
        0

        If the command reports any errors, correct them before proceeding.

        Restart the varnish service.

        [root@serverb ~]# systemctl restart varnish

        To verify your work, you first need to load an object into Varnish so that you can purge it in a following step. To do so, use the curl command from workstation to query the serverb.lab.example.com/static.html object.

        [student@workstation ~]$ curl http://serverb.lab.example.com/static.html
        This is serverc

        Notice the new log message in the /var/log/httpd/access_log file on serverc.

        ...output omitted...
        172.25.250.11 - - [20/Apr/2020:04:55:12 -0400] "GET /static.html HTTP/1.1" 200 16 "-" "curl/7.61.1"

        Varnish queries the document from the back-end web server and stores it in its cache.

        Confirm that you cannot send purge requests from workstation. From workstation, try to send a purge request to remove the object from the cache. Specify the host part of the object with a Host header.

        [student@workstation ~]$ curl --header "Host: serverb.lab.example.com" \
        > -X PURGE http://serverb.lab.example.com/static.html
        <!DOCTYPE html>
        <html>
          <head>
            <title>405 Not allowed.</title>
          </head>
        ...output omitted...

        That request fails because your Varnish configuration does not allow purge requests from workstation.

        From serverb, run the same purge request through localhost.

        [root@serverb ~]# curl --header "Host: serverb.lab.example.com" \
        > -X PURGE http://localhost/static.html
        <!DOCTYPE html>
        <html>
          <head>
            <title>200 Purged</title>
          </head>
        ...output omitted...

        Remember that it is Varnish that processes the HTTP PURGE requests. Those requests are not for the back-end web server and never reach it. Therefore, the /var/log/httpd/access_log file on serverc never reports such requests.

        To confirm that the object is no longer in the cache, perform a new query from workstation.

        [student@workstation ~]$ curl http://serverb.lab.example.com/static.html
        This is serverc

        Notice the new log message in the /var/log/httpd/access_log file on serverc.

        ...output omitted...
        172.25.250.11 - - [20/Apr/2020:05:14:19 -0400] "GET /static.html HTTP/1.1" 200 16 "-" "curl/7.61.1"

        Varnish queries the document from the back-end web server because it is no longer available from its cache. 

Finish