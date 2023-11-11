''Administering Containers with Podman
'You can use Podman to run containers with more advanced configuration options and manage running or stopped containers. '



Mapping Container Host Ports to the Container


'When you map a network port on the container host to a port in the container, network traffic sent to the host network port is received by the container.
'
'For example, you could map port 8000 on the container host to port 8080 on the container. The container might be running an httpd process that is listening on port 8080. 
Therefore, traffic sent to the container host port 8000 would be received by the web server running in the container.'

'
Set up a port mapping with podman run by using the '-p' option. It takes two colon-separated port numbers, 'the port on the container host', 
followed 'by the port in the container'.'

'The following example uses the '-d' option to run the container in 'detached mode (as a daemon)'. When using the -d option, podman returns only the 
container ID to the screen. 'The -p 8000:8080 option' maps port '8000 on the container host to port 8080 in the container'. 
The container image registry.redhat.io/rhel8/httpd-24 runs an Apache HTTP Server that listens for connections on port 8080.
'
#[user@host ~]$ podman run -d -p 8000:8080 registry.redhat.io/rhel8/httpd-24
4a24ee199b909cc7900f2cd73c07e6fce9bd3f53b14e6757e91368c561a8edf4
[user@host ~]$ 



'ou can use the podman port command with a container ID or name to list its port mappings, or with the '-a' option to list all port mappings in use.'


#[user@host ~]$ podman port -a
4a24ee199b90    8080/tcp -> 0.0.0.0:8000



'You must also make sure that the firewall on your container host allows external clients to connect to its mapped port. In the preceding example, 
you might also have to add port 8000/tcp to your current firewall rules on the container host:'

[root@host ~]# firewall-cmd --add-port=8000/tcp
success



Passing Environment Variables to Configure a Container

'Configuring a container can be complex because you usually do not want to modify the container image in order to configure. However, you can pass environment variables to the container, 
and the container can use the values of these environment variables to configure its application.'


'To get information on what variables are available and what they do, use the podman inspect command to inspect the container image. For example, 
here is a container image from one of the Red Hat registries:'

#[user@host ~]$ podman inspect registry.redhat.io/rhel8/mariadb-103:1-102
[
  {
...output omitted...
    "Labels": {
...output omitted...
      "name": "rhel8/mariadb-103",
      "release": "102",
      "summary": "MariaDB 10.3 SQL database server",
      "url": "https://access.redhat.com/containers/#/registry.access.redhat.com/rhel8/mariadb-103/images/1-102",
      "usage": "podman run -d -e MYSQL_USER=user -e MYSQL_PASSWORD=pass -e MYSQL_DATABASE=db -p 3306:3306 rhel8/mariadb-103",
      "vcs-ref": "ab3c3f15b6180b967a312c93e82743e842a4ac7c",
      "vcs-type": "git",
      "vendor": "Red Hat, Inc.",
      "version": "1"
  },
...output omitted...


'
Use the podman run command with the -e option to pass environment variables to a process inside the container. In the following example, 
environment and port options apply configuration settings to the container.'

#[user@host ~]$ podman run -d --name container_name -e MYSQL_USER=user_name -e MYSQL_PASSWORD=user_password -e MYSQL_DATABASE=database_name -⁠e 
#MYSQL_ROOT_PASSWORD=mysql_root_password -p 3306:3306 registry.redhat.io/⁠rhel8/⁠mariadb-103:1-102
abcb42ef2ff1b85a50e3cd9bc15877ef823979c8166d0076ce5ebc5ea19c0815





-----------------------------------------Managing Containers--------------------------------------

The podman ps command lists running containers:

[user@host ~]$ podman ps
CONTAINER ID     IMAGE                                              COMMAND
89dd9b6354ba '1'   registry.redhat.io/rhel8/mariadb-103:1-102 '2'       run-mysqld '3'

CREATED            STATUS                           PORTS                     NAMES
10 minutes ago'4' Up 10 seconds '5'          0.0.0.0:3306->3306/tcp'6'      my-database'7'


1

Each container, when created, is assigned a unique hexadecimal container ID. The container ID is unrelated to the image ID.

2

Container image that was used to start the container.

3

Command executed when the container started.

4

Date and time the container was started.

5

Total container uptime, if still running, or time since terminated.

6

Ports that were exposed by the container or any port forwarding that might be configured.

7

The container name.




'The podman ps '-a' command lists all containers, including stopped ones:
'
[user@host ~]$ podman ps -a
CONTAINER ID     IMAGE                                            COMMAND
30b743973e98     registry.redhat.io/rhel8/httpd-24:1-105          /bin/bash

CREATED          STATUS                    PORTS                  NAMES
17 minutes ago   Exited (0) 18 minutes ago 80/tcp                 my-httpd





'The podman stop command stops a running container gracefully. The stop command sends a SIGTERM signal to terminate a running container. 
If the container does not stop after a grace period (10 seconds by default), Podman sends a SIGKILL signal.'

#[user@host ~]$ podman stop my-httpd-container
77d4b7b8ed1fd57449163bcb0b78d205e70d2314273263ab941c0c371ad56412

!!!IMPORTANT
'If a container image is used by a container that is stopped, the image cannot be deleted with podman rmi or podman image rm, unless you 
include the -f option, which will remove all 
containers using the image first.'



'The podman rm command removes a container from the host. The container must be stopped unless you include the -f option'

#[user@host ~]$ podman rm my-database
abcb42ef2ff1b85a50e3cd9bc15877ef823979c8166d0076ce5ebc5ea19c0815


'The podman restart command restarts a stopped container.' 
#[user@host ~]$ podman restart my-httpd-container
77d4b7b8ed1fd57449163bcb0b78d205e70d2314273263ab941c0c371ad56412





'The podman kill command sends UNIX signals to the main process in the container. These are the same signals used by the kill command.
'
'This can be useful if the main process in the container can take actions when it receives certain signals, or for troubleshooting purposes. 
If no signal is specified, podman kill sends the SIGKILL signal, terminating the main process and the container.'

#[user@host ~]$ podman kill my-httpd-containe
77d4b7b8ed1fd57449163bcb0b78d205e70d2314273263ab941c0c371ad56412
You specify the signal with the -s option:

#[user@host ~]$ podman kill -s SIGKILL my-httpd-container
77d4b7b8ed1fd57449163bcb0b78d205e70d2314273263ab941c0c371ad56412




-------------------------------------------Running Commands in a Container-------------------------

'The podman exec command starts an additional process inside an already running container:
'
#[user@host ~]$ podman exec 7ed6e671a600 cat /etc/redhat-release
Red Hat Enterprise Linux release 8.2 (Ootpa)
[user@host ~]$ 
The previous example uses the container ID to execute the command. It is often easier to use the container name instead. If you want to attach an interactive shell, then you must specify the -i and -t options to open an interactive session and allocate a pseudo-terminal for the shell.

#[user@host ~]$ podman exec -it my_webserver /bin/bash
bash-4.4$ hostname
7ed6e671a600
bash-4.4$ exit
[user@host ~]$ 
Podman remembers the last container used in any command. You can use the -l option to replace the former container ID or name in the latest Podman command.

#[user@host ~]$ podman exec -l cat /etc/redhat-release
Red Hat Enterprise Linux release 8.2 (Ootpa)
[user@host ~]$ 







------------------------------------------------------- E - X - E - R - C - I - S - E ---------------------------------------------------

'Create a detached container named mydb that uses the container image registry.lab.example.com/rhel8/mariadb-103:1-102. Your command must publish port 3306 in the container to the same port number on the host. 
You must also declare the following variable values to configure the container with the database user user1 (password redhat), set the root password to redhat, and create the database items.'

Variable	          Value
MYSQL_USER	        user1
MYSQL_PASSWORD	    redhat
MYSQL_DATABASE	    items
MYSQL_ROOT_PASSWORD	redhat

'The following podman run 'command' is very long and should be entered as a single line.'

[student@servera ~]$ podman run -d --name mydb -e MYSQL_USER=user1 -e MYSQL_PASSWORD=redhat -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=redhat -p 3306:3306 registry.lab.example.com/rhel8/mariadb-103:1-102

#######################################################################################################################################################

'Confirm that the container is running and publishing the correct ports using the podman ps command.'

[student@servera ~]$ podman ps

CONTAINER ID                IMAGE                                               COMMAND
abcb42ef2ff1  registry.lab.example.com/rhel8/mariadb-103:1-102                 run-mysqld
CREATED            STATUS                 PORTS                                NAMES
bout a minute ago  Up About a minute ago  0.0.0.0:3306->3306/tcp               mydb

#######################################################################################################################################################



'Connect to MariaDB as user1 with redhat as the password. Specify port 3306 and the IP address of localhost, which is your container host (127.0.0.1).
'
[student@servera ~]$ mysql -u user1 -p --port=3306 --host=127.0.0.1
Enter password: redhat


'Confirm the items database exist, and then exit from MariaDB.
'
MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| items              |
| test               |
+--------------------+
3 rows in set (0.001 sec)

MariaDB [(none)]> exit
Bye
[student@servera ~]$

'Stop the mydb container. Your container ID will be different from the following:
'
[student@servera ~]$ podman stop mydb
abcb42ef2ff1b85a50e3cd9bc15877ef823979c8166d0076ce5ebc5ea19c0815


#######################################################################################################################################################

'Create a container running an Apache HTTP Server that also starts an interactive Bash shell in the container. 
'
[student@servera ~]$ podman run --name myweb -it registry.lab.example.com/rhel8/httpd-24:1-105 /bin/bash



#######################################################################################################################################################



'Create a detached container named mysecondweb. Your output will vary from the the example in this exercise.
'
[student@servera ~]$ podman run --name mysecondweb -d registry.lab.example.com/rhel8/httpd-24:1-105
9e8f14e74fd4d82d95a765b8aaaeb1e93b9fe63c54c2cc805509017315460028



'Connect to the mysecondweb container to display the Linux name and kernel release using the podman exec command.
'
[student@servera ~]$ podman exec mysecondweb uname -sr
Linux 4.18.0-193.el8.x86_64



'Run the podman exec command again, this time using the (-l) option to use the container ID from the previous command to display the system load average.'

[student@servera ~]$ podman exec -l uptime
 00:14:53 up  2:15,  0 users,  load average: 0.08, 0.02, 0.01

#######################################################################################################################################################

'Create a container named myquickweb that lists the contents of the /etc/redhat-release file, and then automatically exits and deletes the container. Confirm that the container is deleted.
'

[student@servera ~]$ podman run --name myquickweb --rm registry.lab.example.com/rhel8/httpd-24:1-105 cat /etc/redhat-release

###############################################SOME PODMAN COMMANDS########################################################################################################

List all containers, running or stopped. Your output may vary.

[student@servera ~]$ podman ps -a
CONTAINER ID  IMAGE                                             COMMAND
9e8f14e74fd4  registry.lab.example.com/rhel8/httpd-24:1-105     /usr/bin/run-http
6d95bd8559de  registry.lab.example.com/rhel8/httpd-24:1-105     /bin/bash
abcb42ef2ff1  registry.lab.example.com/rhel8/mariadb-103:1-102  run-mysqld

CREATED        STATUS                     PORTS                  NAMES
5 minutes ago  Up 5 minutes ago                                  mysecondweb
18 minutes ago Exited (0) 17 minutes ago                         myweb
26 minutes ago Exited (0) 19 minutes ago  0.0.0.0:3306->3306/tcp mydb
Stop all containers.

[student@servera ~]$ podman stop -a
6d95bd8559de81486b0876663e72260a8108d83aef5c5d660cb8f133f439c025
abcb42ef2ff1b85a50e3cd9bc15877ef823979c8166d0076ce5ebc5ea19c0815
9e8f14e74fd4d82d95a765b8aaaeb1e93b9fe63c54c2cc805509017315460028
Remove all containers.

[student@servera ~]$ podman rm -a
6d95bd8559de81486b0876663e72260a8108d83aef5c5d660cb8f133f439c025
9e8f14e74fd4d82d95a765b8aaaeb1e93b9fe63c54c2cc805509017315460028
abcb42ef2ff1b85a50e3cd9bc15877ef823979c8166d0076ce5ebc5ea19c0815
Verify that all containers have been removed.

[student@servera ~]$ podman ps -a
CONTAINER ID  IMAGE  COMMAND  CREATED  STATUS  PORTS  NAMES
[student@servera ~]$