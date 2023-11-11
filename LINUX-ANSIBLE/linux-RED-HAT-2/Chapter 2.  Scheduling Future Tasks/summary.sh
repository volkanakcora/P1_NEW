'To inspect the actual commands that will run when a job is executed, use the at -c JOBNUMBER command. 
This command shows the environment for the job being set up to reflect the environment of 
the user who created the job at the time it was created, followed by the actual commands to be run.'

atq 

example 

'Schedule a job to run in three minutes from now using the at command. The job must save the output of the date command to /home/student/myjob.txt.
'

[student@servera ~]# echo "date >> /home/student/myjob.txt" | at now +3min

To observer it: 

[student@servera ~]# atq 



'now +5min

teatime tomorrow (teatime is 16:00)

noon +4 days

5pm august 3 2021'

### CRONJOB 

crontab -l	
'List the jobs for the current user.
'
crontab -r	
'Remove all jobs for the current user.
'
crontab -e	
'Edit jobs for the current user.
'
crontab filename	
'Remove all jobs, and replace with the jobs read from filename. If no file is specified, stdin is used.
'

'Fields in the crontab file appear in the following order:
'
Minutes

Hours

Day of month

Month

Day of week

Command


'to run a command on the 15th of every month, and every Friday at 12:15:
'
15 12 15 * Fri 



x,y for lists. Lists can include ranges as well, 'for example, 5,10-13,17 in the Minutes column to indicate that a job should run at 5, 10, 11, 12, 13,' 

*/x to indicate an interval of x, for example, */7 in the Minutes column runs a job every seven minutes.
'

#### EXAMPLE RECURRING USER JOBS 

'The following job executes the command /usr/local/bin/yearly_backup at exactly 9 a.m. on February 2nd, every year.
'
0 9 2 2 * /usr/local/bin/yearly_backup


'The following job sends an email containing the word Chime to the owner of this job, every five minutes between 9 a.m. and 5 p.m., on every Friday in July.
'
*/5 9-16 * Jul 5 echo "Chime"

'The following job runs the command /usr/local/bin/daily_report every weekday at two minutes before midnight.
'
58 23 * * 1-5 /usr/local/bin/daily_report

'The following job executes the mutt command to send the mail message Checking in to the recipient boss@example.com on every workday (Monday to Friday), at 9 a.m.
'
0 9 * * 1-5 mutt -s "Checking in" boss@example.com % Hi there boss, just checking in.



##important ###always create your custom crontab files under the /etc/cron.d directory to schedule recurring system jobs### 


### Introducing Systemd Timer

'Sample Timer Unit

The sysstat package provides a systemd timer unit called sysstat-collect.timer to collect system statistics every 10 minutes. 
The following output shows the configuration lines of /usr/lib/systemd/system/sysstat-collect.timer.
'
...output omitted...
[Unit]
Description=Run system activity accounting tool every 10 minutes

[Timer]
OnCalendar=*:00/10

[Install]
WantedBy=sysstat.service
'

For example, a value of 2019-03-* 12:35,37,39:16 against the OnCalendar parameter causes the timer unit to activate the corresponding service unit 
at 12:35:16, 12:37:16, and 12:39:16 every day throughout the entire month of March, 2019. 
You can also specify relative timers using parameters such as OnUnitActiveSec.'

########################################  Managing Temporary Files ##############################################

#systemd-tmpfiles --create --remove.

'This command reads configuration files from '/usr/lib/tmpfiles.d/*.conf', '/run/tmpfiles.d/*.conf', and '/etc/tmpfiles.d/*.conf'.'



'The systemd timer unit configuration files have a [Timer] section that indicates how often the service with the same name should be started.

Use the following systemctl command to view the contents of the systemd-tmpfiles-clean.timer unit configuration file.
'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
[user@host ~]$ systemctl cat systemd-tmpfiles-clean.timer
# /usr/lib/systemd/system/systemd-tmpfiles-clean.timer
#  SPDX-License-Identifier: LGPL-2.1+
#
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published
#  by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.

[Unit]
Description=Daily Cleanup of Temporary Directories
Documentation=man:tmpfiles.d(5) man:systemd-tmpfiles(8)

[Timer]
OnBootSec=15min
OnUnitActiveSec=1d
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


OnBootSec=15min 'indicates that the service unit called systemd-tmpfiles-clean.service gets triggered 15 minutes after the system has booted up. 
The parameter 'OnUnitActiveSec=1d' indicates that any further trigger to the 
systemd-tmpfiles-clean.service service unit happens 24 hours after the service unit was activated last. or put it 30m and it get triggered every 
30 minutes'

'!! after changing any parameters, please run systemctl daemon-reload

After you reload the systemd manager configuration, use the following systemctl command to activate the systemd-tmpfiles-clean.timer unit.'

[root@host ~]# systemctl enable --now systemd-tmpfiles-clean.timer

###EXAMPLE: 

'Configure your system so that it uses a new directory called /run/volatile to store temporary files. Files in this directory should be 
subject to time based cleanup if they are not accessed for more than 30 seconds. The octal permissions for the directory must be 0700. 
Make sure that you use the /etc/tmpfiles.d/volatile.conf file to configure the time based cleanup for the files in /run/volatile.'

Create a file called /etc/tmpfiles.d/volatile.conf with the following content.d

d /run/volatile 0700 root root 30s
Use the systemd-tmpfiles --create command to create the /run/volatile directory if it does not exist.

[root@servera ~]# systemd-tmpfiles --create /etc/tmpfiles.d/volatile.conf

########'CLEANING FILES MANUALLY'

'The following are some examples with explanations.
'
#  d /run/systemd/seats 0755 root root -

"When creating files and directories, create the /run/systemd/seats directory if it does not yet exist, owned by the user root and the group root, 
with permissions set to rwxr-xr-x. This directory will not be automatically purged."

#  D /home/student 0700 student student 1d

'Create the /home/student directory if it does not yet exist. If it does exist, empty it of all contents. When systemd-tmpfiles --clean is run, 
remove all files which have not been accessed, changed, or modified in more than one day.
'
#  L /run/fstablink - root root - /etc/fstab

'Create the symbolic link /run/fstablink pointing to /etc/fstab. Never automatically purge this line.'

'Configuration File Precedence
'
'Configuration files can exist in three places:
'
/etc/tmpfiles.d/*.conf

/run/tmpfiles.d/*.conf

/usr/lib/tmpfiles.d/*.conf


'The files in /usr/lib/tmpfiles.d/ are provided by the relevant RPM packages, and you should not edit these files.

The files under /etc/tmpfiles.d/ are meant for administrators to configure custom temporary locations, and to override vendor-provided defaults.'

'If a file in /run/tmpfiles.d/ has the same file name as a file in /usr/lib/tmpfiles.d/, then the file in /run/tmpfiles.d/ is used. If a file in
 /etc/tmpfiles.d/ has the same file name as a file in either /run/tmpfiles.d/
 or /usr/lib/tmpfiles.d/, then the file in /etc/tmpfiles.d/ is used.'


d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_ctpa 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_ctpd 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_ctpc 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_ctpd 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_ctpe 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_ctpf 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_ctpg 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_ctph 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_ctpi 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_ctpj 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_ctso 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_cute 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_lipa 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_lipb 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_ctpk 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_ctpl 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_test 0700 root root 30d



d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_ctpa 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_ctpd 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_ctpc 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_ctpd 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_ctpe 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_ctpf 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_ctpg 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_ctph 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_ctpi 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_ctpj 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_ctso 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_cute 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_lipa 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_lipb 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_ctpk 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_ctpl 0700 root root 30d
d /net/energynfsdev.srv.energy/xbtestdbdump/journals/xbid_test 0700 root root 30d






#########################################  MANAGING TEMPORARY FILES EXAMPLE


'Copy /usr/lib/tmpfiles.d/tmp.conf to /etc/tmpfiles.d/tmp.conf.
'
[root@servera ~]# cp /usr/lib/tmpfiles.d/tmp.conf /etc/tmpfiles.d/tmp.conf  


'CONFIG FILE SHOULD REMOVE FILES AGE OF 5 DAYS( WHICH HAVE NOT BEEN USED)'

'command to edit the configuration file. The /etc/tmpfiles.d/tmp.conf file should appear as follows:
'

#q /tmp 1777 root root 5d


'Use the systemd-tmpfiles --clean command to verify that the /etc/tmpfiles.d/tmp.conf file contains the correct configuration.
'
[root@servera ~]# systemd-tmpfiles --clean /etc/tmpfiles.d/tmp.conf




''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'Add a new configuration that ensures that the /run/momentary directory exists with user and group ownership set to root. 
The octal permissions for the directory must be 0700.
The configuration should purge any file in this directory that remains unused in the last 30 seconds.'

'Create the file called /etc/tmpfiles.d/momentary.conf with the following content. You can use the vim /etc/tmpfiles.d/momentary.conf 
command to create the configuration file.
'
d /run/momentary 0700 root root 30s  




'Use the systemd-tmpfiles --create command to verify that the /etc/tmpfiles.d/momentary.conf file contains the appropriate configuration. 
The command creates the /run/momentary directory if it does not exist.'

[root@servera ~]# systemd-tmpfiles --create   /etc/tmpfiles.d/momentary.conf  


FROM NOW ON ALL FILES OLDER THAN 30 SEC WILL BE REMOVED FROM DIRECTORY SPECIFIED IN /MONETORY.CONF FILE 


