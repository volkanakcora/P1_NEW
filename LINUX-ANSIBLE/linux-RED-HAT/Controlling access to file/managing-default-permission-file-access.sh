#Controlling the default permissions filed created by users


Special Permissions
Special permissions constitute a fourth permission type in addition to the basic user, group, and other types. As the name implies, these permissions provide additional access-related features over and above what the basic permission types allow. This section details the impact of special permissions, summarized in the table below.

Table 7.2. Effects of Special Permissions on Files and Directories

Special permission

Effect on files

Effect on directories

#u+s (suid)

File executes as the user that owns the file, not the user that ran the file.

No effect.

#g+s (sgid)

File executes as the group that owns the file.

Files newly created in the directory have their group owner set to match the group owner of the directory.

#o+t (sticky)

No effect.

Users with write access to the directory can only remove files that they own; they cannot remove or force saves to files owned by other users.


Lastly, the sticky bit for a directory sets a special restriction on deletion of files. Only the owner of the file (and root) can delete files within the directory. An example is /tmp:

[user@host ~]$ ls -ld /tmp
drwxrwxrwt. 39 root root 4096 Feb  8 20:52 /tmp
In a long listing, you can identify the sticky permissions by a lowercase t where you would normally expect the x (other execute permissions) to be. If other does not have execute permissions, this is replaced by an uppercase T.

