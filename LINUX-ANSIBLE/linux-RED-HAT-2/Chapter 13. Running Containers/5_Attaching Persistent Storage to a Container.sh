-------------------'Attaching Persistent Storage to a Container
'

------------------'Preparing Permanent Storage Locations
'

'If data used by your container must be preserved when the container is restarted, then ephemeral storage is not sufficient. 
For example, your container might be a database server and you must preserve the database itself when the container 
restarts. To support containerized applications with this requirement, you must provide the container with persistent storage.'

--------------------'Preparing the Host Directory'


'Directory configuration involves:
'
-- Configuring the ownership and permissions of the directory.

-- Setting the appropriate SELinux context.

'Mounting a Volume
''After creating and configuring the host directory, the next step is to mount this directory to a container. To mount a host directory to
 a container, add the --volume (or -v) option to the podman run command, specifying the host directory path and the container storage path, 
 separated by a colon:
'
--volume host_dir:container_dir:Z

#With the Z option, Podman automatically applies the SELinux container_file_t context type to the host directory.



'For example, to use the /home/user/dbfiles host directory for MariaDB database files as /var/lib/mysql inside the container, use the following 
command. The following podman run command is very long and should be entered as a single line.'

[user@host ~]$ podman run -d --name mydb -v /home/user/dbfiles:/var/lib/mysql:Z -e MYSQL_USER=user 
-e MYSQL_PASSWORD=redhat -e MYSQL_DATABASE=inventory registry.redhat.io/rhel8/mariadb-103:1-102



------------------------------------------ EXERCISE --------------------------------

'Create the ~/webcontent/html/ directory.
'
[student@servera ~]$ mkdir -p ~/webcontent/html/
[student@servera ~]$ 



#################################################################################################################3
'Create the index.html file and add some content.
'
[student@servera ~]$ echo "Hello World" > ~/webcontent/html/index.html
[student@servera ~]$ 

#################################################################################################################3


'Confirm that everyone has access to the directory and the index.html file. The container uses an unprivileged user that must be able to 
read the index.html file.'

[student@servera ~]$ ls -ld webcontent/html/
drwxrwxr-x. 2 student student 24 Aug 28 04:56 webcontent/html/
[student@servera ~]$ ls -l webcontent/html/index.html
-rw-rw-r--. 1 student student 12 Aug 28 04:56 webcontent/html/index.html

#################################################################################################################3


'Create an Apache HTTP Server container instance with persistent storage.
'
[student@servera ~]$ podman login registry.lab.example.com




#################################################################################################################3



'Create a detached container instance named myweb. Redirect port 8080 on the local host to the container port 8080. Mount the ~/webcontent 
directory from the host to the /var/www directory in the container. Add the :Z suffix to the volume mount option to instruct the podman 
command to relabel the directory and its content. Use the registry.lab.example.com/rhel8/httpd-24:1-98 image. The following podman run 
command is very long and should be entered as a single line.'

[student@servera ~]$ podman run -d --name myweb -p 8080:8080 -v ~/webcontent:/var/www:Z registry.lab.example.com/rhel8/httpd-24:1-98
...output omitted...





#################################################################################################################3



'Run the podman ps command to confirm that the container is running, and then use the curl command to access the web content on port 8080.
'
[student@servera ~]$ podman ps
CONTAINER ID  IMAGE                                          COMMAND               CREATED             STATUS                 PORTS                   NAMES
2f4844b376b7  registry.lab.example.com/rhel8/httpd-24:1-98   /usr/bin/run-http...  About a minute ago  Up About a minute ago  0.0.0.0:8080->8080/tcp  myweb
[student@servera ~]$ curl http://localhost:8080/
Hello World



#################################################################################################################3


 

'In the preceding step, you used the 1-98 tag to select a particular version of the httpd-24 image. There is a more recent version of that 
image in the classroom registry. Use the skopeo inspect command to get the registry.lab.example.com/rhel8/httpd-24 image details and retrieve 
the tag for that version. The following skopeo inspect command is very long and should be entered as a single line.'

[student@servera ~]$ skopeo inspect docker://registry.lab.example.com/rhel8/httpd-24
{
    "Name": "registry.lab.example.com/rhel8/httpd-24",
    "Digest": "sha256:bafa...a12a",
    "RepoTags": [
        "1-98",
        "1-104",
        "1-105",
        "latest"
    ],
...output omitted...