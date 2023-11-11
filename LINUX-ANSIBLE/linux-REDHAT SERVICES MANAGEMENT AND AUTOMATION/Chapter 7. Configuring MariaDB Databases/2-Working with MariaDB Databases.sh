'Working with MariaDB Databases'


                                                        'Creating a database'

'The installation of the mariadb-client group provides a program called mysql. With this program, it is possible to connect to a local or 
remote MariaDB database server.'

[root@serverX ~]# mysql -u root -h localhost -p


'A database in MariaDB is implemented as a directory. The default installation has four databases. To list the databases, run the command:
'

-- MariaDB [(none)]> SHOW DATABASES;

+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| test               |
+--------------------+

'To create a new database, run the command:'

-- MariaDB [(none)]> CREATE DATABASE inventory;


'After the creation of the new database, the next step is to connect to this database so that it can be populated with tables and data:'


-- MariaDB [(none)]> USE inventory;



'MariaDB (like all relational database systems) can have multiple tables per database. List the tables with the 'SHOW TABLES;' command:'

-- MariaDB [(mysql)]>  DESCRIBE servers;
+-------------+----------+------+-----+---------+-------+
| Field       | Type     | Null | Key | Default | Extra |
+-------------+----------+------+-----+---------+-------+
| Server_name | char(64) | NO   | PRI |         |       |
| Host        | char(64) | NO   |     |         |       |
| Db          | char(64) | NO   |     |         |       |
| Username    | char(64) | NO   |     |         |       |
| Password    | char(64) | NO   |     |         |       |
| Port        | int(4)   | NO   |     | 0       |       |
| Socket      | char(64) | NO   |     |         |       |
| Wrapper     | char(64) | NO   |     |         |       |
| Owner       | char(64) | NO   |     |         |       |
+-------------+----------+------+-----+---------+-------+



                                                    'Using SQL: Structured Query Language'

'To insert data into a table, the first step is to figure out the attributes of the table.
'
-- MariaDB [(inventory)]>  DESCRIBE product;
+-----------------+--------------+------+-----+---------+----------------+
| Field           | Type         | Null | Key | Default | Extra          |
+-----------------+--------------+------+-----+---------+----------------+
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| name            | varchar(100) | NO   |     | NULL    |                |
| price           | double       | NO   |     | NULL    |                |
| stock           | int(11)      | NO   |     | NULL    |                |
| id_category     | int(11)      | NO   |     | NULL    |                |
| id_manufacturer | int(11)      | NO   |     | NULL    |                |
+-----------------+--------------+------+-----+---------+----------------+



'In this example, all attributes are required. To insert a new product, the command will be rather long and complicated:'    # INSERT


-- MariaDB [(inventory)]>  INSERT INTO product(name,price,stock,id_category,id_manufacturer)    VALUES ('SDSSDP-128G-G25 2.5',82.04,30,3,1);
Query OK, 1 row affected (0.00 sec)  


'Delete a record with the delete statement:'   # DELETE       !!!!!!If the where clause is not specified, all records in the table will be erased. This is the database equivalent of running rm -rf /.


-- MariaDB [(inventory)]>  DELETE FROM product WHERE id = 1 ;
Query OK, 1 row affected (0.01 sec)




'o update a record, use an update statement:' #UPDATE  !!!!If the where clause is not specified, all records will be updated.

-- MariaDB [(inventory)]>  UPDATE product SET price=89.90, stock=60 WHERE id = 5 ;
 Query OK, 1 row affected (0.01 sec)

UPDATE tbxi035_config SET config_value= 'timo.caspar@swissgrid.ch' where id = 294311;

UPDATE tbxi035_config SET config_value= 'timo.caspar@swissgrid.ch' WHERE config_key = 'SECONDARY_EMAIL_RECEIVER_ATC_VALUES_REPORT_V2' AND party_id = '10XCH-SWISSGRIDC';

'To read data records from the database, use the select statement:'   #READ


-- MariaDB [(inventory)]>  SELECT name,price,stock('attributes name') FROM product('table name');
+---------------------+--------+-------+
| name                | price  | stock |
+---------------------+--------+-------+
| ThinkServer TS140   | 539.88 |    20 |
| RT-AC68U            | 219.99 |    10 |
| X110 64GB           |  73.84 |   100 |
| SDSSDP-128G-G25 2.5 |  82.04 |    30 |
+---------------------+--------+-------+


'To select all attributes, use the wild card *:'  #SELECT ALL

-- MariaDB [(inventory)]>  SELECT * FROM product;
+----+---------------------+--------+-------+-------------+-----------------+
| id | name                | price  | stock | id_category | id_manufacturer |
+----+---------------------+--------+-------+-------------+-----------------+
|  2 | ThinkServer TS140   | 539.88 |    20 |           2 |               4 |
|  3 | RT-AC68U            | 219.99 |    10 |           1 |               3 |
|  4 | X110 64GB           |  73.84 |   100 |           3 |               1 |
|  5 | SDSSDP-128G-G25 2.5 |  82.04 |    30 |           3 |               1 |
+----+---------------------+--------+-------+-------------+-----------------+


'Filter results with the where clause:'  #FILTER 

-- MariaDB [(inventory)]>  SELECT * FROM product WHERE price > 100;
+----+-------------------+--------+-------+-------------+-----------------+
| id | name              | price  | stock | id_category | id_manufacturer |
+----+-------------------+--------+-------+-------------+-----------------+
|  2 | ThinkServer TS140 | 539.88 |    20 |           2 |               4 |
|  3 | RT-AC68U          | 219.99 |    10 |           1 |               3 |
+----+-------------------+--------+-------+-------------+-----------------+

DELETE FROM m7_999_revision_index WHERE index > 20848939485888512;

'Common Operators for where Clauses
'

=	                'Equal'
<>	                'Not equal. Note: In some versions of SQL, this operator may be written as !='
>	                'Greater than'
<	                'Less than'
>=	                'Greater than or equal'
<=	                'Less than or equal'
BETWEEN	            'Between an inclusive range'
LIKE	            'Search for a pattern'
IN	                'To specify multiple possible values for a column'



Objective	Statement
'Describe a table'	                                 DESCRIBE table_name;
'Update a record in the table'	                     UPDATE table_name SET attribute=value WHERE attribute > value;
'Connect to a specific database'	                 USE database_name;
'List databases available in '                       MariaDB	SHOW DATABASES;
'List tables available in a database'	             SHOW TABLES;
'Select data records from a table'	                 SELECT * FROM table_name;
'Delete records from a table	  '                  DELETE FROM table_name WHERE attribute = value;



