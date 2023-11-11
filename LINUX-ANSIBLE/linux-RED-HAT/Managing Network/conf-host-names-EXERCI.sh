Display the current host name.

[student@servera ~]$ hostname
servera.lab.example.com


###############################

Display the host name status.

[student@servera ~]$ hostnamectl status
   Static hostname: n/a
Transient hostname: servera.lab.example.com
         Icon name: computer-vm
           Chassis: vm
        Machine ID: f874df04639f474cb0a9881041f4f7d4
           Boot ID: 22ae5279f57049678eda547bdb39a19d
    Virtualization: kvm
  Operating System: Red Hat Enterprise Linux 8.2 (Ootpa)
       CPE OS Name: cpe:/o:redhat:enterprise_linux:8.2:GA
            Kernel: Linux 4.18.0-193.el8.x86_64
      Architecture: x86-64



###################################

Change the host name and host name configuration file.

[student@servera ~]$ sudo hostnamectl set-hostname \
servera.lab.example.com
[sudo] password for student: student
[student@servera ~]$ 


###################################

Display the host name status.

[student@servera ~]$ hostnamectl status
   Static hostname: servera.lab.example.com
         Icon name: computer-vm
           Chassis: vm
        Machine ID: f874df04639f474cb0a9881041f4f7d4
           Boot ID: 22ae5279f57049678eda547bdb39a19d
    Virtualization: kvm
  Operating System: Red Hat Enterprise Linux 8.2 (Ootpa)
       CPE OS Name: cpe:/o:redhat:enterprise_linux:8.2:GA
            Kernel: Linux 4.18.0-193.el8.x86_64
      Architecture: x86-64



#######################################

hange the host name.

[student@servera ~]$ sudo hostname testname
Display the current host name.

[student@servera ~]$ hostname
testname
View the content of the /etc/hostname file which provides the host name at network start.

servera.lab.example.com
Reboot the system.

[student@servera ~]$ sudo systemctl reboot
Connection to servera closed by remote host.
Connection to servera closed.
[student@workstation ~]$ 
From workstation log in to servera as student user.

[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
Display the current host name.

[student@servera ~]$ hostname
servera.lab.example.com
Add a local nickname for the classroom server.

Look up the IP address of the classroom.example.com.

[student@servera ~]$ host classroom.example.com
classroom.example.com has address 172.25.254.254
Modify /etc/hosts so that the additional name of class can be used to access the IP address 172.25.254.254.

127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

172.25.254.254 classroom.example.com classroom class
172.25.254.254 content.example.com content
...content omitted...
Look up the IP address of class.

[student@servera ~]$ host class
Host class not found: 2(SERVFAIL)
[student@servera ~]$ getent hosts class
172.25.254.254    classroom.example.com class
Ping class.

[student@servera ~]$ ping -c3 class
PING classroom.example.com (172.25.254.254) 56(84) bytes of data.
64 bytes from classroom.example.com (172.25.254.254): icmp_seq=1 ttl=64 time=0.397 ms
64 bytes from classroom.example.com (172.25.254.254): icmp_seq=2 ttl=64 time=0.447 ms
64 bytes from classroom.example.com (172.25.254.254): icmp_seq=3 ttl=64 time=0.470 ms

--- classroom.example.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2000ms
rtt min/avg/max/mdev = 0.397/0.438/0.470/0.030 ms
Exit from servera.