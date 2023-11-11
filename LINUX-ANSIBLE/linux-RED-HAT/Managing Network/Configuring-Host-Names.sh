Changing the system host name
The hostname command displays or temporarily modifies the system's fully qualified host name.

[root@host ~]# hostname
host.example.com
A static host name may be specified in the /etc/hostname file. The hostnamectl command is used to modify this file and may be used to view the status of the system's fully qualified host name. If this file does not exist, the host name is set by a reverse DNS query once the interface has an IP address assigned.

[root@host ~]# hostnamectl set-hostname host.example.com
[root@host ~]# hostnamectl status
   Static hostname: host.example.com
         Icon name: computer-vm
           Chassis: vm
        Machine ID: f874df04639f474cb0a9881041f4f7d4
           Boot ID: 6a0abe03ef0b4a97bcb8afb7b281e4d3
    Virtualization: kvm
  Operating System: Red Hat Enterprise Linux 8.2 (Ootpa)
       CPE OS Name: cpe:/o:redhat:enterprise_linux:8.2:GA
            Kernel: Linux 4.18.0-193.el8.x86_64
      Architecture: x86-64
[root@host ~]# cat /etc/hostname
host.example.com


