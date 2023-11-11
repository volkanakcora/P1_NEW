To retrieve log messages from the journal, use the journalctl command.

The journalctl command highlights important log messages: messages at notice or warning priority are in bold text while messages at the error priority or higher are in red text.

By default, journalctl -n shows the last 10 log entries.

journalctl -p err : command to list journal entries at the err priority or higher:


When looking for specific events, 
you can limit the output to a specific time frame. The journalctl command has two options to limit the output to a specific 
time range, the --since and --until options. Both options take a time argument in the format "YYYY-MM-DD hh:mm:ss" 
(the double-quotes are required to preserve the space in the option). If the date is omitted, the command assumes the current day, 
and if the time is omitted, the command assumes the whole day starting at 00:00:00. Both options take yesterday, today, and tomorrow as valid arguments in addition to the 
date and time field.

Run the following journalctl command to list all journal entries from today's records.

journalctl --since today


Run the following journalctl command to list all journal entries ranging from 2019-02-10 20:30:00 to 2019-02-13 12:00:00.

[root@host ~]# journalctl --since "2019-02-10 20:30:00" \
--until "2019-02-13 12:00:00"

journalctl --since "-1 hour"


##In addition to the visible content of the journal, there are fields attached to the log entries that can only be seen when verbose output is turned on. 
Any displayed extra field can be used to filter the output of a journal query. This is useful to reduce the output of complex searches for certain events in the journal.

journalctl -o verbose # explained version

###                 The following list gives the common fields of the system journal that can be used to search for lines relevant to a particular process or event.

_COMM is the name of the command

_EXE is the path to the executable for the process

_PID is the PID of the process

_UID is the UID of the user running the process

_SYSTEMD_UNIT is the systemd unit that started the process

######               More than one of the system journal fields can be combined to form a granular search query with the journalctl command. For example, 
the following journalctl command shows all journal entries related to the sshd.service systemd unit from a process with PID 1182.

[root@host ~]# journalctl _SYSTEMD_UNIT=sshd.service _PID=1182

#### or a list of commonly used journal fields, consult the systemd.journal-fields(7) man page.