'Configuring Container Registries'

'Podman uses a registries.conf file on your host system to get information about the container registries it can use.'

#[user@host ~]$ cat /etc/containers/registries.conf



!!'this file is stored in the $HOME/.config/containers directory. Configuration settings in this file override the system-wide settings in the 
/etc/containers/registries.conf file.'!!



The list of registries that Podman can search are configured in the [registries.search] section of this file.

'The podman info command displays configuration information for Podman, including its configured registries.
'
#[user@host ~]$ podman info
...output omitted...
insecure registries:
  registries: []
registries:
  registries:
  - registry.redhat.io
  - quay.io
  - docker.io
...output omitted...


''''''''''''''''''''''''''''''''''''''''Registry Security
''''''''''''''''''''''''''''''''''''''''

'Insecure registries are listed in the [registries.insecure] section of the registries.conf file. If a registry is listed as insecure, 
then connections to that registry are not protected with TLS encryption. If a registry is both searchable and insecure, then it can be 
listed in both [registries.search] and [registries.insecure]'


-------------------------------------------Finding Container Images------------------------------------


'Use the podman search command to search container registries for a specific container image. The following example shows how to search the 
container registry registry.redhat.io for all images that include the name rhel8:'


#user@host ~]$ podman search registry.redhat.io/rhel8
INDEX       NAME          DESCRIPTION                STARS   OFFICIAL   AUTOMATED
redhat.io   registry.redhat.io/openj9/openj9-8-rhel8      OpenJ9 1.8 OpenShift S2I image for Java Appl...   0
redhat.io   registry.redhat.io/openjdk/openjdk-8-rhel8    OpenJDK 1.8 Image for Java Applications base...   0
redhat.io   registry.redhat.io/openj9/openj9-11-rhel8     OpenJ9 11 OpenShift S2I image for Java Appli...   0
redhat.io   registry.redhat.io/openjdk/openjdk-11-rhel8   OpenJDK S2I image for Java Applications on U...   0
redhat.io   registry.redhat.io/rhel8/memcached            Free and open source, high-performance, dist...   0
redhat.io   registry.redhat.io/rhel8/llvm-toolset         The LLVM back-end compiler and core librarie...   0
redhat.io   registry.redhat.io/rhel8/rust-toolset         Rust and Cargo, which is a build system and ...   0
redhat.io   registry.redhat.io/rhel8/go-toolset           Golang compiler which will replace the curre...   0
...output omitted...


'Run the same command with the --no-trunc option to see longer image descriptions:
'
#[user@host ~]$ podman search --no-trunc registry.access.redhat.com/rhel8
INDEX       NAME          DESCRIPTION                STARS   OFFICIAL   AUTOMATED
...output omitted...
redhat.io   registry.redhat.io/rhel8/nodejs-10            Node.js 10 available as container is a base platform.................


'Table 13.1. Useful Podman Search Options
'
Option	                                 Description
--limit <number>	            Limits the number of listed images per registry.

--filter <filter=value>	        'Filters output based on conditions provided. Supported filters include:'
                                #stars=<number>:                 Show only images with at least this number of stars.

                                #is-automated=<true|false>: Show only images automatically built.

                                #is-official=<true|false>: Show only images flagged as official.

--tls-verify <true|false>	    'Enables or disables HTTPS certificate validation for all used registries. Default=true
'




---------------------------------------------------Inspecting Container Images----------------------------------------------------

'You can view information about an image before downloading it to your system. The skopeo inspect command can inspect a remote container image in a registry 
and display information about it.'


#[user@host ~]$ skopeo inspect docker://registry.redhat.io/rhel8/python-36
...output omitted...
                "name": "ubi8/python-36",
                "release": "107",
                "summary": "Platform for building and running Python 3.6 applications",
...output omitted...


'
You can also inspect locally stored image information using the podman inspect command. This command might provide more information than 
the skopeo inspect command.'

'List locally stored images:
'
#[user@host ~]$ podman images
REPOSITORY                            TAG      IMAGE ID       CREATED       SIZE
quay.io/generic/rhel7                 latest   1d3b6b7d01e4   3 weeks ago   688 MB
registry.redhat.io/rhel8/python-36    latest   e55cd9a2e0ca   6 weeks ago   811 MB
registry.redhat.io/ubi8/ubi           latest   a1f8c9699786   6 weeks ago   211 MB

'Inspect a locally stored image and return information:
'

#[user@host ~]$ podman inspect registry.redhat.io/rhel8/python-36
...output omitted...
        "Config": {
            "User": "1001",
            "ExposedPorts": {
                "8080/tcp": {}
...output omitted...
                "name": "ubi8/python-36",
                "release": "107",
                "summary": "Platform for building and running Python 3.6 applications",
...output omitted...


---------------------------------------------Removing Local Container Images------------------------------

'Remove the registry.redhat.io/rhel8/python-36:latest image.
'
[user@host ~]$ podman rmi registry.redhat.io/rhel8/python-36:latest
e55cd9a2e0ca5f0f4e0249404d1abe3a69d4c6ffa5103d0512dd4263374063ad
[user@host ~]$




----------------------------------------EXERCISE-----------------------------------------------------


'Display the container registry configuration file and view configured registries.

'[student@servera ~]$ cat /home/student/.config/containers/registries.conf
'unqualified-search-registries = ['registry.lab.example.com']

[[registry]]
location = "registry.lab.example.com"
insecure = true
blocked = false'







'Search the registry for images with a name that starts with "ubi" using the podman search command.

'[student@servera ~]$ podman search registry.lab.example.com/ubi
'INDEX         NAME                            DESCRIPTION   STARS   OFFICIAL
example.com   registry.lab.example.com/ubi7/ubi           0
example.com   registry.lab.example.com/ubi8/ubi           0                  '
















'Log in to the container registry using the podman login command.

'[student@servera ~]$ podman login registry.lab.example.com
'Username: admin
Password: redhat321
Login Succeeded!'










'The following skopeo inspect command is very long and should be entered as a single line.

'[student@servera ~]$ skopeo inspect docker://registry.lab.example.com/rhel8/httpd-24'
'









'Pull a container image from the registry using the podman pull command.

'[student@servera ~]$ podman pull registry.lab.example.com/rhel8/httpd-24
'Trying to pull registry.lab.example.com/rhel8/httpd-24...
Getting image source signatures
Copying blob 77c58f19bd6e done
Copying blob 47db82df7f3f done
Copying blob 9d20433efa0c done
Copying blob 71391dc11a78 done
Copying config 7e93f25a94 done
Writing manifest to image destination
Storing signatures
7e93f25a946892c9c175b74a0915c96469e3b4845a6da9f214fd3ec19c3d7070
Use the podman images command to view locally stored images.

'[student@servera ~]$ podman images
'REPOSITORY                              TAG     IMAGE ID      CREATED      SIZE
registry.lab.example.com/rhel8/httpd-24 latest  7e93f25a9468  4 weeks ago  430 MB'





'Remove a locally stored image using the podman rmi command.

[student@servera ~]$ podman rmi registry.lab.example.com/rhel8/httpd-24
Untagged: registry.lab.example.com/rhel8/httpd-24:latest
Deleted: 7e93...7070'