'Configuring Apache HTTPD Virtual Hosts'



The following example, /etc/httpd/conf.d/site1.conf, sets up a virtual host for site1.example.com, which listens on the server's 192.168.0.1 IP address.

<Directory /srv/site1/www>1
  Require all granted
  AllowOverride None
</Directory>

<VirtualHost 192.168.0.1:80>2
  DocumentRoot /srv/site1/www3
  ServerName site1.example.com4
  ServerAdmin webmaster@site1.example.com5
  ErrorLog "logs/site1_error_log"6
  CustomLog "logs/site1_access_log" combined7
</VirtualHost>

'
1

This <Directory> block makes sure that Apache can serve content in the virtual hosts DocumentRoot.

2

Starts the virtual host definition. This virtual host can be configured for traffic arriving on port 80/TCP on the address 192.168.0.1.

3

This DocumentRoot setting applies only to this virtual host, and overrides the one in the main configuration file.

4

The name of the web site. If multiple web sites share the same IP address, this setting and the host requested by the clients HTTP request will be used to determine if this virtual host will be used. There must be exactly one ServerName. If a site responds to multiple names (such as www.example.com and example.com), you can add them with ServerAlias directives.

5

You can override any setting from the main configuration file. Different virtual hosts might have different ServerAdmin users.

6

The location for all error messages related to this virtual host. This can make it easier to analyze issues on specific virtual hosts.

7

The location for all access messages regarding this virtual host.



Create a new file called /etc/httpd/conf.d/00-default-vhost.conf with the following content:

<VirtualHost _default_:80>
  DocumentRoot /srv/default/www
  CustomLog "logs/default-vhost.log" combined
</VirtualHost>
Since in its default configuration, httpd blocks access to all directories, open up the content directory for your default vhost. Add the following block inside the VirtualHost directive in /etc/httpd/conf.d/00-default-vhost.conf.

<Directory /srv/default/www>
  Require all granted
</Directory>
Create a new virtual host definition for a www-x.lab.example.com virtual host in /etc/httpd/conf.d/01-www-x.lab.example.com-vhost.conf. This virtual host must respond to requests for both www-x.lab.example.com and www-x, serve content from /srv/www-x.lab.example.com/www, and store logs in logs/www-x.lab.example.com.log.

Create the file /etc/httpd/conf.d/01-www-x.lab.example.com-vhost.conf with the following contents:

<VirtualHost *:80>
  ServerName www-x.lab.example.com
  ServerAlias www-x
  DocumentRoot /srv/www-x.lab.example.com/www
  CustomLog "logs/www-x.lab.example.com.log" combined
  <Directory /srv/www-x.lab.example.com/www>
    Require all granted
  </Directory>
</VirtualHost>