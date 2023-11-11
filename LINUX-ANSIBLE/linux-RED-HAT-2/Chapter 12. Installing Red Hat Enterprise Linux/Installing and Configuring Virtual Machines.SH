'Introducing KVM Virtualization'

'Virtualization is a feature that allows a single physical machine to be divided into multiple virtual machines (VM), 
each of which can run an independent operating system.'

'In Red Hat Enterprise Linux, manage KVM with the 'virsh command' or with Cockpits Virtual Machines tool.
'


'Red Hat Virtualization (RHV) provides a centralized web interface that allows administrators to manage an entire virtual infrastructure. It includes advanced 
features such as KVM migration, redundancy, and high availability. '

'Red Hat supports virtual machines running these operating systems:
'
1- Red Hat Enterprise Linux 6 and later

2- Microsoft Windows 10 and later

3- Microsoft Windows Server 2016 and later



--------------------- Configuring a Red Hat Enterprise Linux Physical System as a Virtualization Host ------------------------------


#####Installing the Virtualization Tools

'Install the virt Yum module to prepare a system to become a virtualization host.
'
[root@host ~]# yum module list virt
Name           Stream             Profiles           Summary
virt           rhel [d][e]        common [d]         Virtualization module

Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
[root@host ~]# yum module install virt
...output omitted...


###### Verifying the System Requirements

'KVM requires either an Intel processor with the Intel VT-x and Intel 64 extensions for x86-based systems or an AMD processor with the AMD-V and the AMD64 extensions. To verify your 
hardware and check the system requirements, use the virt-host-validate command.'

[root@host ~]# virt-host-validate


Managing Virtual Machines with Cockpit
'The virt Yum module provides the virsh command to manage your virtual machines. The Cockpit tool provides a web 
console interface for KVM management and virtual machine creation.'


'Install the cockpit-machines package to add the Virtual Machines menu to Cockpit.
'
[root@host ~]# yum install cockpit-machines

'If Cockpit is not already running, start and enable it.'

[root@host ~]# systemctl enable --now cockpit.socket

'To create a new virtual machine with Cockpit, access the Virtual Machines menu in the Cockpit web interface. From there, click Create VM and enter 
the VM configuration in the Create New Virtual Machine window.'
