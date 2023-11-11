'Logical Volume Management (LVM) Concepts
'

'Logical volumes and logical volume management make it easier to manage disk space. If a file system that hosts a logical volume 
needs more space, 
it can be allocated to its logical volume from the free space in its volume group and the file system can be resized'




------------ #LVM Definitions# -------------------

'Physical devices
'

Physical devices are the storage devices used to save data stored in a logical volume. 
These are block devices and could be disk partitions, whole disks, RAID arrays, or SAN disks.


'Physical volumes (PVs)
'


Physical volumes are the underlying "physical" storage used with LVM. You must initialize a device as a physical volume before using it in 
an LVM system. LVM tools segment physical volumes into physical extents (PEs), which are small chunks of data that act as the smallest storage 
block on a physical volume.

'Volume groups (VGs)
'
Volume groups are storage pools made up of one or more physical volumes. This is the functional equivalent of a whole disk in basic storage. 
A PV can only be allocated to a single VG. A VG can consist of unused space and any number of logical volumes.


'Logical volumes (LVs)'

Logical volumes are created from free physical extents in a volume group and provide the "storage" device used by applications, 
users, and the operating system.



--------------------------------- 'Creating a Logical Volume' ---------------------------


------'Prepare the physical device.'

'Use 'parted', 'gdisk', or 'fdisk' to create a new partition for use with LVM. Always set the partition type to Linux LVM on LVM partitions; 
use '0x8e' for 'MBR' partitions. If necessary, use 'partprobe' to register the new partition with the kernel.'

'A physical device only needs to be prepared if there are none prepared already and a new physical 
volume is required to create or extend a volume group.'


[root@host ~]# parted -s /dev/vdb mkpart primary 1MiB 769MiB
[root@host ~]# parted -s /dev/vdb mkpart primary 770MiB 1026MiB
[root@host ~]# parted -s /dev/vdb set 1 lvm on
[root@host ~]# parted -s /dev/vdb set 2 lvm on





------'Create a physical volume.'

'Use 'pvcreate' to label the partition (or other physical device) as a physical volume. 
The 'pvcreate' command divides the physical volume into physical extents (PEs) of a fixed size, for example, 4 MiB blocks. 
You can label multiple devices at the same time by using space-delimited device names as arguments to pvcreate.
'
[root@host ~]# pvcreate /dev/vdb2 /dev/vdb1

--> 'This labels the devices /dev/vdb2 and /dev/vdb1 as PVs, ready for allocation into a volume group.'







-------'Create a volume group.'

'Use 'vgcreate' to collect one or more physical volumes into a volume group
'

'The 'vgcreate' command-line consists of a volume group name followed by one or more physical volumes to allocate to this volume group.
'
[root@host ~]# vgcreate vg01 /dev/vdb2 /dev/vdb1

'This creates a VG called vg01 that is the combined size, in PE units, of the two PVs /dev/vdb2 and /dev/vdb1.
'
'A VG only needs to be created if none already exist. Additional VGs may be created for administrative reasons to 
manage the use of PVs and LVs. Otherwise, existing VGs can be extended to accommodate new LVs when needed.'




-------- 'Create a logical volume.'


'Use lvcreate to create a new logical volume from the available physical extents in a volume group. 
At a minimum, the 'lvcreate' command includes the '-n' option to set the LV name, either the '-L' option to set the LV size in bytes or 
the '-l' option to set the LV size in extents, and the name of the volume group hosting this logical volume.'

[root@host ~]# lvcreate -n lv01 -L 700M vg01

'This creates an LV called lv01, 700 MiB in size, in the VG vg01. '


'The following list provides some examples of creating LVs:
'
-- lvcreate -L 128M: Size the logical volume to exactly 128 MiB.

-- lvcreate -l 128 : Size the logical volume to exactly 128 extents. 







-------- 'Add the file system.'

'Use mkfs to create an XFS file system on the new logical volume. Alternatively, create a file system based on your preferred file system, 
for example, ext4.'

[root@host ~]# mkfs -t xfs /dev/vg01/lv01

'To make the file system available across reboots, perform the following steps:
'

'Use mkdir to create a mount point.
'
[root@host ~]# mkdir /mnt/data

'Add an entry to the /etc/fstab file:
'
/dev/vg01/lv01  /mnt/data xfs  defaults 1 2

'Run mount /mnt/data to mount the file system that you just added in /etc/fstab.
'
[root@host ~]# mount /mnt/data





--------------------------------- 'Removing a Logical Volume' ---------------------------

-------- 'Prepare the file system.
'
'Move all data that must be kept to another file system. Use the umount command to unmount the file system and then 
remove any /etc/fstab entries associated with this file system.
'
[root@host ~]# umount /mnt/data


------- 'Remove the logical volume.
'
'Use 'lvremove DEVICE_NAME' to remove a logical volume that is no longer needed.
'
[root@host ~]# lvremove /dev/vg01/lv01

'The LVs physical extents are freed and made available for assignment to existing or new LVs in the volume group.'



--------- 'Remove the volume group'

'Use vgremove VG_NAME to remove a volume group that is no longer needed.
'
[root@host ~]# vgremove vg01

'The VGs physical volumes are freed and made available for assignment to existing or new VGs on the system.'

---------- 'Remove the physical volumes.'

'
Use 'pvremove' to remove physical volumes that are no longer needed. Use a space-delimited list of PV devices to remove more than one at a time. 
This command deletes the PV metadata from the partition (or disk). The partition is now free for reallocation or reformatting.'

[root@host ~]# pvremove /dev/vdb2 /dev/vdb1




--------------------------------- 'Reviewing LVM Status Information' ---------------------------

----- 'Physical Volumes' 

'Use 'pvdisplay' to display information about physical volumes. '


[root@host ~]# pvdisplay /dev/vdb1
  --- Physical volume ---
  PV Name               /dev/vdb1                        1
  VG Name               vg01                             2
  PV Size               768.00 MiB / not usable 4.00 MiB 3
  Allocatable           yes
  PE Size               4.00 MiB                         4
  Total PE              191
  Free PE               16                               5
  Allocated PE          175
  PV UUID               JWzDpn-LG3e-n2oi-9Etd-VT2H-PMem-1ZXwP1



1 'PV Name maps to the device name.'

2 'VG Name shows the volume group where the PV is allocated.'

3 'PV Size shows the physical size of the PV, including any unusable space.'

4 'PE Size is the physical extent size, which is the smallest size a logical volume can be allocated.'

'It is also the multiplying factor when calculating the size of any value reported in PE units, such as Free PE; for example: 
26 PEs x 4 MiB (the PE Size) equals 104 MiB of free space. A logical volume size is rounded to a factor of PE units.'

'LVM sets the PE size automatically, although it is possible to specify it.'

5 'Free PE shows how many PE units are available for allocation to new logical volumes.'



----- 'Volume Groups'


'Use 'vgdisplay' to display information about volume groups.'

[root@host ~]# vgdisplay vg01
  --- Volume group ---
  VG Name               vg01             1
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               1016.00 MiB      2
  PE Size               4.00 MiB
  Total PE              254              3
  Alloc PE / Size       175 / 700.00 MiB
  Free  PE / Size       79 / 316.00 MiB  4
  VG UUID               3snNw3-CF71-CcYG-Llk1-p6EY-rHEv-xfUSez



------ 'Logical Volumes'

[root@host ~]# lvdisplay /dev/vg01/lv01
  --- Logical volume ---
  LV Path                /dev/vg01/lv01         1
  LV Name                lv01
  VG Name                vg01                   2
  LV UUID                5IyRea-W8Zw-xLHk-3h2a-IuVN-YaeZ-i3IRrN
  LV Write Access        read/write
  LV Creation host, time host.lab.example.com, 2019-03-28 17:17:47 -0400
  LV Status              available
  # open                 1
  LV Size                700 MiB                3
  Current LE             175                    4
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - current set to       256
  Block device           252:0



--------------------------------- 'Extending and Reducing a Volume Group' ---------------------------


You can add more disk space to a volume group by adding additional physical volumes. This is called extending the volume group. Then, you can assign 
the new physical extents from the additional physical volumes to logical volumes.

You can remove unused physical volumes from a volume group. This is called reducing the volume group. 
First, use the pvmove command to move data from extents on one physical volume to extents on other physical volumes in the volume group.




------- 'Extending a Volume Group'

'To extend a volume group, perform the following steps:

Prepare the physical device and create the physical volume.

As with creating a new volume group, you must create and prepare a new partition for use as a physical volume if there are none prepared already.'


[root@host ~]# parted -s /dev/vdb mkpart primary 1027MiB 1539MiB
[root@host ~]# parted -s /dev/vdb set 3 lvm on
[root@host ~]# pvcreate /dev/vdb3

'A PV only needs to be created if there are no PVs free to extend the VG.'


------ 'Extend the volume group.'

'Use 'vgextend' to add the new physical volume to the volume group. Use the VG name and PV device name as arguments to vgextend.
'
[root@host ~]# vgextend vg01 /dev/vdb3
This extends the vg01 VG by the size of the /dev/vdb3 PV.


------ 'Verify that the new space is available.'

'Use 'vgdisplay' to confirm the additional physical extents are available. Inspect the Free PE / Size in the output. It should not be zero.
'
[root@host ~]# vgdisplay vg01
  --- Volume group ---
  VG Name               vg01
...output omitted...
  Free  PE / Size       178 / 712.00 MiB
...output omitted...



'Use lvextend to extend the existing LV to 700 MiB.
'
[root@servera ~]# lvextend -L 700M /dev/servera_01_vg/servera_01_lv

'Use xfs_growfs to extend the XFS file system to the remainder of the free space on the LV.
'
[root@servera ~]# xfs_growfs /data




--------------- 'Reducing a Volume Group'

To reduce a volume group, perform the following steps:

Move the physical extents.

'Use 'pvmove PV_DEVICE_NAME' to relocate any physical extents from the physical volume you want to remove to other physical 
volumes in the volume group. The other physical volumes must have a sufficient number of free extents to accommodate this move. 
This is only possible if there are enough free extents in the VG and if all of those come from other PVs.'

[root@host ~]# pvmove /dev/vdb3
This command moves the PEs from /dev/vdb3 to other PVs with free PEs in the same VG.



---------------- 'Reduce the volume group.

Use 'vgreduce VG_NAME PV_DEVICE_NAME' to remove a physical volume from a volume group.'

[root@host ~]# vgreduce vg01 /dev/vdb3


'This removes the /dev/vdb3 PV from the vg01 VG and it can now be added to another VG. 
Alternatively, pvremove can be used to permanently stop using the device as a PV.'


--------------------------------- 'Extending a Logical Volume and 'XFS' File System' ---------------------------

'One benefit of logical volumes is the ability to increase their size without experiencing downtime. 
Free physical extents in a volume group can be added to a logical volume to extend its capacity, 
which can then be used to extend the file system it contains.'




------------ 'Extending a Logical Volume'

To extend a logical volume, perform the following steps:

'Verify that the volume group has space available.
'
'Use 'vgdisplay' to verify that there are sufficient physical extents available.
'
[root@host ~]# vgdisplay vg01
  --- Volume group ---
  VG Name               vg01
...output omitted...
  Free  PE / Size       178 / 712.00 MiB
...output omitted...

'Inspect the Free PE / Size in the output.
'

--------------- 'Extend the logical volume.'

'Use 'lvextendLV_DEVICE_NAME' to extend the logical volume to a new size.
'
[root@host ~]# lvextend -L +300M /dev/vg01/lv01

'This increases the size of the logical volume lv01 by 300 MiB. Notice the plus sign (+) in front of the size, 
which means add this value to the existing size; otherwise, the value defines the final size of the LV.
'

Examples:

Extending LVs Examples

Command	Results

lvextend -l 128 'Resize the logical volume to exactly 128 extents in size.'

lvextend -l +128 'Add 128 extents to the current size of the logical volume.'

lvextend -L 128M 'Resize the logical volume to exactly 128 MiB.'

lvextend -L +128M 'Add 128 MiB to the current size of the logical volume.'

lvextend -l +50%FREE 'Add 50 percent of the current free space in the VG to the LV.'


---------------- 'Extend the file system.'

'Use 'xfs_growfs' mountpoint to expand the file system to occupy the extended LV. The target file system must be mounted 
when you use the 'xfs_growfs' command. You can continue to use the file system while it is being resized.
'

[root@host ~]# xfs_growfs /mnt/data







--------------------------------- 'Extending a Logical Volume and 'ext4' File System' ---------------------------

'The steps for extending an ext4-based logical volume are essentially the same as for an XFS-based LV, 
except for the step that resizes the file system'


'Verify that the volume group has space available.
'
'Use 'vgdisplay VGNAME' to verify that the volume group has a sufficient number of physical extents available.
'


'Extend the logical volume.

'
'Use 'lvextend -l +extents /dev/vgname/lvname' to extend the logical volume /dev/vgname/lvname by the extents value.
'

E'xtend the file system.

Use 'resize2fs /dev/vgname/lvname' to expand the file system to occupy the new extended LV. 
The file system can be mounted and in use while the extension command is running. You can include the -p option to 
monitor the progress of the resize operation.
'
[root@host ~]# resize2fs /dev/vg01/lv01



--------------------------------- 'Extend a logical volume and 'swap' space' ---------------------------

'Logical volumes formatted as swap space can be extended as well, however the process is different than the 
one for extending a file system, such as 'ext4' or 'XFS'.'


'Verify the volume group has space available.
'
'Use 'vgdisplay vgname' to verify that a sufficient number of free physical extents are available.
'



'Deactivate the swap space.
'
'Use 'swapoff -v /dev/vgname/lvname' to deactivate the swap space on the logical volume.
'


'Extend the logical volume.
'

''lvextend -l +extents /dev/vgname/lvname' extends the logical volume '/dev/vgname/lvname' by the extents value.
'


'Format the logical volume as swap space.
'

''mkswap /dev/vgname/lvname' formats the entire logical volume as swap space.
'


'Activate the swap space.
'
'Use 'swapon -va /dev/vgname/lvname' to activate the swap space on the logical volume.
'

