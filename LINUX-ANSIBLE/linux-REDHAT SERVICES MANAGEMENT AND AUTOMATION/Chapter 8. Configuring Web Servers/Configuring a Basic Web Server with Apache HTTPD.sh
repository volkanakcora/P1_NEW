Installing Apache HTTP Server


[root@host ~]# yum install httpd

'Alternatively, you can install a specific profile of that module stream. The httpd module supports three profiles:
'
common: 'provides a production-ready deployment (the default)'

minimal: 'provides the smallest set of packages that can run an Apache web server'

devel: 'provides packages needed to modify httpd'

[root@host ~]# yum module install httpd:2.4/common


!!! 'One of the dependencies of the httpd package is httpd-tools. This package includes management tools to manipulate Apache password maps and databases, resolve IP addresses in Apache's log files as host names, and to benchmark and stress-test web servers.

The httpd-manual package installs the documentation for Apache HTTP Server on your web server at http://localhost/manual.



                                'Configuring Apache HTTP Server'


'Apache HTTP Server reads its configuration from:'

/etc/httpd/conf/httpd.conf, 'the main configuration file.'

/etc/httpd/conf.d/, 'which provides supplementary configuration files which are included in httpd.conf if the file name ends with .conf.'

/etc/httpd/conf.modules.d/, 'which provides supplementary configuration files used to dynamically load Apache modules, if the file name ends with .conf.'


