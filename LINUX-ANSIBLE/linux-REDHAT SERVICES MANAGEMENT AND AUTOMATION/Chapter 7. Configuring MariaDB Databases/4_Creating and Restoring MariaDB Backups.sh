                                'Creating and Restoring MariaDB Backups'

'It is very important to back up MariaDB databases, and databases in general. The database often contains most of a companys 
mission-critical data (sales, clients, etc.). Performing backups enables a system administrator to recover data after several types of events:'

- 'Operating system crash'

- 'Power failure'

- 'File system crash'


There are two ways to back up MariaDB:

- 'Logical'

- 'Physical (raw)'





!!!                         'Logical backups have these characteristics:'

-> The database structure is retrieved by querying the database.

-> Logical backups are highly portable, and can be restored to another database provider (such as Postgres) in some cases.

-> Backup is slower because the server must access database information and convert it to a logical format.

-> Performed while the server is online.

-> Backups do not include log or configuration files.



!!!                         'Physical backups have these characteristics:'

-> Consist of raw copies of database directories and folders.

-> Output is more compact.

-> Backups can include log and configuration files.

-> Portable only to other machines with similar hardware and software.

-> Faster than logical backup.

-> Should be performed while the server is offline, or while all tables in the database are locked, preventing changes during the backup.


                                'Performing a logical backup'


'A logical backup can be done with the mysqldump command:'

[root@serverX ~]# mysqldump -u root1 -p2 inventory3 > /backup/inventory.dump4

1 -> User name to connect to MariaDB for backup

2 -> Prompt for password for this user

3 -> Selected database for backup

4 -> Backup file


~~~~~~~~~~~~~~
 To logically back up all databases, use option --all-databases:

[root@serverX ~]# mysqldump -u root -p --all-databases > /backup/mariadb.dump
A dump of this kind will include the mysql database, which includes all user information.  

~~~~~~~~~~~~~



'IMPORTANT'

'mysqldump requires at least the Select privilege for dumped tables, SHOW VIEW for dumped views, and TRIGGER for dumped triggers.'

Table 9.6. Useful Options

Option	                                Description
--add-drop-table	            Tells MariaDB to add a DROP TABLE statement before each CREATE TABLE statement.
--no-data	                    Dumps only the database structure, not the contents.
--lock-all-tables	            No new record can be inserted anywhere in the database while the copy is finished. This option is very important to ensure backup integrity.
--add-drop-database	            Tells MariaDB to add a DROP DATABASE statement before each CREATE DATABASE statement.



                                            'Performing a physical backup'

'The mariabackup tool is provided by the mariadb-backup package from the AppStream repository. The mariabackup tool performs full physical 
online backups of the MariaDB server.'

'Ensure that the mariadb-backup package is installed (should be installed by default when the mariadb-server package is installed):'
[root@host ~]# yum install mariadb-backup


'Create a target directory to store backup files. If you perform a full backup, the target directory must be empty.'
[root@host ~]# mkdir -p /var/mariadb/backup/

'Perform the backup:'
[root@host ~]# mariabackup --backup --target-dir /var/mariadb/backup/  --user root --password redhat


'Confirm the backup directory content:'

[root@host ~]# ls -F /var/mariadb/backup/
aria_log.00000001  ib_buffer_pool  inventory/           xtrabackup_checkpoints
aria_log_control   ibdata1         mysql/               xtrabackup_info
backup-my.cnf      ib_logfile0     performance_schema/





##NOTE: 

NOTE
The alternative to exposing a user name and password on the command line is to create a credentials file in the /etc/my.cnf.d directory to store authentication information for the user who performs the backup.

[root@host ~]# cat /etc/my.cnf.d/mariabackup.cnf
[xtrabackup]
user=root
password=redhat
The alternative to the using the MariaDB root user to perform the backup is to create a user in MariaDB that has RELOAD, LOCK TABLES, and REPLICATION CLIENT privilege









                                            'Restoring a backup'

'Logical restore
'
'A logical restore can be done with the command mysql:'

[root@serverX ~]# mysql -u root1 -p 2 inventory 3 < /backup/mariadb.dump 4 

1 User to connect with to restore the MariaDB backup (generally root or some other superuser)

2 Password for this user

3 Selected database for restore backup

4 Backup file


                                            'Physical restore'

'Use the mariabackup tool with one of the following options to perform a physical restore from backup:'

--copy-back
Retains the original backup files.

--move-back
Moves the backup files to the data directory and then removes the original backup files.


'To Restore a Physical Backup:'

Make sure that the mariadb service is stopped:

[root@host ~]# systemctl stop mariadb
Determine the location of the data directory and make sure it is empty:

[root@host ~]# grep '^datadir' /etc/my.cnf.d/mariadb-server.cnf
datadir=/var/lib/mysql

[root@host ~]# rm -rf /var/lib/mysql/*
Use mariabackup to restore the backup files:

[root@host ~]# mariabackup --copy-back --target-dir=/var/mariadb/backup/
...output omitted...
[00] 2020-06-08 22:26:08 completed OK!
Ensure that the data files have user and group ownership set to mysql:

[root@host ~]# chown -R mysql:mysql /var/lib/mysql/
Start the mariadb service:

[root@host ~]# systemctl start mariadb

