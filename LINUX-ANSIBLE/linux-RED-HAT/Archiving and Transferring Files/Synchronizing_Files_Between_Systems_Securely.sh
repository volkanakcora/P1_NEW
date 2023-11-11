Two common options when synchronizing with rsync are the -v and -a options.

The -v or --verbose option provides more detailed output. This is useful for troubleshooting and to view live progress.

The -a or --archive option enables "archive mode". This enables recursive copying and turns on a large number of useful options that preserve most characteristics of the files. Archive mode is the same as specifying the following options:

Table 13.4. Options Enabled with rsync -a (Archive Mode)

Option	Description
-r, --recursive	synchronize recursively the whole directory tree
-l, --links	synchronize symbolic links
-p, --perms	preserve permissions
-t, --times	preserve time stamps
-g, --group	preserve group ownership
-o, --owner	preserve the owner of the files
-D, --devices	synchronize device file

###########################


For example, to synchronize contents of the /var/log directory to the /tmp directory:

[user@host ~]$ su -
Password: password
[root@host ~]# rsync -av /var/log /tmp
receiving incremental file list
log/
log/README
log/boot.log
...output omitted...
log/tuned/tuned.log

sent 11,592,423 bytes  received 779 bytes  23,186,404.00 bytes/sec
total size is 11,586,755  speedup is 1.00
[user@host ~]$ ls /tmp
log  ssh-RLjDdarkKiW1
[user@host ~]$ 

##############################

A trailing slash on the source directory synchronizes the content of that directory without newly creating the subdirectory 
in the target directory. In this example, the log directory is not created in the /tmp directory, only the content of /var/log/ is synchronized into /tmp.

[root@host ~]# rsync -av /var/log/ /tmp




#################################

in this example, synchronize the local /var/log directory to the /tmp directory on the remotehost system:

[root@host ~]# rsync -av /var/log remotehost:/tmp
root@remotehost's password: password
receiving incremental file list
log/
log/README
log/boot.log
...output omitted...
sent 9,783 bytes  received 290,576 bytes  85,816.86 bytes/sec
total size is 11,585,690  speedup is 38.57
In the same way, the /var/log remote directory on remotehost can be synchronized to the /tmp local directory on host:

[root@host ~]# rsync -av remotehost:/var/log /tmp
root@remotehost's password: password
receiving incremental file list
log/boot.log
