Objectives
'After completing this section, you should be able to search for files on mounted file systems using find and locate.'

Searching for Files
A system administrator needs tools to search for files matching certain criteria on the file system. 
This section discusses two commands that can search for files in the file-system hierarchy.

The locate command searches a pregenerated index for file names or file paths and returns the results instantly.

The find command searches for files in real time by crawling through the file-system hierarchy.


'Locating Files by Name
The locate command finds files based on the name or path to the file. It is fast because it looks up this information from the mlocate database. 
However, this database is not updated in real time, and it must be frequently updated for results to be accurate. This also means that locate will 
not find files that have been created since the last update of the database.'

'The locate database is automatically updated every day. However, at any time the root user can issue the updatedb command to force an immediate update.
'
[root@host ~]# updatedb

'Search for files with passwd in the name or path in directory trees readable by user on host.
'
[user@host ~]$ locate passwd
/etc/passwd
/etc/passwd-

'The -i option performs a case-insensitive search. With this option, all possible combinations of upper and lowercase letters match the search.
'
[user@host ~]$ locate -i messages

'The -n option limits the number of returned search results by the locate command. The following example limits the search results returned by locate to the first five matches:
'
[user@host ~]$ locate -n 5 snow.png
/usr/share/icons/HighContrast/16x16/status/weather-snow.png

####FIND 

'The first argument to the find command is the directory to search. 
If the directory argument is omitted, find starts the search in the current directory and looks for matches in any subdirectory.

To search for files by file name, use the -name FILENAME option. With this option, 
find returns the path to files matching FILENAME exactly. For example, to search for files named sshd_config starting from the / directory, run the following command:'

[root@host ~]# find / -name sshd_config
/etc/ssh/sshd_config


'in the following example, search for files starting in the / directory that end in .txt:'

[root@host ~]# find / -name '*.txt'

'To search for files in the /etc/ directory that contain the word, pass, anywhere in their names on host, run the following command:
'
[root@host ~]# find /etc -name '*pass*'
/etc/security/opasswd


'To perform a case-insensitive search for a given file name, use the -iname option, followed by the file name to search. To search files with case-insensitive text, messages, in their names in the / directory on host, run the following command:
'
[root@host ~]# find / -iname '*messages*'
...output omitted...
/usr/share/vim/vim80/lang/zh_CN.UTF-8/LC_MESSAGES

'Searching Files Based on Modification Time

The -mmin option, followed by the time in minutes, searches for all files that had their content changed at n minutes ago in the past. The files 
timestamp is always rounded down. It also supports fractional values when used with ranges (+n and -n).'

'To find all files that had their file content changed 120 minutes ago on host, run:
'
[root@host ~]# find / -mmin 120

'The + modifier in front of the amount of minutes looks for all files in the / that have been modified more than n minutes ago. In this example, 
files that were modified more than 200 minutes ago are listed.
'
[root@host ~]# find / -mmin +200

'Searching Files Based on File Type

The -type option in the find command limits the search scope to a given file type. Use the following list to pass the required flags to limit the scope of search:'

f, for regular file

d, for directory

l, for soft link

b, for block device

'Search for all directories in the /etc directory on host.
'
[root@host ~]# find /etc -type d
/etc
/etc/tmpfiles.d
/etc/systemd
/etc/systemd/system
/etc/systemd/system/getty.target.wants
...output omitted...
Search for all soft links on host.

[root@host ~]# find / -type l

'Generate a list of all block devices in the /dev directory on host:
'
[root@host ~]# find /dev -type b
/dev/vda1




###questions

'Search all files in the /var/lib directory that are owned by the chrony user.
'
[student@servera ~]$ sudo find /var/lib -user chrony

'List all files in the /usr/bin directory with a file size greater than 50 KB.
'
[student@servera ~]$ find /usr/bin -size +50k

'Find all files in the /home/student directory that have not been changed in the last 120 minutes.
'
[student@servera ~]$ find /home/student -mmin +120

'List all block device files in the /dev directory.
'
[student@servera ~]$ find /dev -type b







