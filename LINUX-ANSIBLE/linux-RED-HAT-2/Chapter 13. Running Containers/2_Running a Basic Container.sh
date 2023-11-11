------------------------'Running a Basic Container'---------------------


#Installing Container Management Tools

To get started with running and managing containers on your system, you must install the necessary command-line tools. 
Install the container-tools module with the yum command.

[root@host ~]# yum module install container-tools



#Selecting Container Images and Registries

'Red Hat distributes certified container images through two main container registries that you can access with your Red Hat log in credentials.
'
1- registry.redhat.io for containers based on official Red Hat products.

2- registry.connect.redhat.com for containers based on third-party products.

Red Hat is gradually phasing out an older registry, 'registry.access.redhat.com'.


------> Container Naming Conventions


'Container images are named based on the following fully qualified image name syntax:
'
#registry_name/user_name/image_name:tag

''The 'registry_name' is the name of the registry storing the image. It is usually the fully qualified domain name of the registry.
''
The 'user_name' represents the user or organization to which the image belongs.

The 'image_name' must be unique in the user namespace.

The 'tag' identifies the image version. If the image name includes no image tag, then latest is assumed.




-----------------------------------------------Running Containers--------------------------------------

'To run a container on your local system, you must first pull a container image. Use Podman to pull an image from a registry. 
You should always use the fully qualified image name when pulling images. The podman pull command pulls the image you specify 
from the registry and saves it locally:'


#[user@host ~]$ podman pull registry.access.redhat.com/ubi8/ubi:latest
Trying to pull registry.access.redhat.com/ubi8/ubi:latest...Getting image source signatures
Copying blob 77c58f19bd6e: 70.54 MiB / 70.54 MiB [=========================] 10s
Copying blob 47db82df7f3f: 1.68 KiB / 1.68 KiB [===========================] 10s
Copying config a1f8c9699786: 4.26 KiB / 4.26 KiB [==========================] 0s
Writing manifest to image destination
Storing signatures
a1f8c969978652a6d1b2dfb265ae0c6c346da69000160cd3ecd5f619e26fa9f3


'After retrieval, Podman stores images locally and you can list them using the podman images command:
'
#[user@host ~]$ podman images
REPOSITORY                            TAG      IMAGE ID       CREATED      SIZE
registry.access.redhat.com/ubi8/ubi   latest   a1f8c9699786   5 weeks ago  211 MB


-> 'The preceding output shows that the image tag is latest and that the 'image ID' is 'a1f8c96699786'.'

To run a container from this image, use the podman run command. When you execute a podman run command, 
you create and start a new container from a container image. Use the -it options to interact with the container, if required. 

#[user@host ~]$ podman run -it registry.access.redhat.com/ubi8/ubi:latest
[root@8b032455db1a /]# 




!!!!'When referencing a container, Podman recognizes either the container name or the generated container ID. 
Use the '--name' option to set the container name when running the container with Podman. Container names must be unique. 
If the podman run command includes no container name, Podman generates a unique random name.'!!!!



--> The following example assigns the container a name:

#[user@host ~]$ podman run -it --name=rhel8 registry.access.redhat.com/ubi8/ubi /⁠bin/bash
[root@c20631116955 /]# cat /etc/os-release
NAME="Red Hat Enterprise Linux"
VERSION="8.2 (Ootpa)"
ID="rhel"
ID_LIKE="fedora"
VERSION_ID="8.2"
PLATFORM_ID="platform:el8"
PRETTY_NAME="Red Hat Enterprise Linux 8.2 (Ootpa)"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:redhat:enterprise_linux:8.2:GA"
HOME_URL="https://www.redhat.com/"
BUG_REPORT_URL="https://bugzilla.redhat.com/"


--> 'You can also run a quick command in a container without interacting with it, and then remove the container once the command is completed. 
To do this, use podman run --rm followed by the container image and a command.'

#[user@host ~]$ podman run --rm registry.access.redhat.com/ubi8/ubi cat /etc/os-release




-------------------Analyzing Container Isolation--------------------

'Analyzing Container Isolation
'
'Containers provide run time isolation of resources. Containers utilize Linux namespaces to provide separate, isolated environments for resources, such as processes, network communications, and volumes. 
Processes running within a container are isolated from all other processes on the host machine.'

View the processes running inside the container:

#[user@host ~]$ podman run -it registry.access.redhat.com/ubi7/ubi /bin/bash
[root@ef2550ed815d /]# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  4.5  0.1  11840  2904 pts/0    Ss   22:10   0:00 /bin/bash
root          15  0.0  0.1  51768  3388 pts/0    R+   22:10   0:00 ps aux

'Note that the user name and ID inside the container is different from the user name and ID on the host machine:
'
[root@ef2550ed815d /]# id
uid=0(root) gid=0(root) groups=0(root)
[root@ef2550ed815d /]# exit
exit
[user@host ~]$ id
uid=1000(user) gid=1000(user) groups=1000(user),10(wheel)