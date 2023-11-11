Option	Description
-c, --create	
Create a new archive.

-x, --extract	
Extract from an existing archive.

-t, --list	
List the table of contents of an archive.



################################
Table 13.2. Selected tar General Options

Option	Description
-v, --verbose	
Verbose. Shows which files get archived or extracted.

-f, --file=	
File name. This option must be followed by the file name of the archive to use or create.

-p, --preserve-permissions	
Preserve the permissions of files and directories when extracting an archive, without subtracting the umask.



tar -cf archive.tar file1 file2 file3

### ZIP TYPES


Use one of the following options to create a compressed tar archive:

-z or --gzip for gzip compression (filename.tar.gz or filename.tgz)

-j or --bzip2 for bzip2 compression (filename.tar.bz2)

-J or -xz for xz compression (filename.tar.xz)

######## EXTRACTING THE FILES FROM ARCHIVE tar -tf templates.tar
###################

## CREATING 
o create a gzip compressed archive named /root/etcbackup.tar.gz, with the contents from 
the /etc directory on host:

[root@host ~]# tar -czf /root/etcbackup.tar.gz /etc
tar: Removing leading / from member names
To create a bzip2 compressed archive named /root/logbackup.tar.bz2, with the contents from the /var/log directory on host:

[root@host ~] # tar -cjf /root/logbackup.tar.bz2 /var/log
tar: Removing leading / from member names
To create a xz compressed archive named, /root/sshconfig.tar.xz, with the contents from the /etc/ssh directory on host:

[root@host ~]# tar -cJf /root/sshconfig.tar.xz /etc/ssh
tar: Removing leading  from member names


#XTRACTING
IF YOU WANT TO CREATE TAR WITH different extensions. I.e, above. same if you want to extract: 

tar xf -> normal 

tar xzf -> tar.gz 

tar xjf -> tar.bz2 

tar xJf -> tar.xz 



##### TRANSFERRING FILES AND SYNC 

##SYNC

'to synchronize contents of the /var/log directory to the /tmp directory:
'
[user@host ~]$ su -
Password: password
[root@host ~]# rsync -av /var/log /tmp


'in this example, synchronize the local /var/log directory to the /tmp directory on the remotehost system:
'
[root@host ~]# rsync -av /var/log remotehost:/tmp


'In the same way, the /var/log remote directory on remotehost can be synchronized to the /tmp local directory on host:
'
[root@host ~]# rsync -av remotehost:/var/log /tmp


## TRANSFER 


'The following example demonstrates how to copy the local /etc/yum.conf 
and /etc/hosts files on host, to the remoteusers home directory on the remotehost remote system:'

[user@host ~]# scp /etc/yum.conf /etc/hosts remoteuser@remotehost:/home/remoteuser


'To copy a whole directory tree recursively, use the -r option
'
[user@host ~]# scp -r root@remoteuser:/var/log /tmp



'Transferring Files Using the Secure File Transfer Program
'
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