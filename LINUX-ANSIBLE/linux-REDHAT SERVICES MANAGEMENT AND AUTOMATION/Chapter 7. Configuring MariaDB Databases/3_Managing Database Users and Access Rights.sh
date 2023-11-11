                                                                            'Creating user accounts with MariaDB'

'By default, MariaDB handles authentication and authorization through the user table in the mysql database. This means that the root password for 
the database is persisted in the user table and not in the operating system.'


-- MariaDB [(none)]>  CREATE USER mobius@localhost(1) IDENTIFIED BY 'redhat'(2);


(1) Username/host name for this account

(2) Password for this account


'This user account can only connect from localhost, with the password redhat, and has no privileges. Passwords are encrypted in the user table:'

-- MariaDB [mysql]> SELECT host,user,password FROM user WHERE user = 'mobius';

+-----------+--------+-------------------------------------------+
| host      | user   | password                                  |
+-----------+--------+-------------------------------------------+
| localhost | mobius | *84BB5DF4823DA319BBF86C99624479A198E6EEE9 |
+-----------+--------+-------------------------------------------+
1 row in set (0.00 sec)



'When using this account, before granting any privileges, access will be denied for almost any action:
'
#[root@serverX ~] mysql -u mobius -p
Enter password: redhat

-- MariaDB [(none)]> create database inventory;
ERROR 1044 (42000): Access denied for user 'mobius'@'localhost' to database 'inventory'



$#  Account Examples $#

Account	                            Description
mobius@'localhost'	                User mobius can connect just from localhost.
mobius@'192.168.1.5'	            User mobius can connect from 192.168.1.5 host.
mobius@'192.168.1.%'	            User mobius can connect from any host that belongs to the network 192.168.1.0.
mobius@'%'	                        User mobius can connect from any host.
mobius@'2000:472:18:b51:c32:a21'	User mobius can connect from 2000:472:18:b51:c32:a21 host.





                                                                        'Granting and revoking privileges for user accounts'


- 'Global privileges, such as CREATE USER and SHOW DATABASES, for administration of the database server itself.'

- 'Database privileges, such as CREATE for creating databases and working with databases on the server at a high level.'

- 'Table privileges, such as the CRUD commands, for creating tables and manipulating data in the database.'

- 'Column privileges, for granting table-like command usage, but on a particular column (generally rare).'

- 'Other, more granular privileges, which are discussed in detail in the MariaDB documentation.'



--- The GRANT statement can be used to grant privileges to accounts. The connected user must have the GRANT OPTION privilege (a special privilege that exists at several levels) to grant privileges.
A user may only grant privileges to others that have already been granted to that user.



[root@serverX ~]# mysql -u mobius -p
Enter password: redhat
MariaDB [(none)]> use inventory;
MariaDB [(inventory)]> select * from category;
ERROR 1142 (42000): SELECT command denied to user 'mobius'@'localhost' for table 'category'
MariaDB [(inventory)]> exit
[root@serverX ~]# mysql -u root -p
Enter password: redhat
MariaDB [(none)]> use inventory;
MariaDB [(inventory)]> GRANT SELECT, UPDATE, DELETE, INSERT1 on inventory.category2 to mobius@localhost3;
Query OK, 0 rows affected (0.00 sec)
MariaDB [(inventory)]> exit  
[root@serverX ~]# mysql -u mobius -p
Enter password: redhat
MariaDB [(none)]> use inventory;
MariaDB [(inventory)]> select * from category;
+----+------------+
| id | name       |
+----+------------+
|  1 | Networking |
|  2 | Servers    |
|  3 | Ssd        |
+----+------------+
3 rows in set (0.00 sec)     # EXECUTE MariaDB [(none)]> FLUSH PRIVILEGES; AFTER ANY CHANGES



'GRANT EXAMPLES'

Grant	                                                        Description
GRANT SELECT ON database.table TO username@hostname	            Grant select privilege for a specific table in a specific database to a specific user.
GRANT SELECT ON database.* TO username@hostname	                Grant select privilege for all tables in a specific database to a specific user.
GRANT SELECT ON *.* TO username@hostname	                    Grant select privilege for all tables in all databases to a specific user.
GRANT CREATE, ALTER, DROP ON database.* to username@hostname	Grant privilege to create, alter, and drop tables in a specific database to a specific user.
GRANT ALL PRIVILEGES ON *.* to username@hostname	            Grant all available privileges for all databases to a specific user, effectively creating a superuser, similar to root.



'The 'REVOKE' statement allows for revoking privileges from accounts. The connected user must have the GRANT OPTION privilege and have the privileges that are being revoked to revoke a privilege.
'
-- MariaDB [(none)]> REVOKE SELECT, UPDATE, DELETE, INSERT1 on inventory.category2 from mobius@localhost3;
Query OK, 0 rows affected (0.00 sec) 



!!!!!!!!!~~~~~~~~~!!!!!!!! After granting or revoking a privilege, reload all privileges from the privileges tables in the mysql database.

-- MariaDB [(none)]> FLUSH PRIVILEGES;



'In order to revoke privileges, the list of privileges granted to a user will be needed. The simple command 
'SHOW GRANTS' FOR username; will provide the list of privileges for that user:'


-- MariaDB [(none)]> SHOW GRANTS FOR root@localhost;
+---------------------------------------------------------------------+
| Grants for root@localhost                                           |
+---------------------------------------------------------------------+
| GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION |
| GRANT PROXY ON ''@'' TO 'root'@'localhost' WITH GRANT OPTION        |
+---------------------------------------------------------------------+

Dropping User Accounts

    
'When a user is no longer required, it can be deleted from the database using 'DROP USER username';. The username should use the same 'user'@'host' format used for CREATE USER.'





                                                    'Troubleshooting database access'
                                                    
                                                    Table 9.4. Some Common DB Access Issues

Issue	Solution
User has been granted access to connect from any host, but can only connect on localhost using the mysql command (applications he or she uses cannot connect, even on localhost).	Remove the skip-networking directive from my.cnf and restart the service.
User can connect with any application on localhost, but not remotely.	Check the bind-address configuration in my.cnf to ensure the database is accessible.
Ensure that the user table includes an entry for the user from the host he is trying to connect from.

User can connect, but cannot see any database other than information_schema and test.	Common problem when a user has just been created, as they have no privileges by default, though they can connect and use those default databases. Add grants for the database the user requires.
User can connect, but cannot create any databases.	Grant the user the global CREATE privilege (this also grants DROP privileges).
User can connect, but cannot read or write any data.	Grant the user the CRUD privileges for only the database he or she will be using.



## NICE COMMANDS

MariaDB [(none)]> CREATE USER mobius@localhost1 IDENTIFIED BY 'redhat'2;

MariaDB [mysql]> SELECT host,user,password FROM user WHERE user = 'mobius';


MariaDB [(none)]> SHOW DATABASES;


RANT SELECT, UPDATE, DELETE, INSERT ON inventory.category TO mobius@localhost;

MariaDB [(none)]> REVOKE SELECT, UPDATE, DELETE, INSERT ON inventory.category FROM mobius@localhost;


MariaDB [(none)]> SHOW GRANTS FOR root@localhost;

MariaDB [(none)]> DROP USER mobius;


Verify the INSERT privilege.

MariaDB [inventory]> INSERT INTO category(name) VALUES('Memory');
Query OK, 1 row affected (0.00 sec)
Verify the UPDATE privilege.

MariaDB [inventory]> UPDATE category SET name='Solid State Drive' WHERE id = 3;
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0