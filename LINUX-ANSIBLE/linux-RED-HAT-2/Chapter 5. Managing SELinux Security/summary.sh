'Changing the SELinux Enforcement Mode
'

SELinux has three modes:

Enforcing: 'SELinux is enforcing access control rules. Computers generally run in this mode.'

Permissive: 'SELinux is active but instead of enforcing access control rules, it records warnings of rules that have been violated. This mode is used primarily for testing and troubleshooting.'

Disabled: 'SELinux is turned off entirely: no SELinux violations are denied, nor even recorded. Discouraged!'



'The type context for a web server is httpd_t. The type context for files and directories normally found in /var/www/html is httpd_sys_content_t.
The contexts for files and directories normally found in /tmp and /var/tmp is tmp_t. The type context for web server ports is http_port_t.'

'Many commands that deal with files use the -Z option to display or set SELinux contexts. For instance, ps, ls, cp, and mkdir all use the -Z option to display or set SELinux contexts.
'
'HOW TO SEE SELINUX CONTEXT':

[root@host ~]# ps axZ
LABEL                             PID TTY      STAT   TIME COMMAND
system_u:system_r:init_t:s0         1 ?        Ss     0:09 /usr/lib/systemd/...
system_u:system_r:kernel_t:s0       2 ?        S      0:00 [kthreadd]
system_u:system_r:kernel_t:s0       3 ?        S      0:00 [ksoftirqd/0]
...output omitted...
[root@host ~]# systemctl start httpd
[root@host ~]# ps -ZC httpd
LABEL                             PID TTY          TIME CMD
system_u:system_r:httpd_t:s0     1608 ?        00:00:05 httpd
system_u:system_r:httpd_t:s0     1609 ?        00:00:00 httpd
...output omitted...
[root@host ~]# ls -Z /home
drwx------. root    root    system_u:object_r:lost_found_t:s0 lost+found
drwx------. student student unconfined_u:object_r:user_home_dir_t:s0 student
drwx------. visitor visitor unconfined_u:object_r:user_home_dir_t:s0 visitor
[root@host ~]# ls -Z /var/www
drwxr-xr-x. root root system_u:object_r:httpd_sys_script_exec_t:s0 cgi-bin
drwxr-xr-x. root root system_u:object_r:httpd_sys_content_t:s0 error
drwxr-xr-x. root root system_u:object_r:httpd_sys_content_t:s0 html
drwxr-xr-x. root root system_u:object_r:httpd_sys_content_t:s0 icons


'Changing the current SELinux mode'

The SELinux subsystem provides tools to display and change modes. To determine the current SELinux mode, run the getenforce command. To set SELinux to a different mode, use the setenforce command:

[user@host ~]# getenforce
Enforcing
[user@host ~]# setenforce
usage:  setenforce [ Enforcing | Permissive | 1 | 0 ]
[user@host ~]# setenforce 0
[user@host ~]# getenforce
Permissive
[user@host ~]# setenforce Enforcing
[user@host ~]# getenforce
Enforcing


'SELinux mode at boot time by passing a parameter to the kernel: the kernel argument of 'enforcing=0' boots the system into permissive mode; 
a value of 'enforcing=1' sets enforcing mode. You can also disable SELinux completely by passing on the kernel parameter selinux=0. 
A value of 'selinux=1' enables SELinux.'


'''''''''''''''''''''''''''Setting the default SELinux mode
'''''''''''''''''''''''''''

You can also configure SELinux persistently using the '/etc/selinux/config' file.

# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=enforcing
# SELINUXTYPE= can take one of these two values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes
#               are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted


'''''''''''''''''''''''''''''Controlling SELinux File Contexts''' 
''''''''''''''''''''''''''
when you move the file, it retains the file context for the /tmp directory. if oyu copy, it takes context from destination.
'Note that the /var/www/html/index.html has the same label as the parent directory /var/www/html/. Now, create files outside of the /var/www/html directory and note their file context:
'
[root@host ~]# touch /tmp/file1 /tmp/file2
[root@host ~]# ls -Z /tmp/file*
unconfined_u:object_r:user_tmp_t:s0 /tmp/file1
unconfined_u:object_r:user_tmp_t:s0 /tmp/file2

'Move one of these files to the /var/www/html directory, copy another, and note the label of each:
'
[root@host ~]# mv /tmp/file1 /var/www/html/
[root@host ~]# cp /tmp/file2 /var/www/html/
[root@host ~]# ls -Z /var/www/html/file*
unconfined_u:object_r:user_tmp_t:s0 /var/www/html/file1
unconfined_u:object_r:httpd_sys_content_t:s0 /var/www/html/file2  


'''''''''''''''''''''''''''''''''''Changing the SELinux context of a file''''''
'''''''''''''''''''''''''''''

'Commands to change the SELinux context on files include 'semanage fcontext', 'restorecon', and 'chcon'.


'

'The following screen shows a directory being created. The directory has a type value of default_t.
'
[root@host ~]# mkdir /virtual
[root@host ~]# ls -Zd /virtual
drwxr-xr-x. root root unconfined_u:object_r:default_t:s0 /virtual

'The chcon command changes the file context of the /virtual directory: the type value changes to httpd_sys_content_t.
'
[root@host ~]# chcon -t httpd_sys_content_t /virtual
[root@host ~]# ls -Zd /virtual
drwxr-xr-x. root root unconfined_u:object_r:httpd_sys_content_t:s0 /virtual 

'The restorecon command runs and the type value returns to the value of default_t. Note the Relabeled message.
'
[root@host ~]# restorecon -v /virtual
Relabeled /virtual from unconfined_u:object_r:httpd_sys_content_t:s0 to unconfined_u:object_r:default_t:s0
[root@host ~]# ls -Zd /virtual
drwxr-xr-x. root root unconfined_u:object_r:default_t:s0 /virtual


'''''''''''''''''''''''''''''''''Defining SELinux Default File Context Rules'''
''''''''''''''''''''''''''''''
'Basic File Context Operations
'
The following table is a reference for semanage fcontext options to add, remove or list SELinux file contexts.

Table 5.1. semanage fcontext commands

#option	description

-a, --add	'Add a record of the specified object type'
-d, --delete	'Delete a record of the specified object type'
-l, --list 'List records of the specified object type'


root@servera ~]# semanage fcontext -a -t httpd_sys_content_t '/custom(/.*)?'

[root@host; ~]# restorecon -Rv /var/www/
Relabeled /var/www/html/file1 from unconfined_u:object_r:user_tmp_t:s0 to unconfined_u:object_r:httpd_sys_content_t:s0
[root@host ~]# ls -Z /var/www/html/file*
unconfined_u:object_r:httpd_sys_content_t:s0 /var/www/html/file1  unconfined_u:object_r:httpd_sys_content_t:s0 /var/www/html/file2


'''''''Adjusting SELinux Policy with Boolean'''''''''''''

getsebool 'which lists booleans and their state'

setsebool 'which modifies booleans.'

setsebool -P 'modifies the SELinux policy to make the modification persistent'

semanage boolean -l 'reports on whether or not a boolean is persistent, along with a short description of the boolean.'



[user@host ~]# getsebool -a
abrt_anon_write --> off
abrt_handle_event --> off
abrt_upload_watch_anon_write --> on
antivirus_can_scan_system --> off
antivirus_use_jit --> off
...output omitted...

[user@host ~]# getsebool httpd_enable_homedirs
httpd_enable_homedirs --> off


[user@host ~]# setsebool httpd_enable_homedirs on
Could not change active booleans. Please try as root: Permission denied
[user@host ~]# sudo setsebool httpd_enable_homedirs on
[user@host ~]# sudo semanage boolean -l | grep httpd_enable_homedirs
httpd_enable_homedirs          (on   ,  off)  Allow httpd to enable homedirs
[user@host ~]# getsebool httpd_enable_homedirs
httpd_enable_homedirs --> on


The -P option writes all pending values to the policy, making them persistent across reboots.


[user@host ~]# setsebool -P httpd_enable_homedirs on
[user@host ~]# sudo semanage boolean -l | grep httpd_enable_homedirs
httpd_enable_homedirs          (on   ,   on)  Allow httpd to enable homedirs 


'''Investigating and Resolving SELinux IssUES'''---------------------------------------------------

'''
Monitoring SELinux Violations
Install the setroubleshoot-server package to send SELinux messages to /var/log/messages. 
setroubleshoot-server listens for audit messages in /var/log/audit/audit.log'''

'The 'sealert -l UUID' command is used to produce a report for a specific incident.'

'Use 'sealert -a /var/log/audit/audit.log' to produce reports for all incidents in that file.'



'Consider the following sample sequence of commands on a standard Apache web server:
'
[root@host ~]# touch /root/file3
[root@host ~]# mv /root/file3 /var/www/html
[root@host ~]# systemctl start httpd
[root@host ~]# curl http://localhost/file3
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>403 Forbidden</title>
</head><body>
<h1>Forbidden</h1>
<p>You dont have permission to access /file3
on this server.</p>
</body></html>

'You expect the web server to deliver the contents of file3 but instead it returns a permission denied error. Inspecting both 
/var/log/audit/audit.log and /var/log/messages reveals extra information about this error.'

[root@host ~]# tail /var/log/audit/audit.log
...output omitted...
type=AVC msg=audit(1392944135.482:429): avc:  denied  { getattr } for
  pid=1609 comm="httpd" path="/var/www/html/file3" dev="vda1" ino=8980981
  scontext=system_u:system_r:httpd_t:s0
  tcontext=unconfined_u:object_r:admin_home_t:s0 tclass=file
...output omitted...
[root@host ~]# tail /var/log/messages
...output omitted...
Feb 20 19:55:42 host setroubleshoot: SELinux is preventing /usr/sbin/httpd
  from getattr access on the file . For complete SELinux messages. run
  sealert -l 613ca624-248d-48a2-a7d9-d28f5bbe2763


'Both log files indicate that an SELinux denial is the culprit. The sealert command that is part of the output 
in /var/log/messages provides extra information, including a possible fix.'

[root@host ~]# sealert -l 613ca624-248d-48a2-a7d9-d28f5bbe2763

'
The Raw Audit Messages section of the sealert command contains information from the '/var/log/audit/audit.log'. 
Use the ausearch command to search the '/var/log/audit/audit.log file'. The '-m option' searches on the message type. 
'The -ts option' searches based on time. This entry identifies the relevant process and file causing the alert. 
The process is the httpd Apache web server, 'the file is /custom/index.html', and the context is system_r:httpd_t.'

[root@servera ~]# ausearch -m AVC -ts recent

--> find the error and try to solve&fix it by :

[root@servera ~]# semanage fcontext -a -t httpd_sys_content_t '/custom(/.*)?'
[root@servera ~]# restorecon -Rv /custom
Relabeled /custom from unconfined_u:object_r:default_t:s0 to unconfined_u:object_r:httpd_sys_content_t:s0
Relabeled /custom/index.html from unconfined_u:object_r:default_t:s0 to unconfined_u:object_r:httpd_sys_content_t:s0