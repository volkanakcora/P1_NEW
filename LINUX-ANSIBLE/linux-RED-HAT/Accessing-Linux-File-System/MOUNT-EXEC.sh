'A new partition with a file system has been added to the second disk (/dev/vdb) on servera. Mount the newly available partition by UUID at the newly created mount point /mnt/newspace.
'
'Use the' sudo -i 'command to switch to root, as only the root user can manually mount a device.'

[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
Create the /mnt/newspace directory.

[root@servera ~]# mkdir /mnt/newspace


'Use the' lsblk 'command with the -fp option to discover the UUID of the device, /dev/vdb1.'

[root@servera ~]# lsblk -fp /dev/vdb
NAME        FSTYPE LABEL UUID                                 MOUNTPOINT
/dev/vdb                                                      
└─/dev/vdb1 xfs          a04c511a-b805-4ec2-981f-42d190fc9a65
Mount the file system by using UUID on the /mnt/newspace directory. Replace the UUID with that of the /dev/vdb1 disk from the previous command output.

[root@servera ~]# mount \
UUID="a04c511a-b805-4ec2-981f-42d190fc9a65" /mnt/newspace


'Verify that the /dev/vdb1 device is mounted on the /mnt/newspace directory.
'
[root@servera ~]# lsblk -fp /dev/vdb
NAME        FSTYPE LABEL UUID                                 MOUNTPOINT
/dev/vdb                                                      
└─/dev/vdb1 xfs          a04c511a-b805-4ec2-981f-42d190fc9a65 /mnt/newspace

'Change to the /mnt/newspace directory and create a new directory, /mnt/newspace/newdir, with an empty file, /mnt/newspace/newdir/newfile.
'
Change to the /mnt/newspace directory.

[root@servera ~]# cd /mnt/newspace
Create a new directory, /mnt/newspace/newdir.

[root@servera newspace]# mkdir newdir
Create a new empty file, /mnt/newspace/newdir/newfile.

[root@servera newspace]# touch newdir/newfile

'Unmount the file system mounted on the /mnt/newspace directory.
'
'Use the umount command to unmount /mnt/newspace while the current directory on the shell is still /mnt/newspace. The umount command fails to unmount the device.
'
[root@servera newspace]# umount /mnt/newspace
umount: /mnt/newspace: target is busy.
Change the current directory on the shell to /root.

[root@servera newspace]# cd
[root@servera ~]# 
Now, successfully unmount /mnt/newspace.

[root@servera ~]# umount /mnt/newspace