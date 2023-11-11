'Installing MariaDB'


'Relational databases'

A relational database is a mechanism that allows the persistence of data in an organized way. Databases store data items 
organized as a set of tables, with each table representing an entity.


#MariaDB [inventory]> SELECT * FROM product; 
+----+-------------------+---------+-------+-------------+-----------------+
| id | name              | price   | stock | id_category | id_manufacturer |
+----+-------------------+---------+-------+-------------+-----------------+
|  1 | ThinkServer TS140 | 539.88  |    20 |           2 |               4 |
|  2 | ThinkServer TS440 | 1736.00 |    10 |           2 |               4 |
|  3 | RT-AC68U          | 219.99  |    10 |           1 |               3 |
|  4 | X110 64GB         |  73.84  |   100 |           3 |               1 |
+----+-------------------+---------+-------+-------------+-----------------+


#MariaDB [inventory]> SELECT * FROM category; 
+----+------------+
| id | name       |
+----+------------+
|  1 | Networking |
|  2 | Servers    |
|  3 | Ssd        |
+----+------------+



#MariaDB [inventory]> SELECT * FROM manufacturer; 
+----+----------+----------------+-------------------+
| id | name     | seller         | phone_number      |
+----+----------+----------------+-------------------+
|  1 | SanDisk  | John Miller    | +1 (941) 329-8855 |
|  2 | Kingston | Mike Taylor    | +1 (341) 375-9999 |
|  3 | Asus     | Wilson Jackson | +1 (432) 367-8899 |
|  4 | Lenovo   | Allen Scott    | +1 (876) 213-4439 |
+----+----------+----------------+-------------------+


'The previous tables show:'

The product table has four records. Each record has six attributes: (id, name, price, stock, id_category, id_manufacturer).

X110 64GB is an SSD manufactured by SanDisk.

The seller responsible for the ThinkServer TS140 product is Allen Scott.


'There are two relational database packages provided with Red Hat Enterprise Linux 7:'

'PostgreSQL—An' open source database developed by the PostgreSQL Global Development Group, consisting of Postgres users (both individuals and companies) 
and other companies and volunteers, supervised by companies such as Red Hat and EnterpriseDB.

'MariaDB—A' community-developed branch of MySQL built by some of the original authors of MySQL. It offers a rich set of feature enhancements, 
including alternate storage engines, server optimizations, and patches. The MariaDB Foundation works closely and cooperatively with the larger 
community of users and developers in the spirit of free and open source software.




!!!!! ' IMPORTANT ' !!!!!1

'The '/etc/my.cnf' file has default configurations for MariaDB, such as the data directory, socket bindings, and log and error file location.
'
#NOTE

'Instead of adding new configurations to the '/etc/my.cnf' file, a newly created file named *.cnf can 
be added to the '/etc/my.cnf.d/' directory holding the configuration of MariaDB.'





                                        'MariaDB installation demonstration'

'Install MariaDB on serverX with the yum command.
'
[root@serverX ~]# yum groupinstall mariadb mariadb-client -y

'Start the MariaDB service on serverX with the systemctl command.
'

[root@serverX ~]# systemctl start mariadb

[root@host ~]# yum module list mariadb
Updating Subscription Management repositories.
Last metadata expiration check: 1:51:18 ago on Mon 15 Jun 2020 10:30:35 AM CDT.
Red Hat Enterprise Linux 8 for x86_64 - AppStream (RPMs)
Name           Stream         Profiles                          Summary
mariadb        10.3 [d][e]    client, galera, server [d] [i]    MariaDB Module

Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
To install MariaDB 10.3 with all the necessary server and client packages, install the mariadb module using a specific stream.

[root@host ~]# yum module install mariadb:10.3/server

[root@host ~]# systemctl enable --now mariadb

[root@host ~]# firewall-cmd --permanent --add-service=mysql
[root@host ~]# firewall-cmd --reload

!!! ->> The default MariaDB log file is /var/log/mariadb/mariadb.log. This file should be the first place to look when troubleshooting MariaDB.


'Enable the MariaDB service to start at boot on serverX.
'
[root@serverX ~]# systemctl enable mariadb

'Verify the status of the service on serverX.
'
[root@serverX ~]# systemctl status mariadb




                                            'Improve MariaDB installation security'


'MariaDB provides a program to improve security from the baseline install state. Run mysql_secure_installation without arguments:
'
[root@serverX ~]# mysql_secure_installation

This program enables improvement of MariaDB security in the following ways:

- > 'Sets a password for root accounts.'

- > 'Removes root accounts that are accessible from outside the local host'.

- > 'Removes anonymous-user accounts.'

- > 'Removes the test database.'

- > 'The script is fully interactive, and will prompt for each step in the process.'



                                                'MariaDB and networking'


-> When MariaDB is accessed remotely, by default, the server listens for TCP/IP connections on all available interfaces on #port 3306.


                                                'Configuring MariabDB networking'

'MariaDB network configuration directives are found in the '/etc/my.cnf' file, under the [mysqld] section.
'
bind-address

'The server will listen based on this directive. Only one value may be entered. Possible values are:
'
Host name

IPv4 address

IPv6 address

'Set this value to :: to connect to all available addresses (IPv6 and IPv4), or leave blank (or set to 0.0.0.0) for all IPv4 addresses.'

