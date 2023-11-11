Change the group ownership of the /home/techdocs directory to the techdocs group.

Use the chown command to change the group ownership for the /home/techdocs directory to the techdocs group.

[root@serverb ~]# chown :techdocs /home/techdocs



Verify that users in the techdocs group cannot currently create files in the /home/techdocs directory.

Use the su command to switch to the tech1 user.

[root@serverb ~]# su - tech1
[tech1@serverb ~]$ 
Use touch to create a file named techdoc1.txt in the /home/techdocs directory.

[tech1@serverb ~]$ touch /home/techdocs/techdoc1.txt
touch: cannot touch '/home/techdocs/techdoc1.txt': Permission denied



Set permissions on the /home/techdocs directory. On the /home/techdocs directory, configure setgid (2), read/write/execute permissions (7) for the owner/user and group, and no permissions (0) for other users.

Exit from the tech1 user shell.

[tech1@serverb ~]$ exit
logout
[root@serverb ~]# 
Use the chmod command to set the group permission for the /home/techdocs directory. On the /home/techdocs directory, configure setgid (2), read/write/execute permissions (7) for the owner/user and group, and no permissions (0) for other users.

[root@serverb ~]# chmod 2770 /home/techdocs

Summary
In this chapter, you learned:

Files have three categories to which permissions apply. A file is owned by a user, a single group, and other users. The most specific permission applies. User permissions override group permissions and group permissions override other permissions.

The ls command with the -l option expands the file listing to include both the file permissions and ownership.

The chmod command changes file permissions from the command line. There are two methods to represent permissions, symbolic (letters) and numeric (digits).

The chown command changes file ownership. The -R option recursively changes the ownership of a directory tree.

The umask command without arguments displays the current umask value of the shell. Every process on the system has a umask. The default umask values for Bash are defined in the /etc/profile and /etc/bashrc files.