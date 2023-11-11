'Mounting Network-Attached Storage with NFS'

'Mounting and Unmounting NFS Shares
'

'NFS, the Network File System, is an internet standard protocol used by Linux, UNIX, and similar operating systems as their native network file system. 
It is an open standard, still being actively enhanced, which supports native Linux permissions and file-system features.'


'NFS servers export shares (directories). NFS clients mount an exported share to a local mount point (directory), which must exist. 
NFS shares can be mounted a number of ways:'

--> Manually, using the mount command.

--> Automatically at boot time using /etc/fstab entries.

--> On demand, using either the autofs service or the systemd.automount facility.



''''''Mounting NFS Shares''''''''''



To mount an NFS share, follow these three steps:


1) Identify: 'The administrator of the NFS client system can identify available NFS shares in various ways:'

[user@host ~]# sudo mkdir mountpoint
[user@host ~]# sudo mount serverb:/ mountpoint
[user@host ~]# sudo ls mountpoint

2) Mount point: 'Use mkdir to create a mount point in a suitable location.'

[user@host ~]# mkdir -p mountpoint

3) Mount: 'As with file systems on partitions, NFS shares must be mounted to be available. To mount an NFS share, select from the following. 
In each case, you must run these commands as a superuser either by logging in as root or by using the sudo command.
'
Mount temporarily: 'Mount the NFS share using the mount command:'

[user@host ~]# sudo mount -t nfs -o rw,sync serverb:/share mountpoint


--> 'The '-t' nfs option is the file-system type for NFS shares (not strictly required but shown for completeness). 
The '-o sync' option tells mount to immediately synchronize write operations with the NFS server (the default is asynchronous).'

-->' This command mounts the share immediately but not persistently; the next time the system boots, this NFS share will not be available. 
This is useful for one-time access to data. It is also useful for test mounting an NFS share before making the share available persistently.'

Mount persistently: 'To ensure that the NFS share is mounted at boot time, edit the /etc/fstab file to add the mount entry.'

[user@host ~]# sudo vim /etc/fstab
...
#serverb:/share  /mountpoint  nfs  rw,soft  0 0

'Then, mount the NFS share:
'
[user@host ~]$ sudo mount /mountpoint



''''''''''''''''''''''''''''''''''''Automounting Network-Attached Storage'''''''''''''''''''''''''''''''''''''''''''


'''''The automounter is a service (autofs) that automatically mounts NFS shares on-demand, 
and will automatically unmount NFS shares when they are no longer being used.''
''

'Automounter Benefits
'

-> 'Users do not need to have root privileges to run the mount and umount commands.'

-> 'NFS shares configured in the automounter are available to all users on the machine, subject to access permissions.'

-> 'NFS shares are not permanently connected like entries in /etc/fstab, freeing network and system resources.'

-> 'The automounter is configured on the client side; no server-side configuration is required.'

-> 'The automounter uses the same options as the mount command, including security options.'

-> 'The automounter supports both direct and indirect mount-point mapping, for flexibility in mount-point locations.'

-> 'autofs creates and removes indirect mount points, eliminating manual management.'

-> 'NFS is the default automounter network file system, but other network file systems can be automatically mounted.'

-> 'autofs is a service that is managed like other system services.'


---------------''''''''''''''Creat an automount account''''''''''''''''--------------------


--- A) 'Install the autofs package.'

[user@host ~]# sudo yum install autofs


--- B) 'Add a master map file to /etc/auto.master.d. This file identifies the base directory used for mount points 
and identifies the mapping file used for creating the automounts.'
     
[user@host ~]# sudo vim /etc/auto.master.d/demo.autofs

'Add the master map entry, in this case, for indirectly mapped mounts:
'
/shares  /etc/auto.demo

'This entry uses the /shares directory as the base for indirect automounts. The /etc/auto.demo file contains the mount details. 
Use an absolute file name. The auto.demo file needs to be created before starting the autofs service.'


--- C) 'Create the mapping files. Each mapping file identifies the mount point, mount options, and source location to mount for a set of automounts.'

'The mapping file-naming convention is '/etc/auto.name', where name reflects the content of the map.
'
work  -rw,sync  serverb:/shares/work

'Known as the key in the man pages, the mount point is created and removed automatically by the autofs service. 
In this case, the fully qualified mount point is /shares/work (see the master map file). 
The /shares directory and the /shares/work directories are created and removed as needed by the autofs service.'

'Mount options start with a dash character (-) and are comma-separated with no white space. Mount options available 
to a manual mounting of a file system are available when automounting. In this example, the automounter mounts the share 
with read/write access (rw option), and the server is synchronized immediately during write operations (sync option).'


'Use fstype to specify the file system type, for example, nfs4 or xfs, and use strict to treat errors when mounting file systems as fatal.'

'The source location for NFS shares follows the host:/pathname pattern; in this example, serverb:/shares/work.'


--- D) 'Start and enable the automounter service.'

'Use systemctl to start and enable the autofs service.
'
[user@host ~]# sudo systemctl enable --now autofs
Created symlink /etc/systemd/system/multi-user.target.wants/autofs.service → /usr/lib/systemd/system/autofs.service.



---------------''''''''''''''Direct Maps''''''''''''''''--------------------

'Direct maps are used to map an NFS share to an existing absolute path mount point.

To use directly mapped mount points, the master map file might appear as follows:'

/-  /etc/auto.direct


'All direct map entries use /- as the base directory. In this case, the mapping file that contains the mount details is /etc/auto.direct.
'
'The content for the '/etc/auto.direct' file might appear as follows:
'
/mnt/docs  -rw,sync  serverb:/shares/docs

'In this example the '/mnt' directory exists, and it is not managed by autofs. The full directory 
'/mnt/docs' will be created and removed automatically by the autofs service.'


---------------''''''''''''''Indirect Wildcard Maps''''''''''''''''--------------------


'When an NFS server exports multiple subdirectories within a directory, then the automounter can be configured to access any one of 
those subdirectories using a single mapping entry.

Continuing the previous example, if serverb:/shares exports two or more subdirectories and they are accessible using the same mount options, 
then the content for the /etc/auto.demo file might appear as follows:
'

*  -rw,sync  serverb:/shares/&
