'Red Hat Enterprise Linux System Roles
'Beginning with Red Hat Enterprise Linux 7.4, a number of Ansible roles have been provided with the operating system as part of the rhel-system-roles package. In Red Hat Enterprise Linux 8 the package is available in the AppStream channel. A brief description of each role:

Table 7.2. RHEL System Roles

Name	State	Role Description
'rhel-system-roles.kdump'	Fully Supported	Configures the kdump crash recovery service.
'rhel-system-roles.network'	Fully Supported	Configures network interfaces.
'rhel-system-roles.selinux'	Fully Supported	Configures and manages SELinux customization, including SELinux mode, file and port contexts, Boolean settings, and SELinux users.
'rhel-system-roles.timesync'	Fully Supported	Configures time synchronization using Network Time Protocol or Precision Time Protocol.
'rhel-system-roles.postfix'	Technology Preview	Configures each host as a Mail Transfer Agent using the Postfix service.
'rhel-system-roles.firewall'	In Development	Configures a host's firewall.
rhel-system-roles.tuned	In Development	Configures the tuned service to tune system performance.

System roles aim to standardize the configuration of Red Hat Enterprise Linux subsystems across multiple versions. 
Use system roles to configure any Red Hat Enterprise Linux, version 6.10 and onward.'




'Simplified Configuration Management'

As an example, the recommended time synchronization service for Red Hat Enterprise Linux 7 is the chronyd service. In Red Hat Enterprise 
Linux 6 however, the recommended service is the ntpd service. In an environment with a mixture of Red Hat Enterprise Linux 6 and 7 hosts, 
an administrator must manage the configuration files for both services.

With RHEL System Roles, administrators no longer need to maintain configuration files for both services. Administrators can use 
rhel-system-roles.timesync role to configure time synchronization for both Red Hat Enterprise Linux 6 and 7 hosts. A simplified YAML 
file containing role variables defines the configuration of time synchronization for both types of hosts.





                        'Installing RHEL System Roles'

'                        Install RHEL System Roles.
'
[root@host ~]# yum install rhel-system-roles
After installation, the RHEL System roles are located in the /usr/share/ansible/roles directory:

[root@host ~]# ls -l /usr/share/ansible/roles/
total 20
...output omitted... linux-system-roles.kdump -> rhel-system-roles.kdump
...output omitted... linux-system-roles.network -> rhel-system-roles.network
...output omitted... linux-system-roles.postfix -> rhel-system-roles.postfix



!!!! Ansible might not find the system roles if roles_path has been overridden in the current Ansible configuration file, if the environment variable ANSIBLE_ROLES_PATH is set, or if there is another role of the same name in a directory listed earlier in roles_path.


'Accessing Documentation for RHEL System Roles'

Each roles documentation directory contains a README.md file. The README.md file contains a description of the role, along with role usage information.

#[root@host ~]# ls -l /usr/share/doc/rhel-system-roles/
total 4



                            'Time Synchronization Role Example'

Suppose you need to configure NTP time synchronization on your servers. You could write automation yourself to perform each of the 
necessary tasks. But RHEL System Roles includes a role that can do this,' rhel-system-roles.timesync'.


The role is documented in its README.md in the /usr/share/doc/rhel-system-roles/timesync directory. 

'To manually configure NTP servers, the role has a variable named timesync_ntp_servers. It takes a list of NTP servers to use. Each item in the list is made up of one or more attributes. The two key attributes are:
'
Table 7.3. timesync_ntp_servers attributes

Attribute	                Purpose
hostname	                The hostname of an NTP server with which to synchronize.
iburst	                    A Boolean that enables or disables fast initial synchronization. Defaults to no in the role, you should normally set this to yes.







Given this information, the following example is a play that uses the rhel-system-roles.timesync role to configure 
managed hosts to get time from three NTP servers using fast initial synchronization. In addition, a task has been 
added that uses the timezone module to set the hosts time zone to UTC.

'- name: Time Synchronization Play
  hosts: servers
  vars:
    timesync_ntp_servers:
      - hostname: 0.rhel.pool.ntp.org
        iburst: yes
      - hostname: 1.rhel.pool.ntp.org
        iburst: yes
      - hostname: 2.rhel.pool.ntp.org
        iburst: yes
    timezone: UTC

  roles:
    - rhel-system-roles.timesync

  tasks:
    - name: Set timezone
      timezone:
        name: "{{ timezone }}"'




This 'example' sets the role variables in a vars section of the play, but a better practice might be to configure them as inventory 
variables for hosts or host groups.


Consider a playbook project with the following structure:

[root@host playbook-project]# tree
'.
├── ansible.cfg
├── group_vars
│   └── servers
│       └── timesync.yml1
├── inventory
└── timesync_playbook.yml2
1
'
Defines the time synchronization variables overriding the role defaults for hosts in group servers in the inventory. 
This file would look something like:

'timesync_ntp_servers:
  - hostname: 0.rhel.pool.ntp.org
    iburst: yes
  - hostname: 1.rhel.pool.ntp.org
    iburst: yes
  - hostname: 2.rhel.pool.ntp.org
    iburst: yes
timezone: UTC
2'

The content of the playbook simplifies to:

'- name: Time Synchronization Play
  hosts: servers
  roles:
    - rhel-system-roles.timesync
  tasks:
    - name: Set timezone
      timezone:
        name: "{{ timezone }}"
'

This structure cleanly separates the role, the playbook code, and configuration settings. The playbook code is simple, easy to read, and should not require complex refactoring. The role content is maintained and supported by Red Hat. All the settings are handled as inventory variables.









                            [[[[[[[[[[[[[[[[[[[[[    'EXAMPLE'   ]]]]]]]]]]]]]]]]]]]]]

1 -- 
Use the ansible-galaxy command to verify that no roles are initially available for use in the playbook project.

[student@workstation role-system]$ ansible-galaxy list
# /home/student/role-system/roles
# /usr/share/ansible/roles
# /etc/ansible/roles



1.1 --- 
Install the rhel-system-roles package.


[student@workstation role-system]$ sudo yum install rhel-system-roles
Enter y when prompted to install the package.

Use the ansible-galaxy command to verify that the system roles are now available.



[student@workstation role-system]$ ansible-galaxy list
# /home/student/role-system/roles
# /usr/share/ansible/roles
...output omitted...
- rhel-system-roles.timesync, (unknown version)
- rhel-system-roles.tlog, (unknown version)
# /etc/ansible/roles



2 -- 

Create a playbook, configure_time.yml, with one play that targets the database_servers host group. 
Include the rhel-system-roles.timesync role in the roles section of the play.

'---
- name: Time Synchronization
  hosts: database_servers

  roles:
    - rhel-system-roles.timesync'



2.1 CHECK THE RESPECTIVE 

'Role Variables section of the README.md file for the rhel-system-roles.timesync role.'

[student@workstation role-system]$ cat \
> /usr/share/doc/rhel-system-roles/timesync/README.md
...output omitted...



3 -- 

Create the group_vars/all subdirectory.

#[student@workstation role-system]$ mkdir -pv group_vars/all

mkdir: created directory 'group_vars'
mkdir: created directory 'group_vars/all'


Create a new file group_vars/all/timesync.yml using a text editor. Add variable definitions to satisfy the time synchronization 
requirements. The file now contains:

'---
#rhel-system-roles.timesync variables for all hosts

timesync_ntp_provider: chrony

timesync_ntp_servers:
  - hostname: classroom.example.com
    iburst: yes'



4 -- 

Add a task to 'configure_time.yml', to set the time zone for each host. Ensure the task uses the timezone module and executes 
after the rhel-system-roles.timesync role.

'---
- name: Time Synchronization
  hosts: database_servers

  roles:
    - rhel-system-roles.timesync

  post_tasks:
    - name: Set timezone
      timezone:
        name: "{{ host_timezone }}"
      notify: reboot host

  handlers:
    - name: reboot host
      reboot:'




5 --

For each data center, create a file named timezone.yml that contains an appropriate value for the host_timezone variable.

'Create the group_vars subdirectories for the na_datacenter and europe_datacenter host groups.'

#[student@workstation role-system]$ mkdir -pv  group_vars/{na_datacenter,europe_datacenter}

mkdir: created directory 'group_vars/na_datacenter'
mkdir: created directory 'group_vars/europe_datacenter'


Create the timezone.yml for both data centers:

#[student@workstation role-system]$ echo "host_timezone: America/Chicago"  group_vars/na_datacenter/timezone.yml
#[student@workstation role-system]$ echo "host_timezone: Europe/Helsinki"  group_vars/europe_datacenter/timezone.yml



6--

Run the playbook.

#[student@workstation role-system]$ ansible-playbook configure_time.yml

