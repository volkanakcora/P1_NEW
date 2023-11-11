The following example demonstrates how to copy the local /etc/yum.conf 
and /etc/hosts files on host, to the remoteusers home directory on the remotehost remote system:

[user@host ~]$ scp /etc/yum.conf /etc/hosts remoteuser@remotehost:/home/remoteuser

######## remote - to - host

You can also copy a file in the other direction, from a remote system to the local file system. 
In this example, the file /etc/hostname on remotehost is copyed to the local directory /home/user. 
The scp command authenticates to remotehost as the user remoteuser.

[user@host ~]$ scp remoteuser@remotehost:/etc/hostname /home/user
remoteuser@remotehosts password: password

########## To copy a whole directory tree recursively, use the -r option

[user@host ~]$ scp -r root@remoteuser:/var/log /tmp

#### Transferring Files Using the Secure File Transfer Program

[user@host ~]$ sftp remoteuser@remotehost
remoteuser@remotehost's password: password
Connected to remotehost.
sftp> 

The interactive sftp session accepts various commands that work the 
same way on the remote file system as they do in the local file system, 
such as ls, cd, mkdir, rmdir, and pwd. The put command uploads a file to the remote system. 
The get command downloads a file from the remote system. The exit command exits the sftp session.

To upload the /etc/hosts file on the local system to the newly created directory /home/remoteuser/hostbackup 
on remotehost. The sftp session always assumes that the put command is followed by a file on the local file 
system and starts in the connecting user's home directory; in this case, /home/remoteuser:

sftp> mkdir hostbackup
sftp> cd hostbackup
sftp> put /etc/hosts
Uploading /etc/hosts to /home/remoteuser/hostbackup/hosts
/etc/hosts                                 100%  227     0.2KB/s   00:00
sftp> 


To download /etc/yum.conf from the remote host to the current directory on the local system, 
execute the command get /etc/yum.conf and exit the sftp session with the exit command.

sftp> get /etc/yum.conf
Fetching /etc/yum.conf to yum.conf
/etc/yum.conf                              100%  813     0.8KB/s   00:00
sftp> exit