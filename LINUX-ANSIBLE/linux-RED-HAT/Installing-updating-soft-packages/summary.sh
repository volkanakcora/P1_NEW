'Registration from the Command Line
'
'Use the subscription-manager(8) command to register a system without using a graphical environment. The subscription-manager command can automatically attach a system to the best-matched compatible subscriptions for the system.
'
'Register a system to a Red Hat account:
'
[user@host ~]# subscription-manager register --username=yourusername \
# --password=yourpassword

'View available subscriptions:
'
[user@host ~]# subscription-manager list --available | less

'Auto-attach a subscription:
'
[user@host ~]# subscription-manager attach --auto

'Alternatively, attach a subscription from a specific pool from the list of available subscriptions:
'
[user@host ~]# subscription-manager attach --pool=poolID

'View consumed subscriptions:
'
[user@host ~]# subscription-manager list --consumed

'Unregister a system:
'
[user@host ~]# subscription-manager unregister



/etc/pki/product 'contains certificates indicating which Red Hat products are installed on the system.'

/etc/pki/consumer 'contains certificates identifying the Red Hat account to which the system is registered.'

/etc/pki/entitlement 'contains certificates indicating which subscriptions are attached to the system.'



#### Updating Software with RPM Packages

'Examining RPM Packages
'
rpm -qa	'List all RPM packages currently installed'
rpm -q 'NAME	Display the version of NAME installed on the system'
rpm -qi NAME	'Display detailed information about a package'
rpm -ql NAME	'List all files included in a package'
rpm -qc NAME	'List configuration files included in a package'
rpm -qd NAME	'List documentation files included in a package'
rpm -q --changelog 'NAME	Show a short summary of the reason for a new package release'
rpm -q --scripts 'NAME	Display the shell scripts run on package installation, upgrade, or removal'


rpm -q [select-options] [query-options]

#rpm -q yum
yum-4.0.9.2-4.el8.noarch

RPM queries: General information about installed packages

rpm -qa: 'List all installed packages'

rpm -qf FILENAME: 'Find out what package provides FILENAME'

rpm -qf /etc/redhat-release 

rpm -qf /etc/yum.repos.d

rpm -qi: 'Get detailed information about the package
'
rpm -ql: 'List the files installed by the package'

#rpm -ql yum

rpm -qc: List just the configuration files installed by the package

#rpm -qc openssh-clients

/etc/ssh/ssh_config
/etc/ssh/ssh_config.d/05-redhat.conf

rpm -q --scripts: List shell scripts that run before or after the package is installed or removed

[user@host ~]# rpm -q --scripts openssh-server


rpm -q --changelog: list change information for the package

[user@host ~]# rpm -q --changelog audit


### EXTRACT THE CONTENT OF PACKAGES 

'Use the rpm2cpio and cpio -tv commands to list the files in the rhcsa-script-1.0.0-1.noarch.rpm package.
'
[student@servera ~]# rpm2cpio rhcsa-script-1.0.0-1.noarch.rpm | cpio -tv



## Managing Software Packages with Yum

#yum list 'http*'

#yum search all 'web server'

#yum info httpd

#yum install httpd 

#sudo yum update 

#sudo yum remove 

# yum group install

# yum group info

# yum module info 

# yum module list 

# yum group list 

# yum module remove 

# yum module list postgres 

# yum list --installed 


## HOW TO REMOVE OLD MODULE AND INSTALL NEW ONE 

[root@servera ~]# yum module list postgresql

[root@servera ~]# yum module remove postgresql

[root@servera ~]# yum module reset postgresql

[root@servera ~]# yum module install postgresql:10

## how to disable it

yum module disable postgresql 





'Enabling Red Hat software repositories
'

[user@host ~]$ yum repolist all


[user@host ~]$ yum config-manager --enable rhel-8-server-debug-rpms

'HOW TO CREATE'

yum config-manager --add-repo="https://dl.fedoraproject.org/pub/epel/8/Everything/x86_64/"

'HOW TO CONFIGURE AND IMPORT CONF'

#rpm --import \
#http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-8

[user@host ~]# yum install \
#https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm



'MODULE MAN.
'
#yum module

#yum module list 

#yum module install 

#yum module remove perl

#yum module disable perl 


## How to Create the /etc/yum.repos.d/errata.repo file to enable the updates repository with the following content:

[rht-updates]
name=rht updates
baseurl=http://content.example.com/rhel8.2/x86_64/rhcsa-practice/errata
enabled=1
gpgcheck=0

