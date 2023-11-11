'The -g option specifies a particular GID for the group to use.
'
[user01@host ~]# sudo groupadd -g 10000 group01

'The -r option creates a system group using a GID from the range of valid system GIDs 
listed in the /etc/login.defs file. The SYS_GID_MIN and SYS_GID_MAX configuration items in /etc/login.defs define the range of system GIDs.'

[user01@host ~]# sudo groupadd -r group02


'How to change a existing group name':

[user01@host ~]# sudo groupmod -n group0022 group02


'The -g option specifies a new GID.
'
[user01@host ~]# sudo groupmod -g 20000 group0022

'The groupdel command removes groups.
'
[user01@host ~]# sudo groupdel group0022


'The membership of a group is controlled with user management. Use the usermod -g command to change a users primary group.
'
[user01@host ~]# id user02
uid=1006(user02) gid=1008(user02) groups=1008(user02)
[user01@host ~]# sudo usermod -g group01 user02
[user01@host ~]# id user02
uid=1006(user02) gid=10000(group01) groups=10000(group01)


'Use the usermod -aG command to add a user to a supplementary group.
'
[user01@host ~]# id user03
uid=1007(user03) gid=1009(user03) groups=1009(user03)
[user01@host ~]# sudo usermod -aG group01 user03
[user01@host ~]# id user03
uid=1007(user03) gid=1009(user03) groups=1009(user03),10000(group01)





#### USER PASSWORDS ####### chage

[user01@host ~]# sudo chage -m 0 -M 90 -W 7 -I 14 user03

'The preceding chage command uses the -m, -M, -W, and -I options to set the minimum age, 
maximum age, warning period, and inactivity period of the users password, respectively.'

The chage -d 0 user03 command forces the user03 user to update its password on the next login.

The chage -l user03 command displays the password aging details of user03.

The chage -E 2019-08-05 user03 command causes the user03 users account to expire on 2019-08-05 (in YYYY-MM-DD format).


#USERMOD OPTIONS

usermod options:	Usage
-c, '--comment COMMENT	Add the users real name to the comment field.'
-g, '--gid GROUP	Specify the primary group for the user account.'
-G, '--groups GROUPS	Specify a comma-separated list of supplementary groups for the user account.'
-a, --append	'Used with the -G option to add the supplementary groups to the users current set of group memberships instead of replacing the set of supplementary groups with a new set.'
-d, '--home HOME_DIR	Specify a particular home directory for the user account.'
-m, '--move home	Move the users home directory to a new location. Must be used with the -d option.'
-s, '--shell SHELL	Specify a particular login shell for the user account.'
-L, '--lock	Lock the user account.'
-U, '--unlock	Unlock the user account.'

# sudo usermod -L -e 2019-10-05 user03
#[student@servera ~]$ sudo chage -l operator1 -? GET INFO


# The preceding usermod command uses the -e option to set the account expiry date for the given user account. The -L option locks the user's password.





'Determine a date 180 days in the future. Use the format %F with the date command to get the exact value.
'
[student@servera ~]# date -d "+180 days" +%F


'
Configure the permissions on that directory so that any new file in it inherits database as its owning group irrespective to the creating user. The permissions on 
/home/student/grading/review2 should allow the group members of database and the user student to access the 
directory and create contents in it.'

[root@serverb ~]# chmod g+s /home/student/grading/review2


'should allow the group members of database and the user student to access the directory and create contents in it.'

[root@serverb ~]# chmod 775 /home/student/grading/review2

'''All other users should have read and execute permissions on the directory. Also, ensure that the users are only allowed to delete the files, they own, from /home/student/grading/review2 and not others' files.'''

'[root@serverb ~]# chmod o+t /home/student/grading/review2
