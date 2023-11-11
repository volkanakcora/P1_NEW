'''The first line of a script begins with the notation #! 
commonly referred to as sh-bang or she-bang, from the names of those two characters, sharp and bang. 
This specific two-byte magic number notation indicates an interpretive script; syntax that follows the notation is the fully-qualified 
filename for the correct command interpreter needed to process this scripts lines. To understand how magic numbers indicate file types in 
Linux, see the file(1) and magic(5) man pages. For script files using Bash scripting syntax, the first line of a shell script begins as follows:
'''
#!/bin/bash

'The backslash escape character removes the special meaning of the single character immediately following it. 
For example, to display the literal string '#' not a comment with the echo command, the '#' sign must not be interpreted by 
Bash as having special meaning. Place the backslash character in front of the # sign.'

[user@host ~]$ echo # not a comment

[user@host ~]$ echo \# not a comment
# not a comment

you can use this or either this: 

echo \# not a comment \#
# not a comment #
[user@host ~]$ echo '# not a comment #'
# not a comment #


## writing first script

vim firstscript.sh 
->
'''
#!/bin/bash
#
echo "This is my first bash script" > ~/output.txt
echo "" >> ~/output.txt
echo "#####################################################" >> ~/output.txt
echo "LIST BLOCK DEVICES" >> ~/output.txt
echo "" >> ~/output.txt
lsblk >> ~/output.txt
echo "" >> ~/output.txt
echo "#####################################################" >> ~/output.txt
echo "FILESYSTEM FREE SPACE STATUS" >> ~/output.txt
echo "" >> ~/output.txt
df -h >> ~/output.txt
echo "#####################################################" >> ~/output.txt
'''

chmod a+x firsscript.sh  ->> to make it executable

Using Loops to Iterate Commands


[user@host ~]$ for HOST in host1 host2 host3; do echo $HOST; done
host1
host2
host3
[user@host ~]$ for HOST in host{1,2,3}; do echo $HOST; done
host1
host2
host3
[user@host ~]$ for HOST in host{1..3}; do echo $HOST; done
host1
host2
host3
[user@host ~]$ for FILE in file*; do ls $FILE; done
filea
fileb
filec

for EVEN in $(seq 2 2 10); do echo '$EVEN'; done

''Testing script inputs'' 

'Like all commands, the test command produces an exit code upon completion, which is stored as the value $?. To see the conclusion of a test, 
display the value of $? immediately following the execution of the test command. Again, an exit status value of 0 indicates the test succeeded, 
and nonzero values indicate the test failed.'

The following examples demonstrate the use of the test command using Bash's numeric comparison operators.

[user@host ~]$ test 1 -gt 0 ; echo $?
0
[user@host ~]$ test 0 -gt 1 ; echo $?
1

[user@host ~]$ [ abc = abc ]; echo $?
0
[user@host ~]$ [ abc == def ]; echo $?
1

'''Conditionals''''


'The following code section demonstrates the use of an if/then/elif/then/else statement to run the mysql client if the mariadb service is active, 
run the psql client if the postgresql service is active, or run the sqlite3 client if both the mariadb and postgresql services are not active.'

[user@host ~]# systemctl is-active mariadb > /dev/null 2>&1
MARIADB_ACTIVE=$?
[user@host ~]# sudo systemctl is-active postgresql > /dev/null 2>&1
POSTGRESQL_ACTIVE=$?
[user@host ~] if  [ "$MARIADB_ACTIVE" -eq 0 ]; then
> mysql
> elif  [ "$POSTGRESQL_ACTIVE" -eq 0 ]; then
> psql
> else
> sqlite3
> fi

[student@workstation ~]$ vim ~/bin/printhostname.sh
[student@workstation ~]$ cat ~/bin/printhostname.sh
#!/bin/bash
#Execute for loop to print server hostname.
for HOST in servera serverb
do
  ssh student@${HOST} hostname
done
exit 0


'''GREP'''

Table 1.2. Table of Common grep Options

Option	Function
-i	'Use the regular expression provided but do not enforce case sensitivity (run case-insensitive).'
-v	'Only display lines that do not contain matches to the regular expression.'
-r	'Apply the search for data matching the regular expression recursively to a group of files or directories.'
-A 'NUMBER	Display NUMBER of lines after the regular expression match.'
-B 'NUMBER	Display NUMBER of lines before the regular expression match.'
-e	'With multiple -e options used, multiple regular expressions can be supplied and will be used with a logical OR.
'

#grep -v -i server /etc/hosts  /// -v option is very useful. The -v option only displays lines that do not match the regular expression.
'
The grep command with the -e option allows you to search for more than one regular expression at a time. The following example, 
using a combination of less and grep, locates all occurrences of pam_unix, user root and Accepted publickey in the /var/log/secure log file.'

[root@host ~]# cat /var/log/secure | grep -e 'pam_unix' -e 'user root' -e 'Accepted publickey' | less
Mar 19 08:04:46 host sshd[6141]: pam_unix(sshd:session): session opened for user root by (uid=0)
Mar 19 08:04:50 host sshd[6144]: Disconnected from user root 172.25.250.254 port 41170
Mar 19 08:04:50 host sshd[6141]: pam_unix(sshd:session): session closed for user root
Mar 19 08:04:53 host sshd[6168]: Accepted publickey for student from 172.25.250.254 port 41172 ssh2: RSA SHA256:M8ikhcEDm2tQ95Z0o7ZvufqEixCFCt+wowZLNzNlBT0


grep 'postfix' /var/log/ | head -n 2 

grep -i 'queue' /etc/postfix/main.cf -> not case sensetive 


'Confirm that the qmgr, cleanup, and pickup queues are correctly configured. Use the grep command with the -e option to match multiple entries 
in the same file. The configuration file is /etc/postfix/master.cf'

[root@servera ~]# grep -e qmgr -e pickup -e cleanup /etc/postfix/master.cf
pickup    unix  n       -       n       60      1       pickup
cleanup   unix  n       -       n       -       0       cleanup
qmgr      unix  n       -       n       300     1       qmgr
qmgr     unix  n       -       n       300     1       oqmgr


Example bash script=

#!/bin/bash
#
USR='student'
OUT='/home/student/output'
#
for SRV in servera serverb
  do
ssh ${USR}@${SRV} "hostname -f" > ${OUT}-${SRV}
echo "#####" >> ${OUT}-${SRV}
ssh ${USR}@${SRV} "lscpu | grep '^CPU'" >> ${OUT}-${SRV}
echo "#####" >> ${OUT}-${SRV}
ssh ${USR}@${SRV} "grep -v '^$' /etc/selinux/config|grep -v '^#'" >> ${OUT}-${SRV}
echo "#####" >> ${OUT}-${SRV}
ssh ${USR}@${SRV} "sudo grep 'Failed password' /var/log/secure" >> ${OUT}-${SRV}
echo "#####" >> ${OUT}-${SRV}
done