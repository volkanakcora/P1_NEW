'You use the systemctl command to explore the current state of the system.'

#systemctl list-units --type=service --all

'To see the state of all unit files installed, use the systemctl list-unit-files command.'

#systemctl list-unit-files --type=service


'how to view service state' 

#systemctl status sshd.service


'Loaded'	Whether the service unit is loaded into memory.
'Active'	Whether the service unit is running and if so, how long it has been running.
'Main PID'	The main process ID of the service, including the command name.
'Status'	Additional information about the service.


'Service States in the Output of systemctl'

'loaded'	Unit configuration file has been processed.
'active (running)'	Running with one or more continuing processes.
'active (exited)'	Successfully completed a one-time configuration.
'active (waiting)'	Running but waiting for an event.
'inactive'	Not running.
'enabled'	Is started at boot time.
'disabled'	Is not set to be started at boot time.
'static'	Cannot be enabled, but may be started by an enabled unit automatically.



How to check the status:

# systemctl is-enablem sshd.service 

# systemctl is-failed  sshd.service 



'Starting and stopping'

[root@host ~]# systemctl start sshd.service

[root@host ~]# systemctl stop sshd.service

[root@host ~]# systemctl restart sshd.service

[root@host ~]# systemctl reload sshd.service


'In case you are not sure whether the service has the functionality to reload'

[root@host ~]# systemctl reload-or-restart sshd.service

'Listing-UNIT-DEP'

[root@host ~]# systemctl list-dependencies sshd.service



###  Masking and Unmasking Services #### 
'
Masking a service prevents an administrator from accidentally starting a 
service that conflicts with others. Masking creates a link in the configuration 
directories to the /dev/null file which prevents the service from starting.'


#systemctl mask sendmail.service
Created symlink /etc/systemd/system/sendmail.service → /dev/null.


#systemctl start sendmail.service
Failed to start sendmail.service: Unit sendmail.service is masked.

