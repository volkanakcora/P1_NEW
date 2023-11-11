Changing Permissions with the Symbolic Method

chmod WhoWhatWhich file|directory
Who is u, g, o, a (for user, group, other, all)

What is +, -, = (for add, remove, set exactly)

Which is r, w, x (for read, write, execute)

With the symbolic method, it is not necessary to set a complete new group of permissions. 
Instead, you can change one or more of the existing permissions. 
Use + or - to add or remove permissions, respectively, or use = to replace the entire set for a group of permissions.


Examples

Remove read and write permission for group and other on file1:

[user@host ~]#$ chmod go-rw file1
Add execute permission for everyone on file2:

[user@host ~]#$ chmod a+x file2

##The digit is calculated by adding together numbers for each permission you want to add, 4 for read, 2 for write, and 1 for execute.

Using the numeric method, permissions are represented by a 3-digit (or 4-digit, when setting advanced permissions) octal number. A single octal digit can represent any single value from 0-7.

In the 3-digit octal (numeric) representation of permissions, each digit stands for one access level, from left to right: user, group, and other. To determine each digit:

Start with 0.

If the read permission should be present for this access level, add 4.

If the write permission should be present, add 2.

If the execute permission should be present, add 1.


File ownership can be changed with the chown (change owner) command. For example, to grant ownership of the 
test_file file to the student user, use the following command:

[root@host ~]# chown student test_file

chown can be used with the -R option to recursively change the ownership of an entire directory tree. 
The following command grants ownership of test_dir and all files and subdirectories within it to student:

[root@host ~]# chown -R student test_dir

The chown command can also be used to change group ownership of a file by preceding the group name with a colon (:). For example, the following command changes the group ownership of the test_dir directory to admins:

[root@host ~]# chown :admins test_dir

The chown command can also be used to change both owner and group at the same time by using the owner:group syntax. For example, to change the ownership of test_dir to visitor and the group to guests, use the following command:

[root@host ~]# chown visitor:guests test_dir


###EXERCISES

Use the mkdir command to create the /home/consultants directory.

[root@servera ~]# mkdir /home/consultants
Use the chown command to change the group ownership of the consultants directory to consultants.

[root@servera ~]# chown :consultants /home/consultants
Ensure that the permissions of the consultants group allow its group members to create files in, and delete files from the /home/consultants directory. The permissions should forbid others from accessing the files.

Use the ls command to confirm that the permissions of the consultants group allow its group members to create files in, and delete files from the /home/consultants directory.

[root@servera ~]# ls -ld /home/consultants
drwxr-xr-x.  2 root    consultants       6 Feb  1 12:08 /home/consultants
Note that the consultants group currently does not have write permission.

Use the chmod command to add write permission to the consultants group.

[root@servera ~]# chmod g+w /home/consultants
[root@servera ~]# ls -ld /home/consultants
drwxrwxr-x. 2 root consultants 6 Feb  1 13:21 /home/consultants 
Use the chmod command to forbid others from accessing files in the /home/consultants directory.

[root@servera ~]# chmod 770 /home/consultants
[root@servera ~]# ls -ld /home/consultants
drwxrwx---. 2 root consultants 6 Feb  1 12:08 /home/consultants/


###Use the umask command with a single numeric argument to change the umask of the current shell. The numeric argument should be an octal value corresponding to the new umask value. You can omit any leading zeros in the umask.

The systems default umask values for Bash shell users are defined in the /etc/profile and /etc/bashrc files. Users can override the system defaults in the .bash_profile and .bashrc files in their home directories 
###

UMASK Examples

"umask Example

The following example explains how the umask affects the permissions of files and directories. Look at the default umask permissions for both files and directories in the current shell. The owner and group both have read and write permission on files, and other is set to read. The owner and group both have read, write, and execute permissions on directories. The only permission for other is read.

[user@host ~]$ umask
0002
[user@host ~]$ touch default
[user@host ~]$ ls -l default.txt
-rw-rw-r--. 1 user user 0 May  9 01:54 default.txt
[user@host ~]$ mkdir default
[user@host ~]$ ls -ld default
drwxrwxr-x. 2 user user 0 May  9 01:54 default 
By setting the umask value to 0, the file permissions for other change from read to read and write. The directory permissions for other changes from read and execute to read, write, and execute.

[user@host ~]$ umask 0
[user@host ~]$ touch zero.txt
[user@host ~]$ ls -l zero.txt
-rw-rw-rw-. 1 user user 0 May  9 01:54 zero.txt
[user@host ~]$ mkdir zero
[user@host ~]$ ls -ld zero
drwxrwxrwx. 2 user user 0 May  9 01:54 zero 
To mask all file and directory permissions for other, set the umask value to 007.

[user@host ~]$ umask 007
[user@host ~]$ touch seven.txt
[user@host ~]$ ls -l seven.txt
-rw-rw----. 1 user user 0 May  9 01:55 seven.txt
[user@host ~]$ mkdir seven
[user@host ~]$ ls -ld seven
drwxrwx---. 2 user user 0 May  9 01:54 seven"


The default umask for users is set by the shell startup scripts. By default, if your account's UID is 200 or more and your username and primary group name are the same, you will be assigned a umask of 002. Otherwise, your umask will be 022.

As root, you can change this by adding a shell startup script named /etc/profile.d/local-umask.sh 
that looks something like the output in this example:

[root@host ~]# cat /etc/profile.d/local-umask.sh
# Overrides default umask configuration
if [ $UID -gt 199 ] && [ "`id -gn`" = "`id -un`" ]; then
    umask 007
else
    umask 022
fi