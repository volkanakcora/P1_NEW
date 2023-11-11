The output of the preceding command displays users by name, but internally the operating system uses the UIDs to track users. The mapping of usernames to UIDs is defined in databases of account information. By default, systems use the /etc/passwd file to store information about local users.

Each line in the /etc/passwd file contains information about one user. It is divided up into seven colon-separated fields. Here is an example of a line from /etc/passwd:

1user01:2x:31000:41000:5User One:6/home/user01:7/bin/bash

user01:2x:31000:41000:5User One:6/home/user01:7/bin/bash
1

Username for this user (user01).

2

The user's password used to be stored here in encrypted format. That has been moved to the /etc/shadow file, which will be covered later. This field should always be x.

3

The UID number for this user account (1000).

4

The GID number for this user account's primary group (1000). Groups will be discussed later in this section.

5

The real name for this user (User One).

6

The home directory for this user (/home/user01). This is the initial working directory when the shell starts and contains the user's data and configuration settings.

7

The default shell program for this user, which runs on login (/bin/bash). For a regular user, this is normally the program that provides the user's command-line prompt. A system user might use /sbin/nologin if interactive logins are not allowed for that user.


Membership in supplementary groups is determined by the /etc/group file



usermod options:	Usage
-c, --comment COMMENT	Add the user's real name to the comment field.
-g, --gid GROUP	Specify the primary group for the user account.
-G, --groups GROUPS	Specify a comma-separated list of supplementary groups for the user account.
-a, --append	Used with the -G option to add the supplementary groups to the user's current set of group memberships instead of replacing the set of supplementary groups with a new set.
-d, --home HOME_DIR	Specify a particular home directory for the user account.
-m, --move-home	Move the user's home directory to a new location. Must be used with the -d option.
-s, --shell SHELL	Specify a particular login shell for the user account.
-L, --lock	Lock the user account.
-U, --unlock	Unlock the user account.

Deleting Users from the Command Line

The userdel username command removes the details of username from /etc/passwd, but leaves the user's home directory intact.

The userdel -r username command removes the details of username from /etc/passwd and also deletes the users home directory.

Create the /etc/sudoers.d/admin file such that the members of admin have full administrative privileges.

[root@servera ~]# echo "%admin ALL=(ALL) ALL" >> /etc/sudoers.d/admin

Ensure that the users operator1, operator2 and operator3 belong to the group operators.

Add operator1, operator2, and operator3 to operators.

[root@servera ~]# usermod -aG operators operator1
[root@servera ~]# usermod -aG operators operator2
[root@servera ~]# usermod -aG operators operator3


## Managing User Passwords

Managing User Passwords
Objectives
After completing this section, you should be able to set a password management policy for users, and manually lock and unlock user accounts.

Shadow Passwords and Password Policy
'At one time, encrypted passwords were stored in the world-readable /etc/passwd file. This was thought to be reasonably secure until dictionary attacks on encrypted passwords became common. At that point, the encrypted passwords were moved to a separate /etc/shadow file which is readable only by root. This new file also allowed password aging and expiration features to be implemented.
'
'Like /etc/passwd, each user has a line in the /etc/shadow file. A sample line from /etc/shadow with its nine colon-separated fields is shown below.
'
1user03:2$6$CSsX...output omitted...:317933:40:599999:67:72:818113:9
1

Username of the account this password belongs to.

2

The encrypted password of the user. The format of encrypted passwords is discussed later in this section.

3

The day on which the password was last changed. This is set in days since 1970-01-01, and is calculated in the UTC time zone.

4

The minimum number of days that have to elapse since the last password change before the user can change it again.

5

The maximum number of days that can pass without a password change before the password expires. An empty field means it does not expire based on time since the last change.

6

Warning period. The user will be warned about an expiring password when they login for this number of days before the deadline.

7

Inactivity period. Once the password has expired, it will still be accepted for login for this many days. After this period has elapsed, the account will be locked.

8

The day on which the account expires. This is set in days since 1970-01-01, and is calculated in the UTC time zone. An empty field means it does not expire on a particular date.

9

The last field is usually empty and is reserved for future use.


[user01@host ~]$ sudo chage -m 0 -M 90 -W 7 -I 14 user03
'The preceding chage command uses the -m, -M, -W, and -I options to set the minimum age, maximum age, warning period, and inactivity period of the users password, respectively.
'
The 'chage -d 0 user03' command forces the user03 user to update its password on the next login.

The 'chage -l user03' command displays the password aging details of user03.

The 'chage -E 2019-08-05 user03' command causes the user03 users account to expire on 2019-08-05 (in YYYY-MM-DD format).

'Edit the password aging configuration items in the /etc/login.defs
'
'Determine a date 180 days in the future. Use the format %F with the date command to get the exact value.
'
[student@servera ~]$ date -d "+180 days" +%F
2019-07-24

'You may get a different value to use in the following step based on the current date and time in your system.
'
'Set the account to expire on the date displayed in the preceding step.
'
[student@servera ~]$ # sudo chage -E 2019-07-24 operator1

'Set the passwords to expire 180 days from the current date for all users. Use administrative rights to edit the configuration file.
'
Set PASS_MAX_DAYS to 180 in /etc/login.defs.
Use administrative rights when opening the file with the text editor. You can use the sudo vim /etc/login.defs command to perform this step.