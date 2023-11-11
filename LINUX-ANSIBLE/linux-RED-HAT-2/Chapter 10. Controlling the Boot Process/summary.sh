rebo'Selecting the Boot Target'


'Selecting a Systemd Target
A systemd target is a set of systemd units that the system should start to reach a desired state. The following table lists the most important targets.'

Table 10.1. Commonly Used Targets

'Target	Purpose'

graphical.target	'System supports multiple users, graphical- and text-based logins.'
multi-user.target	'System supports multiple users, text-based logins only.'
rescue.target	'sulogin prompt, basic system initialization completed.'
emergency.target	'sulogin prompt, initramfs pivot complete, and system root mounted on / read only.'



'A target can be a part of another target. For example, the graphical.target includes multi-user.target, which in turn depends on 
basic.target and others. You can view these dependencies with the following command.
'
[user@host ~]# systemctl list-dependencies graphical.target | grep target

graphical.target
* └─multi-user.target
*   ├─basic.target
*   │ ├─paths.target
*   │ ├─slices.target
*   │ ├─sockets.target
*   │ ├─sysinit.target
*   │ │ ├─cryptsetup.target
*   │ │ ├─local-fs.target
*   │ │ └─swap.target
...output omitted...




'To list the available targets, use the following command.
'
[user@host ~]# systemctl list-units --type=target --all
  UNIT                      LOAD      ACTIVE   SUB    DESCRIPTION
  ---------------------------------------------------------------------------
  basic.target              loaded    active   active Basic System
  cryptsetup.target         loaded    active   active Local Encrypted Volumes
  emergency.target          loaded    inactive dead   Emergency Mode
  getty-pre.target          loaded    inactive dead   Login Prompts (Pre)
  getty.target              loaded    active   active Login Prompts
  graphical.target          loaded    inactive dead   Graphical Interface



'Selecting a Target at Runtime

On a running system, administrators can switch to a different target using the systemctl isolate command.'

[root@host ~]# systemctl isolate multi-user.target

'solating a target stops all services not required by that target (and its dependencies), and starts any required services not yet started.'



'Not all targets can be isolated. You can only isolate targets that have AllowIsolate=yes set in their unit files. 
For example, you can isolate the graphical target, but not the cryptsetup target.'

[user@host ~]# systemctl cat graphical.target
# /usr/lib/systemd/system/graphical.target
...output omitted...
[Unit]
Description=Graphical Interface
Documentation=man:systemd.special(7)
Requires=multi-user.target
Wants=display-manager.service
Conflicts=rescue.service rescue.target
After=multi-user.target rescue.service rescue.target display-manager.service
'AllowIsolate=yes


'[user@host ~]# systemctl cat cryptsetup.target
# /usr/lib/systemd/system/cryptsetup.target
...output omitted...
[Unit]
Description=Local Encrypted Volumes
Documentation=man:systemd.special(7)


'Setting a Default Target
'



[root@host ~]# systemctl get-default
multi-user.target
[root@host ~]# systemctl set-default graphical.target
Removed /etc/systemd/system/default.target.
Created symlink /etc/systemd/system/default.target -> /usr/lib/systemd/system/graphical.target.
[root@host ~]# systemctl get-default
graphical.target


'Selecting a Different Target at Boot Time
'
'To select a different target at boot time, append the systemd.unit=target.target option to the kernel command line from the boot loader.

For example, to boot the system into a rescue shell where you can change the system configuration with almost no services running, 
append the following option to the kernel command line from the boot loader.'

systemd.unit=rescue.target



''''''''''''''''Resetting the Root Password'''''''''''''
'''''


--> Resetting the Root Password from the Boot Loader


'One task that every system administrator should be able to accomplish is resetting a lost root password. 
If the administrator is still logged in, either as an unprivileged user but with full sudo access, or as root,'


'Several methods exist to set a new root password. A system administrator could, for example, 
boot the system using a Live CD, mount the root file system from there, and edit /etc/shadow. 
In this section, we explore a method that does not require the use of external media.'


RHEL8(

    'On Red Hat Enterprise Linux 8, it is possible to have the scripts that run from the initramfs pause at certain points, 
    provide a root shell, and then continue when that shell exits. This is mostly meant for debugging, but you can also use 
    this method to reset a lost root password.'
)


'To access that root shell, follow these steps:
'
--> Reboot the system.

--> Interrupt the boot loader countdown by pressing any key, except Enter.

--> Move the cursor to the kernel entry to boot.

--> Press e to edit the selected entry.

--> Move the cursor to the kernel command line (the line that starts with linux).

--> Append 'rd.break'. With that option, the system breaks just before the system hands control from the initramfs to the actual system.

--> Press Ctrl+x to boot with the changes.




To reset the root password from this point, use the following procedure:

'Remount /sysroot as read/write.'
switch_root:/# mount -o remount,rw /sysroot


'Switch into a chroot jail, where /sysroot is treated as the root of the file-system tree.'
switch_root:/# chroot /sysroot


'Set a new root password.'
sh-4.4# passwd root

'Make sure that all unlabeled files, including /etc/shadow at this point, get relabeled during boot.'
sh-4.4# touch /.autorelabel

'Type exit twice. The first command exits the chroot jail, and the second command exits the initramfs debug shell.'





''''''''Inspecting Logs''''''''''

'Remember that by default, the system journals are kept in the /run/log/journal directory, which means the journals 
are cleared when the system reboots. To store journals in the /var/log/journal 
directory, which persists across reboots, set the Storage parameter to persistent in /etc/systemd/journald.conf.'

[root@host ~]# vim /etc/systemd/journald.conf
...output omitted...
[Journal]
Storage=persistent
...output omitted...
[root@host ~]# systemctl restart systemd-journald.service


'To inspect the logs of a previous boot, use the -b option of journalctl. Without any arguments, the -b option only displays messages since the last boot.'

[root@host ~]# journalctl -b -1 -p err



'Repairing Systemd Boot Issues'

'By enabling the debug-shell service with systemctl enable debug-shell.service, 
the system spawns a root shell on TTY9 (Ctrl+Alt+F9) early during the boot sequence. 
This shell is automatically logged in as root, so that administrators can debug the system while the operating system is still booting.'



''''''''Repairing File System Issues at Boot''''''

---> ''''''Diagnosing and Fixing File System Issues''''''

'Errors in /etc/fstab and corrupt file systems can stop a system from booting. In most cases, 
systemd drops to an emergency repair shell that requires the root password.'



Common File System Issues

Problem	Result

Corrupt file system	'systemd attempts to repair the file system. If the problem is too severe for an automatic fix, 
the system drops the user to an emergency shell.'

Nonexistent device or UUID referenced in /etc/fstab	'systemd waits for a set amount of time, waiting for the device to become available. 
If the device does not become available, the system drops the user to an emergency shell after the timeout.'

Nonexistent mount point in /etc/fstab	'The system drops the user to an emergency shell.'


Incorrect mount option specified in /etc/fstab	'The system drops the user to an emergency shell.
'

'In all cases, administrators can also use the emergency target to diagnose and fix the issue, because no file systems are mounted before the emergency shell is displayed.'

NOTE
'When using the emergency shell to address file-system issues, do not forget to run systemctl daemon-reload after editing /etc/fstab. Without this reload, systemd may continue using the old version.'

