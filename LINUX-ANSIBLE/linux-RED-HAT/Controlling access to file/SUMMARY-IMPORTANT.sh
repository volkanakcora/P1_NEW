'Remove read and write permission for group and other on file1:
'
[user@host ~]# chmod go-rw file1

'Add execute permission for everyone on file2:
'
[user@host ~]$ chmod a+x file2



If the read permission should be present for this access level, add 4.

If the write permission should be present, add 2.

If the execute permission should be present, add 1.


'Set read and write permissions for user, read permission for group and other, on samplefile:
'
[user@host ~]$ chmod 644 samplefile

'Set read, write, and execute permissions for user, read and execute permissions for group, and no permission for other on sampledir:
'
[user@host ~]$ chmod 750 sampledir




'File ownership can be changed with the chown (change owner) command. For example, to grant ownership of the test_file file to the student user, use the following command:
'
[root@host ~]# chown student test_file

'chown can be used with the -R option to recursively change the ownership of an entire directory tree. The following command grants ownership of test_dir and all files and subdirectories within it to student:
'
[root@host ~]# chown -R student test_dir

'The chown command can also be used to change group ownership of a file by preceding the group name with a colon (:). For example, the following command changes the group ownership of the test_dir directory to admins:
'
[root@host ~]# chown :admins test_dir


'Use the chmod command to add write permission to the consultants group.
'
[root@servera ~]# chmod g+w /home/consultants

'se the chmod command to forbid others from accessing files in the /home/consultants directory.
'
[root@servera ~]# chmod 770 /home/consultants
[root@servera ~]# ls -ld /home/consultants
drwxrwx---. 2 root consultants 6 Feb  1 12:08 /home/consultants/



'Verify that the operator1 user is configured as to run any command as any user using sudo.
'
[student@servera ~]$ sudo cat /etc/sudoers.d/operator1
operator1 ALL=(ALL) ALL



'Add the setgid bit on directory:
'
[user@host ~]# chmod g+s directory

'Set the setgid bit and add read/write/execute permissions for user and group, with no access for others, on directory:
'
[user@host ~]# chmod 2770 directory



'Use the umask command to change the umask for the operator1 user to 027. Use the umask command to confirm the change.
'
[operator1@servera ~]$ umask 027
[operator1@servera ~]$ umask
0027

'Use the echo command to change the default umask for the operator1 user to 007.
'
[operator1@servera ~]$ echo "umask 007" >> ~/.bashrc
[operator1@servera ~]$ cat ~/.bashrc
# .bashrc