------------------------------'Managing Containers as Services'------------------------------------------------


------------------------------'Starting Containers Automatically with the Server'--------------------------------


When you deploy services such as databases or web servers as containers, you usually want those containers to start automatically with the server.

---------------------------'Running Systemd Services as a Regular User'------------------------------------------

'In addition to managing system services, systemd can also manage user services. With systemd user services, users can create unit files 
for their own services and manage those services with systemctl commands, without requiring root access.'

'
However, you can change this default behavior and force your enabled services to start with the server and stop during the shutdown by 
running the loginctl enable-linger command. To revert the operation, use 
the loginctl disable-linger command. To view the current status, use the loginctl show-user username command with your user name as parameter.'

[user@host ~]$ loginctl enable-linger
[user@host ~]$ loginctl show-user user
...output omitted...
Linger=yes
[user@host ~]$ loginctl disable-linger
[user@host ~]$ loginctl show-user user
...output omitted...
Linger=no


------------------------'Creating and Managing Systemd User Services'------------------------------------------

'To define systemd user services, create the '~/.config/systemd/user/' directory to store 
your unit files. The syntax of those files is the same as the system unit files. For more details, 
eview the systemd.unit(5) and systemd.service(5) man pages.'

'To control your new user services, use the systemctl command with the '--user' option. The following example lists the unit files in 
the '~/.config/systemd/user/' directory, forces systemd to reload its configuration, and then enables and starts the myapp user service.'

[user@host ~]$ ls ~/.config/systemd/user/
myapp.service
[user@host ~]$ systemctl --user daemon-reload
[user@host ~]$ systemctl --user enable myapp.service
[user@host ~]$ systemctl --user start myapp.service


Comparing System and User Services

Storing custom unit files	       System services	/etc/systemd/system/unit.service
                                   User services	~/.config/systemd/user/unit.service


Reloading unit files	           System services	 # systemctl daemon-reload
                                   User services	 $ systemctl --user daemon-reload


Starting and stopping a service	    System services	 # systemctl start UNIT
                                                     # systemctl stop UNIT
                                    User services	 $ systemctl --user start UNIT
                                                     $ systemctl --user stop UNIT


Starting a service when the machine starts	System services	  # systemctl enable UNIT
                                            User services	  $ loginctl enable-linger
                                                              $ systemctl --user enable UNIT
                                                
-------------------------------'Managing Containers Using Systemd Services'--------------------------------------

'If you have a single container host running a small number of containers, then you can set up user-based systemd unit files 
and configure them to start the containers automatically with the server. This is a simple approach, mainly useful for very 
basic and small deployments that do not need to scale. For more practical production installations, consider using Red Hat 
OpenShift Container Platform, which will be discussed briefly at the end of this section.'

-> 'Creating a Dedicated User Account to Run Containers'

To simplify the management of the rootless containers, you can create a dedicated user account that you use for all your containers. 
This way, you can manage them from a single user account.

--------------------'Creating the Systemd Unit File'

'From an existing container, the podman command can generate the systemd unit file for you. The following example uses the podman generate 
systemd command to create the unit file for the existing web container:'

[user@host ~]$ cd  ~/.config/systemd/user/
[user@host user]$ #podman generate systemd --name web --files --new
/home/user/.config/systemd/user/container-web.service

!!#The podman generate systemd command uses a container as a model to create the configuration file. After the file is created, you must 
#delete the container because systemd expects the container to be absent initially.


----------------------'The podman generate systemd command accepts the following options:
'
--name container_name

The --name option specifies the name of an existing container to use as a model to generate the unit file. Podman also uses that name to 
build the name of the unit file: container-container_name.service.

--files

The --files option instructs Podman to generates the unit file in the current directory. Without the option, Podman displays the file 
in its standard output.

--new

The --new option instructs Podman to configure the systemd service to create the container when the service starts and delete it when 
the service stops. In this mode, the container is ephemeral, and you usually need persistent storage to preserve the data. Without the 
--new option, Podman configures the service to start and stop the existing container without deleting it.


#[user@host ~]$ podman run -d --name web -v /home/user/www:/var/www:Z registry.redhat.io/rhel8/httpd-24:1-105
#[user@host ~]$ podman generate systemd --name web --new
...output omitted...

ExecStart=/usr/bin/podman run --conmon-pidfile %t/%n-pid --cidfile %t/%n-cid --cgroups=no-conmon -d --name web -v /home/user/webcontent:/var/www:Z registry.redhat.io/rhel8/httpd-24:1-105 1
ExecStop=/usr/bin/podman stop --ignore --cidfile %t/%n-cid -t 10 2
ExecStopPost=/usr/bin/podman rm --ignore -f --cidfile %t/%n-cid 3
...output omitted...



'In contrast, the following example shows the start and stop directives when you run the podman generate systemd command without the '--new' option:
'
#[user@host ~]$ podman run -d --name web -v /home/user/www:/var/www:Z registry.redhat.io/rhel8/httpd-24:1-105
#[user@host ~]$ podman generate systemd --name web

...output omitted...
ExecStart=/usr/bin/podman start web 1
ExecStop=/usr/bin/podman stop -t 10 web 2
...output omitted...

!!!#On stop, systemd executes the podman stop command to stop the container. Notice that systemd does not delete the container.


'Starting and Stopping Containers Using Systemd
'
'Use the systemctl command to control your containers.
'
'Starting the container:
'
#[user@host ~]$ systemctl --user start container-web
Stopping the container:

#[user@host ~]$ systemctl --user stop container-web
Getting the status of the container:

#[user@host ~]$ systemctl --user status container-web



-------------------------'Configuring Containers to Start When the Host Machine Starts'-----------------

'By default, enabled systemd user services start when a user opens the first session, and stop when the user closes the last session. 
For the user services to start automatically with the server, run the loginctl enable-linger command:'

#[user@host ~]$ loginctl enable-linger
To enable a container to start when the host machine starts, use the systemctl command:

#[user@host ~]$ systemctl --user enable container-web
To disable the start of a container when the host machine starts, use the systemctl command with the disable option:

#[user@host ~]$ systemctl --user disable container-web


-------------------------'Managing Containers Running as Root with Systemd'------------------------------

'You can also configure containers that you want to run as root to be managed with Systemd unit files. One advantage of this approach is that 
you can configure those unit files to work exactly like normal system unit files, rather than as a particular user.'



-'The procedure to set these up is similar to the one previously outlined for rootless containers, except:'

- -'You do not need to set up a dedicated user.'

- - -'When you create the unit file with podman generate systemd, do it in the /etc/systemd/system directory instead of in 
the ~/.config/systemd/user directory.'

- - - -'When configuring the containers service with systemctl, you will not use the --user option.'

- - - - -'You do not need to run loginctl enable-linger as root.'



----------------------------------------------- EXERCISE -------------------------------------------

1- 'Create a user account named contsvc using redhat as the password. Configure the account to access the container image registry 
at registry.lab.example.com. You will use this account to run containers as systemd services, instead of using your regular user account.'

[root@servera ~]# useradd contsvc
[root@servera ~]# passwd contsvc
Changing password for user contsvc.
New password: redhat
BAD PASSWORD: The password is shorter than 8 characters
Retype new password: redhat
passwd: all authentication tokens updated successfully.

##########################################################################################################

2- 'Log out of servera, and then use the ssh command to log in as the contsvc user. The systems are configured to use SSH keys for 
authentication, so a password is not required.
'
[root@servera ~]# exit
logout
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ ssh contsvc@servera
...output omitted...
[contsvc@servera ~]$ 

##########################################################################################################

3- 'Create the ~/.config/containers/ directory.'

[contsvc@servera ~]$ mkdir -p ~/.config/containers/
[contsvc@servera ~]$ 

'The lab script prepared the registries.conf file in the /tmp/containers-services/ directory. Copy that file to ~/.config/containers/. 
The following cp command is very long and should be entered as a single line.'

[contsvc@servera ~]$ cp /tmp/containers-services/registries.conf ~/.config/containers/

'To confirm that you can access the registry.lab.example.com registry, run the podman search ubi command as a test. If everything works 
as expected, then the command should list some images.'

[contsvc@servera ~]$ podman search ubi
INDEX         NAME                    DESCRIPTION   STARS   OFFICIAL   AUTOMATED
example.com   registry.lab.example.com/ubi8/ubi         0
example.com   registry.lab.example.com/ubi7/ubi         0

##########################################################################################################

4- 'Create the /home/contsvc/webcontent/html/ directory, and then create an index.html test page. You will use that directory as 
persistent storage when you deploy a web server container.'

[contsvc@servera ~]$ mkdir -p ~/webcontent/html/
[contsvc@servera ~]$ 

'Create the index.html file and add some content.
'
[contsvc@servera ~]$ echo "Hello World" > ~/webcontent/html/index.html
[contsvc@servera ~]$ 

'Confirm that everyone has access to the directory and the index.html file. The container uses an unprivileged user that must 
be able to read the index.html file.
'
[contsvc@servera ~]$ ls -ld webcontent/html/
drwxrwxr-x. 2 contsvc contsvc 24 Aug 28 04:56 webcontent/html/
[contsvc@servera ~]$ ls -l webcontent/html/index.html
-rw-rw-r--. 1 contsvc contsvc 12 Aug 28 04:56 webcontent/html/index.html

##########################################################################################################

5- 'Create a detached container named myweb. Redirect port '8080' on the local host to the container port '8080'. Mount the 
~/webcontent directory from the host to the '/var/www' directory in the container. Use the registry.lab.example.com/rhel8/httpd-24:1-105 
image.'

'Log in to the registry.lab.example.com registry as the admin user with redhat321 as the password.
'
[contsvc@servera ~]$ podman login registry.lab.example.com
Username: admin
Password: redhat321
Login Succeeded!

'
Create the container. You can copy and paste the following command from the /tmp/containers-services/start-container.txt file. 
The following podman run command is very long and should be entered as a single line.'

[contsvc@servera ~]$ podman run -d --name myweb -p 8080:8080 -v ~/webcontent:/var/www:Z registry.lab.example.com/rhel8/httpd-24:1-105

[contsvc@servera ~]$ curl http://localhost:8080/
Hello World

##########################################################################################################

6- 'Create the systemd unit file for managing the myweb container with systemctl commands. When finished, stop and then delete 
the myweb container. Systemd manages the container and does not expect the container to exist initially.'

'Create the ~/.config/systemd/user/ directory.
'
[contsvc@servera ~]$ mkdir -p ~/.config/systemd/user/
[contsvc@servera ~]$ 

'GO to directory and run command'
[contsvc@servera ~]$ cd ~/.config/systemd/user
[contsvc@servera user]$ # podman generate systemd --name myweb --files --new
/home/contsvc/.config/systemd/user/container-myweb.service

'Stop and then delete the myweb container.
'
[contsvc@servera user]$ #podman stop myweb
2f4844b376b78f8f7021fe3a4c077ae52fdc1caa6d877e84106ab783d78e1e1a
[contsvc@servera user]$ #podman rm myweb
2f4844b376b78f8f7021fe3a4c077ae52fdc1caa6d877e84106ab783d78e1e1a

##########################################################################################################

7- 'Force systemd to reload its configuration, and then enable and start your new container-myweb user service. To test your work, 
stop and then start the service and control the container status with the curl and podman ps commands.'

'Use the systemctl --user daemon-reload command for systemd to take the new unit file into account.
'
[contsvc@servera user]$ #systemctl --user daemon-reload
[contsvc@servera user]$ 

'Enable and start the container-myweb service.
'
[contsvc@servera user]$ systemctl --user enable --now container-myweb


'Stop the container-myweb service, and then confirm that the container does not exist anymore. When you stop the service, systemd stops and 
then deletes the container.'

[contsvc@servera user]$ systemctl --user stop container-myweb
[contsvc@servera user]$ podman ps --all
CONTAINER ID  IMAGE  COMMAND  CREATED  STATUS  PORTS  NAMES
Start the container-myweb service, and then confirm that the container is running.

[contsvc@servera user]$ systemctl --user start container-myweb
[contsvc@servera user]$ podman ps
CONTAINER ID  IMAGE                                          COMMAND               CREATED        STATUS            PORTS                   NAMES
6f5148b27726  registry.lab.example.com/rhel8/httpd-24:1-105  /usr/bin/run-http...  5 seconds ago  Up 4 seconds ago  0.0.0.0:8080->8080/tcp  myweb

##########################################################################################################

'Use command if you want to run service only when uesr logged in'

Run the loginctl enable-linger command.

[contsvc@servera user]$ loginctl enable-linger
[contsvc@servera user]$ 

##########################################################################################################
