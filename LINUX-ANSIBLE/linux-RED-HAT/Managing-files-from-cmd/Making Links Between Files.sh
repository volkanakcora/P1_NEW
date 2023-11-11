Creating Hard Links

'Every file starts with a single hard link, from its initial name to the data on the file system. When you create a new hard link to a file, 
you create another name that points to that same data. The new hard link acts exactly like the original file name. 
Once created, you cannot tell the difference between the new hard link and the original name of the file.

You can find out if a file has multiple hard links with the ls -l command. One of the things it reports is each file 
link count, the number of hard links the file has.'


[user@host ~]$ pwd
/home/user
[user@host ~]$ #ls -l newfile.txt
-rw-r--r--. 1 user user 0 Mar 11 19:19 newfile.txt
In the preceding example, the link count of newfile.txt is 1. It has exactly one absolute path, which is /home/user/newfile.txt.

'You can use the ln command to create a new hard link (another name) that points to an existing file. The command needs at least two arguments, 
a path to the existing file, and the path to the hard link that you want to create.'


The following example creates a hard link named newfile-link2.txt for the existing file newfile.txt in the /tmp directory.

[user@host ~]$ #  ln newfile.txt /tmp/newfile-hlink2.txt
[user@host ~]$ #  ls -l newfile.txt /tmp/newfile-hlink2.txt

-rw-rw-r--. 2 user user 12 Mar 11 19:19 newfile.txt
-rw-rw-r--. 2 user user 12 Mar 11 19:19 /tmp/newfile-hlink2.txt


Creating Soft Links

'The ln -s command creates a soft link, which is also called a "symbolic link." A soft link is not a regular file, 
but a special type of file that points to an existing file or directory.'

Soft links have some advantages over hard links:

'They can link two files on different file systems.
'
'They can point to a directory or special file, not just a regular file.
'

'In the following example, the ln -s command is used to create a new soft link for the existing file 
/home/user/newfile-link2.txt that will be named /tmp/newfile-symlink.txt.'

[user@host ~]$ # ln -s /home/user/newfile-link2.txt /tmp/newfile-symlink.txt
[user@host ~]$ # ls -l newfile-link2.txt /tmp/newfile-symlink.txt

-rw-rw-r--. 1 user user 12 Mar 11 19:19 newfile-link2.txt
lrwxrwxrwx. 1 user user 11 Mar 11 20:59 /tmp/newfile-symlink.txt -> /home/user/newfile-link2.txt

[user@host ~]$ cat /tmp/newfile-symlink.txt
Soft Hello World
