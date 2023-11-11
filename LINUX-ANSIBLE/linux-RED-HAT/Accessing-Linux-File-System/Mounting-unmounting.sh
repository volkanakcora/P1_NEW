'Mounting File Systems Manually
A file system residing on a removable storage device needs to be mounted in order to access it. 
The mount command allows the root user to manually mount a file system. The first argument of the mount command specifies 
the file system to mount. The second argument specifies the directory to use as the mount point in the file-system hierarchy.'

There are two common ways to specify the file system on a disk partition to the mount command:

With the name of the device file in /dev containing the file system.

With the UUID written to the file system, a universally-unique identifier.

Mounting a device is relatively simple. You need to identify the device you want to mount, make sure the mount point exists, and mount the device on the mount point.

Identifying the Block Device

'A hot-pluggable storage device, whether a hard disk drive (HDD) or solid-state device (SSD) in a server caddy, or a 
USB storage device, might be plugged into a different port each time they are attached to a system.'

Use the lsblk command to list the details of a specified block device or all the available devices.


[root@host ~]# lsblk -fp
NAME        FSTYPE LABEL UUID                                 MOUNTPOINT
/dev/vda                                                      
├─/dev/vda1 xfs          23ea8803-a396-494a-8e95-1538a53b821c /boot
├─/dev/vda2 swap         cdf61ded-534c-4bd6-b458-cab18b1a72ea [SWAP]
└─/dev/vda3 xfs          44330f15-2f9d-4745-ae2e-20844f22762d /
/dev/vdb
└─/dev/vdb1 xfs          46f543fd-78c9-4526-a857-244811be2d88



[root@host ~]# mount UUID="46f543fd-78c9-4526-a857-244811be2d88" /mnt/data


'Unmounting File Systems
The shutdown and reboot procedures unmount all file systems automatically. As part of this process, any file system data cached in memory 
is flushed to the storage device thus ensuring that the file system suffers no data corruption.

WARNING
File system data is often cached in memory. Therefore, in order to avoid corrupting data on the disk, it is essential that you unmount 
removable drives before unplugging them. The unmount procedure synchronizes data before releasing the drive, ensuring data integrity.
'
To unmount a file system, the umount command expects the mount point as an argument.

[root@host ~]# umount /mnt/data


'The lsof command lists all open files and the process accessing them in the provided directory. 
It is useful to identify which processes currently prevent the file system from successful unmounting.'

[root@host data]# lsof /mnt/data

