'Installing and enabling tuned

''A minimal Red Hat Enterprise Linux 8 installation includes and enables the tuned package by default. To install and enable the package manually:
'
[root@host ~]# yum install tuned
[root@host ~]# systemctl enable --now tuned
Created symlink /etc/systemd/system/multi-user.target.wants/tuned.service → /usr/lib/systemd/system/tuned.service.


Tuned Profile	Purpose

balanced 'Ideal for systems that require a compromise between power saving and performance.'

desktop 'Derived from the balanced profile. Provides faster response of interactive applications.'

throughput-performance 'Tunes the system for maximum throughput.
'
latency-performance 'Ideal for server systems that require low latency at the expense of power consumption.'

network-latency  'Derived from the latency-performance profile. It enables additional network tuning parameters to provide low network latency.'

network-throughput  'Derived from the throughput-performance profile. Additional network tuning parameters are applied for maximum network throughput.'

powersave 'Tunes the system for maximum power saving.'

oracle 'Optimized for Oracle database loads based on the throughput-performance profile.'

virtual-guest 'Tunes the system for maximum performance if it runs on a virtual machine.'

virtual-host 'Tunes the system for maximum performance if it acts as a host for virtual machines.'



#####           Managing profiles from the command line
'
The 'tuned-adm' command is used to change settings of the tuned daemon. The 'tuned-adm' command can query current settings, list available profiles, 
recommend a tuning profile for the system, change profiles directly, or turn off tuning.'

'A system administrator identifies the currently active tuning profile with 'tuned-adm' active.'


'The 'tuned-adm list' command lists all available tuning profiles, including both built-in profiles and custom tuning profiles 
created by a system administrator.'

[root@host ~]# tuned-adm list
Available profiles:
- balanced
- desktop
- latency-performance
- network-latency
- network-throughput
- powersave
- sap
- throughput-performance
- virtual-guest
- virtual-host
Current active profile: virtual-guest




#### change it 

Use 'tuned-adm profile profilename' to switch the active profile to a different one

[root@host ~]# tuned-adm profile throughput-performance
[root@host ~]# tuned-adm active
Current active profile: throughput-performance

'OR USE 'tune-adm recommend' to see recommended one'

[root@host ~]# tuned-adm recommend
virtual-guest

#### TURN ON- OFF 

[root@host ~]# tuned-adm off
[root@host ~]# tuned-adm active
No current active profile.

##### Influencing Process Scheduling  ########


nice and renice commands.

'The nice level values range from -20 (highest priority) to 19 (lowest priority). ' 


how to list nice levels: 

[user@host ~]# ps axo pid,comm,nice,cls --sort=-nice

'nice command starts the process with nice value of 10' 

[user@host ~]# nice sha1sum /dev/zero &
[1] 3517
[user@host ~]# ps -o pid,comm,nice 3517
  PID COMMAND          NI
 3517 sha1sum          10

'Use the -n option to apply a user-defined nice level to the starting process. '

[user@host ~]# nice -n 15 sha1sum &
[1] 3521
[user@host ~]# ps -o pid,comm,nice 3521
  PID COMMAND          NI
 3521 sha1sum          15

'''Changing the Nice Level of an Existing Process'''

[user@host ~]# renice -n 19 3521
3521 (process ID) old priority 15, new priority 19



####### EXAMPLE ###########

'START 3 PROCESSES: 
'
[student@servera ~]$ for i in $(seq 1 3); do sha1sum /dev/zero & done
[1] 2643
[2] 2644
[3] 2645


'AND START ANOTHER WITH 10 NICE LEVEL:'

[student@servera ~]$ nice -n 10 sha1sum /dev/zero &


'CHECK AND SEE THE DIFFERENCES'

[student@servera ~]$ ps -o pid,pcpu,nice,comm $(pgrep sha1sum)    #3 OR USE PS U OR PS  10 LEVEL OF NICE USE LESS CPU 

  PID %CPU  NI COMMAND
 1947 66.0   0 sha1sum
 1948 65.7   0 sha1sum
 1949 66.1   0 sha1sum
 1953  6.7  10 sha1sum


'Use the sudo renice command to lower the nice level of a process from the previous step. '

renice -n 5 1953  ->> and see it increaded the cpu usage 

