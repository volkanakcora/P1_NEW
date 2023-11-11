Selected tar Options
tar command options are divided into operations (the action you want to take): 
general options and compression options. The table below shows common options, long version of options, 
and their description:

Table 13.1. Overview of tar Operations

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


########################################

The following command creates an archive named archive.tar with the contents of file1, file2, and file3 in the users home directory.

[user@host ~]$ tar -cf archive.tar file1 file2 file3
[user@host ~]$ ls archive.tar
archive.tar

############################################################

The above tar command can also be executed using the long version options.

[user@host ~]$ tar --file=archive.tar --create file1 file2 file3

###########################################
For tar to be able to archive the selected files, it is mandatory that the user executing the tar command can read the files. For example, creating a new archive of the /etc folder and all of its content requires root privileges, because only the root user is allowed to read all of the files present in the /etc directory. An unprivileged user can create an archive of the /etc directory,
but the archive omits files which do not include read permission for the user, and it omits directories which do not include both read and execute permission for the user.

To create the tar archive named, /root/etc.tar, with the /etc directory as content as user root:

[root@host ~]# tar -cf /root/etc.tar /etc
tar: Removing leading / from member names
[root@host ~]# 

####### LISTING CONTENTS: tar -tf templates.tar

######## EXTRACTING THE FILES FROM ARCHIVE tar -tf templates.tar

###################

[root@host etcbackup]# tar -xf /root/etc.tar
By default, when files get extracted from an archive, the umask is 
subtracted from the permissions of archive content. To preserve the permissions of an archived file, 
the p option when extracting an archive.

In this example, an archive named, /root/myscripts.tar, is extracted in the /root/scripts directory while 
preserving the permissions of the extracted files:

[root@host ~]# mkdir /root/scripts
[root@host ~]# cd /root/scripts
[root@host scripts]# tar -xpf /root/myscripts.tar



##############   Creating a Compressed Archive

Use one of the following options to create a compressed tar archive:

-z or --gzip for gzip compression (filename.tar.gz or filename.tgz)

-j or --bzip2 for bzip2 compression (filename.tar.bz2)

-J or -xz for xz compression (filename.tar.xz)

###################

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


### Extracting a Compressed Archive  example

###To extract the contents of a gzip compressed archive named /root/etcbackup.tar.gz 
in the /tmp/etcbackup directory:

#[root@host ~] mkdir /tmp/etcbackup
#[root@host ~] cd /tmp/etcbackup
#[root@host etcbackup]# tar -tf /root/etcbackup.tar.gz
etc/
etc/fstab
etc/crypttab
etc/mtab
...output omitted...
[root@host etcbackup]# tar -xzf /root/etcbackup.tar.gz

 specify the extracting folder while extracting

####To extract the contents of a bzip2 compressed archive named /root/logbackup.tar.bz2 in the 
/tmp/logbackup directory:

[root@host ~] mkdir /tmp/logbackup
[root@host ~] cd /tmp/logbackup
[root@host logbackup]# tar -tf /root/logbackup.tar.bz2
var/log/
var/log/lastlog
var/log/README
var/log/private/
var/log/wtmp
var/log/btmp
...output omitted...
[root@host logbackup]# tar -xjf /root/logbackup.tar.bz2

###To extract the contents of a xz compressed archive named /root/sshbackup.tar.xz in 
the /tmp/sshbackup directory:

[root@host ~]$ mkdir /tmp/sshbackup
[root@host ~]# cd /tmp/sshbackup
[root@host logbackup]# tar -tf /root/sshbackup.tar.xz
etc/ssh/
etc/ssh/moduli
etc/ssh/ssh_config
etc/ssh/ssh_config.d/
etc/ssh/ssh_config.d/05-redhat.conf
etc/ssh/sshd_config
...output omitted...
[root@host sshbackup]# tar -xJf /root/sshbackup.tar.xz