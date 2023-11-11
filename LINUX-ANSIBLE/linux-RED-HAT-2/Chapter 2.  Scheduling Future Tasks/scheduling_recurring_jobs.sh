'Create a script file called /etc/cron.daily/usercount with the following content. 
You can use the vi /etc/cron.daily/usercount command to create the script file.'

#!/bin/bash
USERCOUNT=$(w -h | wc -l)
logger "There are currently ${USERCOUNT} active users"
############


'Use the chmod command to enable the execute (x) permission on /etc/cron.daily/usercount.
'
[root@servera ~]# chmod +x /etc/cron.daily/usercount



## yum install sysstat to create recurrence jobs 



'Copy /usr/lib/systemd/system/sysstat-collect.timer to /etc/systemd/system/sysstat-collect.timer.
'
[root@servera ~]# cp /usr/lib/systemd/system/sysstat-collect.timer /etc/systemd/system/sysstat-collect.timer '''(you should not edit files under the /usr/lib/systemd directory.)'''



'EDIT THE FILE YOU COPIED'


'/etc/systemd/system/sysstat-collect.timer command to edit the configuration file.
'
#####################################################
...

#        Activates activity collector every 2 minutes

[Unit]
Description=Run system activity accounting tool every 2 minutes

[Timer]
OnCalendar=*:00/02

[Install]
WantedBy=sysstat.service

#########################################################

'systemctl daemon-reload command to make sure that systemd is aware of the changes.
'
[root@servera ~]# systemctl daemon-reload


'Use the ls -l command to verify that the binary file under the /var/log/sa directory got modified within last two minutes.
'
[root@servera ~]# ls -l /var/log/sa
total 8
-rw-r--r--. 1 root root 5156 Mar 25 12:34 sa25