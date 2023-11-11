1 - Create the document root for the website.

[root@serverc ~]# mkdir -p /srv/serverc/www

2 - In the content root directory, create an index.html file with distinct content.

[root@serverc ~]# scp student@workstation:web-review/serverc/index.html /srv/serverc/www/index.html

3 - Reset the SELinux context on your document root and its files.

4 - [root@serverc ~]# restorecon -Rv /srv/

Set up your virtual host configuration for serverc.lab.example.com.

If you are using Apache HTTP Server, create /etc/httpd/conf.d/serverc.conf with the following content:

'<Directory /srv/serverc/www>
  Require all granted
</Directory>
<VirtualHost *:443>
  ServerName serverc.lab.example.com
  SSLEngine On
  SSLCertificateFile /etc/pki/tls/certs/serverc.lab.example.com.crt
  SSLCertificateKeyFile /etc/pki/tls/private/serverc.lab.example.com.key
  DocumentRoot /srv/serverc/www
</VirtualHost>
<VirtualHost *:80>
  ServerName serverc.lab.example.com
  Redirect "/" "https://serverc.lab.example.com"
</VirtualHost>'





''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
1 - Create the document root for the website.

[root@serverc ~]# mkdir -p /srv/virtual/www

2 - In the contents root directory, create an index.html file with distinct content.

[root@serverc ~]# scp student@workstation:web-review/virtual/index.html /srv/virtual/www/index.html

3 - Reset the SELinux context on your document root and its files.

[root@serverc ~]# restorecon -Rv /srv/

4 - Set up your virtual host configuration for virtual.lab.example.com.

If you are using Apache HTTP Server, create /etc/httpd/conf.d/virtual.conf with the following content. Changes from /etc/httpd/conf.d/serverc.conf are highlighted.

'<Directory /srv/virtual/www>
  Require all granted
</Directory>
<VirtualHost *:443>
  ServerName virtual.lab.example.com
  SSLEngine On
  SSLCertificateFile /etc/pki/tls/certs/virtual.lab.example.com.crt
  SSLCertificateKeyFile /etc/pki/tls/private/virtual.lab.example.com.key
  DocumentRoot /srv/virtual/www
</VirtualHost>
<VirtualHost *:80>
  ServerName virtual.lab.example.com
  Redirect "/" "https://virtual.lab.example.com"
</VirtualHost>'






Copy the TLS certificates and private keys for your virtual hosts from the /home/student/web-review/files directory on workstation to the locations expected by your web server, based on the preceding configuration files.

    Download the certificates for your virtual hosts.

    [root@serverc ~]# cd /etc/pki/tls/certs
    [root@serverc certs]# scp student@workstation:web-review/files/*.crt .

    Switch to the private directory and download the private keys.

    [root@serverc certs]# cd /etc/pki/tls/private
    [root@serverc private]# scp student@workstation:web-review/files/*.key .


 Start your web server and open the relevant firewall ports.

    Open the http and https ports on the firewall.

    [root@serverc private]# firewall-cmd --permanent --add-service=http
    [root@serverc private]# firewall-cmd --permanent --add-service=https
    [root@serverc private]# firewall-cmd --reload

    Start and enable your web server.

    If you are using Apache HTTP Server, run:

    [root@serverc private]# systemctl enable --now httpd

    If you are using Nginx, run: 