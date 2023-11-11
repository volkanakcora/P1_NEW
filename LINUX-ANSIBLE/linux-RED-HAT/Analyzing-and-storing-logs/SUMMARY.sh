lOG-LEVELS 

emerg System is unusable

1

alert  Action must be taken immediately

2

crit   Critical condition

3

err    Non-critical error condition

4

warning  Warning condition

5

notice   Normal but significant event

6

info     Informational event

7

debug    Debugging-level message







'The rsyslog service uses the facility and priority of log messages to determine how to handle them. This is configured by rules in the /etc/rsyslog.conf file and any file in the 
/etc/rsyslog.d directory that has a file name extension of .conf.'









/var/log/messages

'Most syslog messages are logged here. Exceptions include messages related to authentication and email processing, scheduled job execution, and those which are purely debugging-related.
'
/var/log/secure

'Syslog messages related to security and authentication events.
'
/var/log/maillog

'Syslog messages related to the mail server.
'
/var/log/cron

'Syslog messages related to scheduled job execution.
'
/var/log/boot.log

'Non-syslog console messages related to system startup.'



'
The rsyslog service uses the facility and priority of log messages to determine how to handle them. This is configured by 
rules in the /etc/rsyslog.conf file and any file in the /etc/rsyslog.d directory that has a file name extension of .conf. Software packages 
can easily add rules by installing an appropriate file in the /etc/rsyslog.d directory.'



For example, the following line would record messages sent to the authpriv facility at any priority to the file /var/log/secure:

authpriv.*                  /var/log/secure


Sample Rules of Rsyslog
#### RULES ####

# Log all kernel messages to the console.
# Logging much else clutters up the screen.
kern.*                                                 /dev/console

# Log anything (except mail) of level info or higher.
# Don't log private authentication messages!
*.info;mail.none;authpriv.none;cron.none                /var/log/messages

# The authpriv file has restricted access.
authpriv.*                                              /var/log/secure

# Log all the mail messages in one place.
mail.*                                                  -/var/log/maillog


# Log cron stuff
cron.*                                                  /var/log/cron

# Everybody gets emergency messages
*.emerg                                                 :omusrmsg:*

# Save news errors of level crit and higher in a special file.
uucp,news.crit                                          /var/log/spooler

# Save boot messages also to boot.log
local7.*                                                /var/log/boot.log


Monitoring Logs 

'
Monitoring one or more log files for events is helpful to reproduce problems and issues. The tail -f /path/to/file command outputs 
the last 10 lines of the file specified and continues to output new lines in the file as they get written.'


how to gather debug logs 

create file in /etc/rsyslog.d/'debug.conf' and add this line ->

*.debug /var/log/messages-debug

restart rsyslog 

tail /var/log/messages-debug



'Reviewing System Journal Entries'

journalctl 

The journalctl command highlights important log messages

journalctl -n 5 -> last 5 

journalctl -f -> last 10 


'The journalctl command understands the 'debug', 'info', 'notice', 'warning', 'err', 'crit', 'alert', and 'emerg' priority levels.

Run the following journalctl command to list journal entries at the err priority or higher:
'
[root@host ~]# journalctl -p err    JOURNAL -P WARNING  ORR WATCH OUT SPECIFIC COMPONENTS BY= journalctl --since 9:00:00 _SYSTEMD_UNIT="sshd.service"


SPECIFIC EVENTS OF journalctl 

#journalctl --since today

# journalctl --since "2019-02-10 20:30:00" --until "2019-02-13 12:00:00"

#journalctl --since "-1 hour" 

The following list gives the common fields of the system journal that can be used to search for lines relevant to a particular process or event.

_COMM is the name of the command

_EXE is the path to the executable for the process

_PID is the PID of the process

_UID is the UID of the user running the process

_SYSTEMD_UNIT is the systemd unit that started the process

More than one of the system journal fields can be combined to form a granular search query with the journalctl command. For example, the following journalctl command shows all journal entries related to the sshd.service systemd unit from a process with PID 1182.

[root@host ~]# journalctl _SYSTEMD_UNIT=sshd.service _PID=1182
# [student@servera ~]$ journalctl --since 9:00:00 _SYSTEMD_UNIT="sshd.service"




#'Preserving the System Journal


'The Storage parameter in the '/etc/systemd/journald.conf' file defines whether to store system journals in a volatile manner or persistently across reboot. Set this parameter to persistent, volatile, auto, or none as follows:
'
persistent: 'stores journals in the /var/log/journal directory which persists across reboots.'




volatile: 'stores journals in the volatile /run/log/journal directory.'

'As the /run file system is temporary and exists only in the runtime memory, data stored in it, including system journals, do not persist across a reboot.
'


'auto: if the /var/log/journal directory exists, then systemd-journald uses persistent storage, otherwise it uses volatile storage.
'

'In addition, by default, the journals are not allowed to get larger than 10% 
of the file system it is on, or leave less than 15% of the file system free.
 These values can be tuned for both the runtime and persistent journals in 
 /etc/systemd/journald.conf.'

[user@host ~]# journalctl | grep -E 'Runtime|System journal'

Storing the System Journal Permanently
'By default, the system journals are kept in the /run/log/journal directory, which means the journals are cleared when the system reboots. You can change the configuration settings of the 
systemd-journald service in the /etc/systemd/journald.conf file to make the journals persist across reboot.

The Storage parameter in the /etc/systemd/journald.conf file defines whether to store system journals in a volatile manner or persistently across reboot. Set this parameter to persistent, volatile, auto, or none as follows:

'persistent': stores journals in the /var/log/journal directory which persists across reboots.

If the /var/log/journal directory does not exist, the systemd-journald service creates it.

'volatile': stores journals in the volatile /run/log/journal directory.

As the /run file system is temporary and exists only in the runtime memory, data stored in it, including system journals, do not persist across a reboot.

'auto': if the /var/log/journal directory exists, then systemd-journald uses persistent storage, otherwise it uses volatile storage.

This is the default action if the Storage parameter is not set.

none: do not use any storage. All logs are dropped but log forwarding will still work as expected.
'











HOW TO MAKE JOURNALS PERSITENT :


'To configure the systemd-journald service to preserve system journals persistently across reboot, set Storage to persistent 
in the /etc/systemd/journald.conf file.'


How to set time zone 


timedatectl list-timezones

[root@host ~]# timedatectl set-timezone America/Phoenix



#timedatectl set-time 9:00:00

The timedatectl set-ntp command enables or disables NTP synchronization for automatic time adjustment. The option requires either a true or false argument to turn it on or off. The following timedatectl command turns on NTP synchronization.

[root@host ~]# timedatectl set-ntp true