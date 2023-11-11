'Managing Layered Storage with Stratis
'

Describing the Architecture of Stratis

'Stratis is a new local storage-management solution for Linux. Stratis is designed to make it easier to perform initial configuration of storage, 
make changes to the storage configuration, and use advanced storage features.'


Working with Stratis Storage

'To manage file systems with the Stratis storage management solution, install the stratis-cli and stratisd packages. 
The stratis-cli package provides the stratis command, which sends reconfiguration requests to the stratisd system daemon. 
The stratisd package provides the stratisd service, which handles reconfiguration requests and manages and monitors block devices, 
pools, and file systems that Stratis uses.'

#warning#
File systems created by Stratis should only be reconfigured with Stratis tools and commands.


Installing and Enabling Stratis

'To use Stratis, make sure that the software is installed and the stratisd service is running.
'
'Install stratis-cli and stratisd using the yum install command.
'
[root@host ~]# yum install stratis-cli stratisd

'Activate the stratisd service using the systemctl command.
'
[root@host ~]# systemctl enable --now stratisd


Assembling Block Storage into Stratis Pools

'The following are common management operations performed using the Stratis storage management solution.
'


1 --> 'Create pools of one or more block devices using the stratis pool create command.
'

[root@host ~]# stratis pool create pool1 /dev/vdb


'Each pool is a subdirectory under the /stratis directory.
'
'Use the stratis pool list command to view the list of available pools.
'
[root@host ~]# stratis pool list
Name     Total Physical Size  Total Physical Used
pool1                  5 GiB               52 MiB


'Use the stratis pool add-data command to add additional block devices to a pool.  '<-- for extending'
'
[root@host ~]# stratis pool add-data pool1 /dev/vdc


'Use the stratis blockdev list command to view the block devices of a pool.
'
[root@host ~]# stratis blockdev list pool1
Pool Name  Device Node    Physical Size   State  Tier
pool1      /dev/vdb               5 GiB  In-use  Data
pool1      /dev/vdc               5 GiB  In-use  Data



M'anaging Stratis File Systems

Use the stratis filesystem create command to create a file system from a pool.
'
[root@host ~]# stratis filesystem create pool1 fs1


'Use the stratis filesystem list command to view the list of available file systems.
'
[root@host ~]# stratis filesystem list
Pool Name  Name  Used     Created            Device              UUID
pool1      fs1   546 MiB  Sep 23 2020 13:11  /stratis/pool1/fs1  31b9363badd...



'You can create a snapshot of a Stratis-managed file system with the stratis filesystem snapshot command. 
Snapshots are independent of the source file systems.'

[root@host ~]# stratis filesystem snapshot pool1 fs1 snapshot1.snap



'Persistently Mounting Stratis File Systems
'

UUID=31b9363b-add8-4b46-a4bf-c199cd478c55 /dir1 xfs defaults,x-systemd.requires=stratisd.service 0 0


''''''''''''''''''''''''''''''''Compressing and Deduplicating Storage with VDO''''''''''''''''''''''''''''''''''''


'Describing Virtual Data Optimizer
'
'Red Hat Enterprise Linux 8 includes the Virtual Data Optimizer (VDO) driver, which optimizes the data footprint on block devices. 
VDO is a Linux device mapper driver that reduces disk space usage on block devices, and minimizes the replication of data, saving 
disk space and even increasing data throughput. VDO includes two kernel modules: the 'kvdo' module to transparently control data compression, 
and the 'uds' module for deduplication.'



---- 'ENABLING VDO' ---- 

'Install the vdo and kmod-kvdo packages to enable VDO in the system.
'
[root@host ~]# yum install vdo kmod-kvdo


----'Creating a VDO Volume'----

'To create a VDO volume, run the vdo create command.
'
[root@host ~]# vdo create --name=vdo1 --device=/dev/vdd --vdoLogicalSize=50G


'If you omit the logical size, the resulting VDO volume gets the same size as its physical device.
'

----'Analyzing a VDO Volume'----

'To analyze a VDO volume, run the vdo status command.'

'The vdo list command displays the list of VDO volumes that are currently started'





----'Format the vdo1 volume with the XFS file system using the mkfs command.'----
[root@servera ~]# mkfs.xfs -K /dev/mapper/vdo1


----'Use the udevadm command to verify that the new VDO device file has been created.----
'[root@servera ~]# udevadm settle


----'Mount the vdo1 volume on /mnt/vdo1 using the mount command.'----
[root@servera ~]# mount /dev/mapper/vdo1 /mnt/vdo1

----'View the initial statistics and status of the volume using the vdostats command.'----
[root@servera ~]# vdostats --human-readable
Device                    Size      Used Available Use% Space saving%
/dev/mapper/vdo1          5.0G      3.0G      2.0G  60%           99%



#EXERCISE


