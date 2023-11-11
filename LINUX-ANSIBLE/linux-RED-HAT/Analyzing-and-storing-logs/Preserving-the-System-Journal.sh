Storing the System Journal Permanently
By default, the system journals are kept in the /run/log/journal directory, which means the journals are cleared when the system reboots. 
You can change the configuration settings of the systemd-journald service in the /etc/systemd/journald.conf file to make the journals persist across reboot.

The Storage parameter in the /etc/systemd/journald.conf file defines whether to store system journals in a volatile manner or persistently across reboot. 
Set this parameter to persistent, volatile, auto, or none as follows:

persi'stent: stores journals in the /var/log/journal directory which persists across reboots.

If the /var/log/journal directory does not exist, the systemd-journald service creates it.

'volatile': stores journals in the volatile /run/log/journal directory.

As the /run file system is temporary and exists only in the runtime memory, data stored in it, including system journals, do not persist across a reboot.

'auto': if the /var/log/journal directory exists, then systemd-journald uses persistent storage, otherwise it uses volatile storage.

This is the default action if the Storage parameter is not set.

'none': do not use any storage. All logs are dropped but log forwarding will still work as expected.


Configuring Persistent System Journals

To configure the systemd-journald service to preserve system journals persistently across reboot, set Storage to persistent in the /etc/systemd/journald.conf file. 
Run the text editor of your choice as the superuser to edit the /etc/systemd/journald.conf file.

[Journal]
Storage=persistent
...output omitted...
After editing the configuration file, restart the systemd-journald service to bring the configuration changes into effect.

[root@host ~]# systemctl restart systemd-journald




NOTE
When debugging a system crash with a persistent journal, it is usually required to limit the journal query to the reboot before the crash happened. 
The -b option can be accompanied by a negative number indicating how many prior system boots the output should include. 
For example, journalctl -b -1 limits the output to only the previous boot.

