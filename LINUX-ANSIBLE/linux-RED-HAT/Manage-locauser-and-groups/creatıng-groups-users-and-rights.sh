From workstation, open an SSH session to serverb as student.

On serverb, ensure that newly created users have passwords that must be changed every 30 days.

Set PASS_MAX_DAYS to 30 in /etc/login.defs. Use administrative rights while opening the file with the text editor. 
You can use the sudo vim /etc/login.defs command to perform this step. Use student as the password 
when sudo prompts you to enter the student users password.

...output omitted...
# Password aging controls:
#
#       PASS_MAX_DAYS   Maximum number of days a password may be
#       used.
#       PASS_MIN_DAYS   Minimum number of days allowed between
#       password changes.
#       PASS_MIN_LEN    Minimum acceptable password length.
#       PASS_WARN_AGE   Number of days warning given before a
#       password expires.
#
PASS_MAX_DAYS   30
PASS_MIN_DAYS   0
PASS_MIN_LEN    5
PASS_WARN_AGE   7
...output omitted...
Create the new group called consultants with a GID of 35000.

[student@serverb ~]$ #sudo groupadd -g 35000 consultants
'Configure administrative rights for all members of consultants to be able to execute any command as any user.
' -
'Create the new file /etc/sudoers.d/consultants and add the following content to it. You can use the sudo vim 
/etc/sudoers.d/consultants command to perform this step.
'
#%consultants  ALL=(ALL) ALL
'Create the consultant1, consultant2, and consultant3 users with consultants as their supplementary group.
'
[student@serverb ~]$ #sudo useradd -G consultants consultant1
[student@serverb ~]$ #sudo useradd -G consultants consultant2
[student@serverb ~]$ #sudo useradd -G consultants consultant3

'Change the password policy for the consultant2 account to require a new password every 15 days.
'
[student@serverb ~]$ #sudo chage -M 15 consultant2


Additionally, force the consultant1, consultant2, and consultant3 users to change their passwords on the first login.

Set the last day of the password change to 0 so that the users are forced to change the password whenever they log in to the system for the first time.

[student@serverb ~]$ sudo chage -d 0 consultant1
[student@serverb ~]$ sudo chage -d 0 consultant2
[student@serverb ~]$ sudo chage -d 0 consultant3


'Run usermod -c to update the comments of the operator1 user account.
'
[root@servera ~]# usermod -c "Operator One" operator1



'Use the useradd command to create a new user called dbuser1 that uses the group database as one of its secondary groups.
'
[root@serverb ~]# useradd -G database dbuser1

'Use the passwd command to set the password of dbuser1 to redhat.
'
[root@serverb ~]# passwd dbuser1

'Changing password for user dbuser1.
'New password: redhat
BAD PASSWORD: The password is shorter than 8 characters
Retype new password: redhat
passwd: all authentication tokens updated successfully.

'Use the chage command to force dbuser1 to change its password on first login.
'
[root@serverb ~]# chage -d 0 dbuser1

'Use the chage command to set the minimum age of the password of dbuser1 to 10 days.
'
[root@serverb ~]# chage -m 10 dbuser1

'Use the chage command to set the maximum age of the password of dbuser1 to 30 days.
'
[root@serverb ~]# chage -M 30 dbuser1



#############

'HOW TO CONFIGURE A USER FOR UMASK'

[root@serverb ~]# su - dbuser1
[dbuser1@serverb ~]$ echo "umask 007" >> .bash_profile
[dbuser1@serverb ~]$ echo "umask 007" >> .bashrc