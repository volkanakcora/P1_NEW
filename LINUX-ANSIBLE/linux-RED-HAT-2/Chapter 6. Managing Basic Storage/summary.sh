Goal	'Create and manage storage devices, partitions, file systems, and swap spaces from the command line.'

Objectives 'Create storage partitions, format them with file systems, and mount them for use.
'
            'Create and manage swap spaces to supplement physical memory.'


Sections    'Adding Partitions, File Systems, and Persistent Mounts (and Guided Exercise)'

            'Managing Swap Space (and Guided Exercise)
'
Lab	         'Managing Basic Storage'






'Partitioning a Disk
Disk partitioning allows system administrators to divide a hard drive into multiple logical storage units, referred to as partitions. By separating a disk into partitions, system administrators can use different partitions to perform different functions.

For example, disk partitioning is necessary or beneficial in these situations:
'
---Limit available space to applications or users.

---Separate operating system and program files from user files.

---Create a separate area for memory swapping.

---Limit disk space use to improve the performance of diagnostic tools and backup imaging.





''''''''''''''''''''''''''''''''''MBR Partitioning Scheme''''''''''''''''''''''''''''''''''''''''''''''

'administrators can create a maximum of 15 partitions. Because partition size data is stored as 32-bit values, disks partitioned with the 
MBR scheme have a maximum disk and partition size of 2 TiB.'

# MBR Partitioning of the /dev/vdb storage device


''''''''''''''''''''''''''''''''''GPT Partitioning Scheme''''''''''''''''''''''''''''''''''

'GPT is the standard for laying out partition tables on physical hard disks'

'A GPT provides a maximum of 128 partitions. Unlike an MBR, which uses 32 bits for storing logical block addresses and size information, 
a GPT allocates 64 bits for logical block addresses.'

'GPT also offers some additional features and benefits. A GPT uses a globally unique identifier (GUID) to identify each disk and partition'

'a GPT offers redundancy of its partition table information. The primary GPT resides at the head of the disk, while a backup copy, 
the secondary GPT, is housed at the end of the disk. 
A GPT uses a checksum to detect errors and corruptions in the GPT header and partition table.'

#GPT Partitioning of the /dev/vdb storage device




''''''''''''''''''''''''''''''''''Managing Partitions with Parted''''''''''''''''''''''''''''''''''


'Partition editors are programs which allow administrators to make changes to a disks partitions, such as creating partitions, 
deleting partitions, and changing partition types. '


##administrators can use the Parted partition editor for both the MBR and the GPT partitioning scheme.##

'The parted command takes the device name of the whole disk as the first argument and one or more subcommands. The following example 
uses the print subcommand to display the partition table on the /dev/vda disk.'

[root@host ~]# parted /dev/vda print
Model: Virtio Block Device (virtblk)
Disk /dev/vda: 53.7GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  10.7GB  10.7GB  primary  xfs          boot
 2      10.7GB  53.7GB  42.9GB  primary  xfs
If you do not provide a subcommand, parted opens an interactive session for issuing commands.

[root@host ~]# parted /dev/vda
GNU Parted 3.2
Using /dev/vda
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) print
Model: Virtio Block Device (virtblk)
Disk /dev/vda: 53.7GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  10.7GB  10.7GB  primary  xfs          boot
 2      10.7GB  53.7GB  42.9GB  primary  xfs

(parted) quit
[root@host ~]# 

'By default, parted displays all the sizes in powers of 10 (KB, MB, GB). You can change that default with the unit 
subcommand which accepts the following parameters:
'
s 'for sector
'
B 'for byte'

'MiB, GiB, or TiB' (powers of 2)

'MB, GB, or TB' (powers of 10)

example:  [root@host ~]# parted /dev/vda unit s print



''''''''''''''''''''''''''''''Writing the Partition Table on a New Disk''''''''''''''''''''''''''''''''

--> 'To partition a new drive, you first have to write a disk label to it. The disk label indicates which partitioning scheme to use.

'

((((((((WARNING)))))))) --> #Keep in mind that parted makes the changes immediately. A mistake with parted could lead to data loss.


----'As the root user, use the following command to write an MBR disk label to a disk.'---

[root@host ~]# parted /dev/vdb mklabel msdos

----'To write a GPT disk label, use the following command.'---

[root@host ~]# parted /dev/vdb mklabel gpt

(((((((((WARNINIG))))))))) --> 'The mklabel subcommand wipes the existing partition table. Only use mklabel 
when the intent is to reuse the disk without regard to the existing data. 
If a new label changes the partition boundaries, all data in existing file systems will become inaccessible. '



''''''''''''''''''''''''''''''''''''''''''CREATING MBR PARTITIONS''''''''''''''''''''''''''''''''''''''''''

1) 'Specify the disk device to create the partition on.'

[root@host ~]# parted /dev/vdb
GNU Parted 3.2
Using /dev/vdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) 



[root@host ~]# parted /dev/vdb mkpart primary xfs 2048s 1000MB

## alternative ##


''''''''''''''''''''''''''''''''''''''''''CREATING GPT PARTITIONS''''''''''''''''''''''''''''''''''''''''''

'The GTP scheme also uses the parted command to create new partitions:
'
'Specify the disk device to create the partition on.
'
'As the root user, execute the parted command with the disk device as the only argument to start parted in interactive mode with a command prompt.'

[root@host ~]# parted /dev/vdb mkpart usersdata xfs 2048s 1000MB


''''''''''''''''''''''''''''''''''''''''''DELETING PARTITIONS''''''''''''''''''''''''''''''''''''''''''

1) 'Specify the disk that contains the partition to be removed.'

[root@host ~]# parted /dev/vdb
GNU Parted 3.2
Using /dev/vdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) 

2) 'Identify the partition number of the partition to delete.'

(parted) print
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size   File system  Name       Flags
 1      1049kB  1000MB  999MB  xfs          usersdata

3) 'Delete the partition.'

(parted) rm 1

'The rm subcommand immediately deletes the partition from the partition table on the disk.'

''''''''''''''''''''''''''''''''''''''''''CREATING FILE SYSTEMS(format the new partition''''''''''''''''''''''''''''''''''''''''''

'After the creation of a block device, the next step is to add a file system to it. '

# XFS and ext4. Anaconda, the installer for Red Hat Enterprise Linux, uses XFS by default.

'As root, use the 'mkfs.xfs' command to apply an XFS file system to a block device. For ext4, use mkfs.ext4.
'
[root@host ~]# mkfs.xfs /dev/vdb1
meta-data=/dev/vdb1              isize=512    agcount=4, agsize=60992 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=243968, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=1566, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


-----------'Persistently Mounting File Systems'--------------

'To make sure that the system automatically mounts the file system at system boot, add an entry to the /etc/fstab file. 
This configuration file lists the file systems to mount at system boot.'

/etc/fstab 'is a white-space-delimited file with six fields per line.'

[root@host ~]# cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Wed Feb 13 16:39:59 2019
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
UUID=a8063676-44dd-409a-b584-68be2c9f5570   /        xfs   defaults   0 0
UUID=7a20315d-ed8b-4e75-a5b6-24ff9e1f9838   /dbdata  xfs   defaults   0 0

'When you add or remove an entry in the /etc/fstab file, run the 'systemctl daemon-reload' command, or reboot the server, for 
systemd to register the new configuration.'


-------------'PROPER STEPS TO ADD NEW FILE SYSTEM'---------------

1) 'Use parted to create a new disk label of type msdos on the /dev/vdb disk to prepare that new disk for the MBR partitioning scheme.
'
[root@servera ~]# parted /dev/vdb mklabel msdos   (msdos(MBR) or gpt(GPT) )




2)  'Use parted interactive mode to help you create the partition.'

[root@servera ~]# parted /dev/vdb
GNU Parted 3.2
Using /dev/vdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) #mkpart
Partition type?  primary/extended? primary
File system type?  [ext2]? #xfs
Start? #2048s
End? #1001MB
(parted) quit
Information: You may need to update /etc/fstab.

'alternative: As an alternative, you can perform the same operation with the following noninteractive command:' 
#parted /dev/vdb mkpart primary xfs 2048s 1001MB

'THEN' -> 

'Verify your work by listing the partitions on /dev/vdb.
'
[root@servera ~]# parted /dev/vdb print
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  1001MB  1000MB  primary





3)  'Run the udevadm settle command. This command waits for the system to register the new partition and returns when it is done.'

[root@servera ~]# udevadm settle



4) 'Format the new partition with the XFS file system.'

[root@servera ~]# mkfs.xfs /dev/vdb1





5)  'Configure the new file system to mount at /archive persistently.'

Use mkdir to create the /archive directory mount point.

[root@servera ~]# mkdir /archive

'Use the lsblk command with the --fs option to discover the UUID of the /dev/vdb1 device.
'
[root@servera ~]# lsblk --fs /dev/vdb
NAME   FSTYPE LABEL UUID                                 MOUNTPOINT
vdb
└─vdb1 xfs          'e3db1abe-6d96-4faa-a213-b96a6f85dcc1'


6) 'Add an entry to /etc/fstab. In the following content, replace the UUID with the one you discovered from the previous step.'

...output omitted...
UUID=e3db1abe-6d96-4faa-a213-b96a6f85dcc1 /archive xfs defaults  0 0



7)  'Update systemd for the system to register the new /etc/fstab configuration.
'
[root@servera ~]# systemctl daemon-reload


8) 'Execute the mount /archive command to mount the new file system using the new entry added to /etc/fstab.'

[root@servera ~]# mount /archive





|||||||||||||||||||||||||||||||||||||||||'Managing Swap Space'|||||||||||||||||||||||||||||||||||||||||

'A swap space is an area of a disk under the control of the Linux kernel memory management subsystem. 
The kernel uses swap space to supplement the system RAM by holding inactive pages of memory. The combined system RAM plus swap space is called 
virtual memory.
'


-----'Sizing the Swap Space'-----

'Administrators should size the swap space based on the memory workload on the system. Application vendors sometimes provide recommendations on that subject. 
The following table provides some guidance based on the total amount of physical memory.'

RAM and Swap Space Recommendations

#RAM	                         Swap           Space Swap Space if Allowing for Hibernation
2 GiB or less	             Twice the RAM	    Three times the RAM
Between 2 GiB and 8 GiB	     Same as RAM	    Twice the RAM
Between 8 GiB and 64 GiB	 At least 4 GiB	    1.5 times the RAM
More than 64 GiB	         At least 4 GiB	    Hibernation is not recommended



''''''''''''''''Creating a Swap Space''''''''''''''''''''''''''''

'To create a swap space, you need to perform the following:
'
--> #Create a partition with a file system type of linux-swap.

--> #Place a swap signature on the device.

-----------'Creating a Swap Partition'-------------

'Use parted to create a partition of the desired size and set its file system type to linux-swap.'

-> The following example creates a 256 MB partition.

[root@host ~]# parted /dev/vdb
GNU Parted 3.2
Using /dev/vdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) #print
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  1001MB  1000MB               data

(parted) #mkpart
Partition name?  []? #swap1
File system type?  [ext2]? #linux-swap
Start? #1001MB
End? #1257MB
(parted) #print
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system     Name   Flags
 1      1049kB  1001MB  1000MB                  data
 2      1001MB  1257MB  '256MB'   'linux-swap(v1)'  swap1

(parted) #quit
Information: You may need to update /etc/fstab.

[root@host ~]# 

## ALTERNATIVE ## [root@serverb ~]# parted /dev/vdb mkpart swap1 linux-swap 2000MB 2512M



'After creating the partition, run the 'udevadm settle' command. 
'
[root@host ~]# udevadm settle
[root@host ~]# 


------------initialize 'Formatting the Device'----------------

'The mkswap command applies a swap signature to the device. Unlike other formatting utilities, 
mkswap writes a single block of data at the beginning of the device, leaving the rest of the device unformatted 
so the kernel can use it for storing memory pages.
'

[root@host ~]# mkswap /dev/vdb2
Setting up swapspace version 1, size = 244 MiB (255848448 bytes)
no label, UUID=39e2667a-9458-42fe-9665-c5c854605881




'-------------------' Activating a Swap Space '----------------'

'the swapon command to activate a formatted swap space.'

'Use swapon with the device as a parameter, or use 'swapon -a' to activate all the swap spaces listed in the '/etc/fstab' file.
Use the 'swapon --show' and 'free' commands to inspect the available swap spaces.'


[root@host ~]# free
              total        used        free      shared  buff/cache   available
Mem:        1873036      134688     1536436       16748      201912     1576044
Swap:             0           0           0
[root@host ~]# swapon /dev/vdb2
[root@host ~]# free
              total        used        free      shared  buff/cache   available
Mem:        1873036      135044     1536040       16748      201952     1575680
Swap:        249852           0      249852

'You can deactivate a swap space using the 'swapoff' command'


---------------'Activating Swap Space Persistently'------------------

'To activate a swap space at every boot, place an entry in the /etc/fstab file. The example below shows a typical 
line in /etc/fstab based on the swap space created above.'

#UUID=39e2667a-9458-42fe-9665-c5c854605881   swap   swap   defaults   0 0

'When you add or remove an entry in the /etc/fstab file, run the systemctl daemon-reload command, 
'
[root@host ~]# systemctl daemon-reload



----------------'Setting the Swap Space Priority'--------------------

'To set the priority, use the pri option in /etc/fstab. The kernel uses the swap space with the highest priority first. The default priority is -2.'

'The following example shows three swap spaces defined in /etc/fstab. 
The kernel uses the last entry first, with pri=10. When that space is full, it uses the second entry, with pri=4. 
Finally, it uses the first entry, which has a default priority of -2.'

UUID=af30cbb0-3866-466a-825a-58889a49ef33   swap   swap   defaults  0 0
UUID=39e2667a-9458-42fe-9665-c5c854605881   swap   swap   pri=4     0 0
UUID=fbd7fa60-b781-44a8-961b-37ac3ef572bf   swap   swap   pri=10    0 0



-------------'PROPER STEPS TO ADD NEW SWAP'---------------

1) 'Use the parted command to inspect the /dev/vdb disk.'

[root@servera ~]# parted /dev/vdb print
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name  Flags
1      1049kB  1001MB  1000MB               data





2) 'Use parted to create the partition. Because the disk uses the GPT partitioning scheme, you need to give a name to the partition. Call it myswap.'

[root@servera ~]# parted /dev/vdb mkpart myswap linux-swap \
1001MB 1501MB
Information: You may need to update /etc/fstab.

--> 'Verify your work by listing the partitions on /dev/vdb.'

[root@servera ~]# parted /dev/vdb print
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name   Flags
1      1049kB  1001MB  1000MB               data
2      1001MB  1501MB  499MB                myswap swap










3) 'Run the udevadm settle command. This command waits for the system to register the new partition and returns when it is done.'

[root@servera ~]# udevadm settle





4) 'Initialize the newly created partition as swap space.'

[root@servera ~]# mkswap /dev/vdb2
Setting up swapspace version 1, size = 476 MiB (499118080 bytes)
no label, UUID=cb7f71ca-ee82-430e-ad4b-7dda12632328



5) 'Enable the newly created swap space.'

'Use the 'swapon --show' command to show that creating and initializing swap space does not yet enable it for use.
'
[root@servera ~]# swapon --show
Enable the newly created swap space.  --> nothing yet

[root@servera ~]# swapon /dev/vdb2


--> 'Verify that the newly created swap space is now available.'

[root@servera ~]# swapon --show
NAME      TYPE      SIZE USED PRIO
/dev/vdb2 partition 476M   0B   -2


--> 'if you need to'

'Disable the swap space.
'
[root@servera ~]# swapoff /dev/vdb2




6) 'Use the lsblk command with the --fs option to discover the UUID of the /dev/vdb2 device.'

[root@servera ~]# lsblk --fs /dev/vdb2
NAME FSTYPE LABEL UUID                                 MOUNTPOINT
vdb2 swap         cb7f71ca-ee82-430e-ad4b-7dda12632328
The UUID in the previous output is probably different on your system.

'Add an entry to /etc/fstab. In the following command, replace the UUID with the one you discovered from the previous step.
'
...output omitted...
UUID=cb7f71ca-ee82-430e-ad4b-7dda12632328  swap  swap  defaults  0 0



'Update systemd for the system to register the new /etc/fstab configuration.'
[root@servera ~]# systemctl daemon-reload



'Enable the swap space using the entry just added to /etc/fstab.'
[root@servera ~]# swapon -a

'then reboot'

