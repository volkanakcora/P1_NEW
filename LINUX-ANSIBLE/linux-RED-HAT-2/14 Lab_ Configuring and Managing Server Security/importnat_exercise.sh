1- HOW TO CHANGE DEFAULT SELINUX MODE: 

'Edit /etc/sysconfig/selinux to set the value of the parameter SELINUX to permissive. You can use the sudo vi /etc/sysconfig/selinux 
command to edit the configuration file as the superuser. Use the password student, if prompted.'

...output omitted...
#SELINUX=enforcing
SELINUX=permissive
...output omitted...
Use the sudo systemctl reboot command to reboot the system as the superuser.

[student@servera ~]$ sudo systemctl reboot
Connection to servera closed by remote host.
Connection to servera closed.
[student@serverb ~]$ 


####################################################################################################################

2 - 'Configure serverb to automatically mount the home directory of the production5 user when the user logs in, using the network 
file system '/home-directories/production5'. This network file system is exported from servera.lab.example.com. Adjust the appropriate 
SELinux Boolean so that production5 can use the NFS-mounted home directory on serverb after authenticating via SSH key-based 
authentication. The production5 users password is redhat.'


'On serverb, use the sudo -i command to switch to the root user account.
'
[student@serverb ~]$ sudo -i
[sudo] password for student: student
[root@serverb ~]# 
Install the autofs package.


[root@serverb ~]# yum install autofs
...output omitted...
Is this ok [y/N]: y
...output omitted...
Installed:
  autofs-1:5.1.4-29.el8.x86_64

Complete!

'Create the autofs master map file called '/etc/auto.master.d/production5.autofs' with the following content.
'
/- /etc/auto.production5


'Retrieve the details of the production5 user to get the home directory path.
'
[root@serverb ~]# getent passwd production5
production5:x:5001:5001::/localhome/production5:/bin/bash


'Create the /etc/auto.production5 file with the following content.
'
/localhome/production5 -rw servera.lab.example.com:/home-directories/production5
Restart the autofs service.

[root@serverb ~]# systemctl restart autofs

####################################################################################################################

'Set the appropriate SELinux Boolean setting on serverb, so that production5 can log in to serverb using the SSH public key-based authentication and use the home directory.'

'On serverb as root, set the use_nfs_home_dirs SELinux Boolean to true.
'
[root@serverb ~]# setsebool -P use_nfs_home_dirs true



'Use the SSH public key-based authentication instead of password-based authentication to log in to serverb as production5. 
This command should succeed.'

[production5@servera ~]$ ssh -o pubkeyauthentication=yes \
-o passwordauthentication=no production5@serverb
...output omitted...
[production5@serverb ~]$ 




####################################################################################################################

'On serverb, adjust the firewall settings so that SSH connections originating from servera are rejected. 
The servera system uses the IPv4 address 172.25.250.10.'

'Use the firewall-cmd command to add the IPv4 address of servera to the firewalld zone called block.
'
[root@serverb ~]# firewall-cmd --add-source=172.25.250.10/32 \
--zone=block --permanent
success


'Use the firewall-cmd --reload command to reload the changes in the firewall settings.
'
[root@serverb ~]# firewall-cmd --reload
success


####################################################################################################################

O'n serverb, investigate and fix the issue with the Apache HTTPD daemon, which is configured to listen on port 30080/TCP, 
but which fails to start. 
Adjust the firewall settings appropriately so that port 30080/TCP is open for incoming connections.'

[root@serverb ~]# systemctl restart httpd.service
Job for httpd.service failed because the control process exited with error code.
See "systemctl status httpd.service" and "journalctl -xe" for details.



[root@serverb ~]# sealert -a /var/log/audit/audit.log
SELinux is preventing /usr/sbin/httpd from name_bind access on the tcp_socket port 30080.


'Use the semanage port command to set the appropriate SELinux context on the port 30080/TCP for httpd to bind to it.'
[root@serverb ~]# semanage port -a -t http_port_t -p tcp 30080

[root@serverb ~]# systemctl restart httpd

'Add the port 30080/TCP to the default firewalld zone called public.
'
[root@serverb ~]# firewall-cmd --add-port=30080/tcp --permanent
success
[root@serverb ~]# firewall-cmd --reload
success

####################################################################################################################
####################################################################################################################
####################################################################################################################



