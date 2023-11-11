"Listing Service Units" systemctl list-units --type=service

The systemctl list-units command displays units that the systemd 
service attempts to parse and load into memory; it does not display installed, 
but not enabled, services. To see the state of all unit files installed, 
use the systemctl list-unit-files command. For example:

[root@host ~]# systemctl list-unit-files --type=service
UNIT FILE                                   STATE
arp-ethers.service                          disabled
atd.service                                 enabled
auditd.service                              enabled
auth-rpcgss-module.service                  static
autovt@.service                             enabled
blk-availability.service                    disabled
...output omitted...


"How to see the system-status": systemctl status sshd.service

"List all service units installed on servera.": systemctl list-units --type=service


"List all socket units, active and inactive, on servera.": systemctl list-units --type=socket --al

"List the enabled or disabled states of all service units.": systemctl list-unit-files --type=service 

"how to start a system": systemctl start sshd.service 

"how to stop them": systemctl stop sshd 

" how to restart": systemctl restart sshd.service

"Some services have the ability to reload their configuration files without requiring a restart.": systemctl reload sshd.service

"In case you are not sure whether the service has the functionality to reload the configuration file 
changes, use the reload-or-restart argument with the systemctl command. ": systemctl reload-or-restart sshd.service


"The systemctl list-dependencies UNIT command displays a hierarchy 
mapping of dependencies to start the service unit. 
To list reverse dependencies (units that depend on the specified unit), 
use the --reverse option with the command."

[root@host ~] systemctl list-dependencies sshd.service
sshd.service
● ├─system.slice
● ├─sshd-keygen.target
● │ ├─sshd-keygen@ecdsa.service
● │ ├─sshd-keygen@ed25519.service
● │ └─sshd-keygen@rsa.service
● └─sysinit.target
...output omitted...

## Masking and unmasking##
"Masking and Unmasking Services
At times, a system may have different services installed that are conflicting with each other. 
For example, there are multiple methods to manage mail servers (postfix and sendmail, for example).
Masking a service prevents an administrator from accidentally starting a service that conflicts with others. 
Masking creates a link in the configuration directories to the /dev/null file which prevents the service from starting."

[root@host ~]# systemctl mask sendmail.service
Created symlink /etc/systemd/system/sendmail.service → /dev/null.
## Enabling Services
"Enabling services at start or stop at boot:

: Creating links in the systemd configuration directories enables the service to start at boot. 
The systemctl commands creates and removes these links.

To start a service at boot, use the systemctl enable command."

[root@root ~]# systemctl enable sshd.service
Created symlink /etc/systemd/system/multi-user.target.wants/sshd.service → /usr/lib/systemd/system/sshd.service.


#### important #### 



"Creating links in the systemd configuration directories enables the service to start at boot. 
The systemctl commands creates and removes these links.

To start a service at boot, use the systemctl enable command.
"
[root@root ~] systemctl enable sshd.service
Created symlink /etc/systemd/system/multi-user.target.wants/sshd.service → /usr/lib/systemd/system/sshd.service.


"The above command creates a symbolic link from the service unit file, 
usually in the /usr/lib/systemd/system directory, to the location on disk where systemd 
looks for files, which is in the /etc/systemd/system/TARGETNAME.target.wants directory. 
Enabling a service does not start the service in the current session. 
To start the service and enable it to start automatically during boot, execute both the systemctl 
start and systemctl enable commands."

[root@root ~] systemctl enable sshd.service
Created symlink /etc/systemd/system/multi-user.target.wants/sshd.service → /usr/lib/systemd/system/sshd.service.

[root@host ~] systemctl disable sshd.service
Removed /etc/systemd/system/multi-user.target.wants/sshd.service.

Summary of systemctl Commands
Services can be started and stopped on a running system and enabled or disabled for an automatic start at boot time.

Table 9.3. Useful Service Management Commands

Task	Command
"View detailed information about a unit state."	systemctl status UNIT
"Stop a service on a running system."	systemctl stop UNIT
"Start a service on a running system."	systemctl start UNIT
"Restart a service on a running system."	systemctl restart UNIT
"Reload the configuration file of a running service."	systemctl reload UNIT
"Completely disable a service from being started, both manually and at boot".	systemctl mask UNIT
"Make a masked service available."	systemctl unmask UNIT
"Configure a service to start at boot time."	systemctl enable UNIT
"Disable a service from starting at boot time."	systemctl disable UNIT
"List units required and wanted by the specified unit." systemctl list-dependencies UNIT

