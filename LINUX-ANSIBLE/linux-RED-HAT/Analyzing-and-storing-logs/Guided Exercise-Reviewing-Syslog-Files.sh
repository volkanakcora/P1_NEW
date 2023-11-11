Configure rsyslog on servera to log all messages with the debug priority, 
or higher, for any service into the new /var/log/messages-debug log file by adding the rsyslog configuration file /etc/rsyslog.d/debug.conf.

Create the /etc/rsyslog.d/debug.conf file with the necessary entries to redirect all log messages having the debug priority to /var/log/messages-debug. You may use the vim /etc/rsyslog.d/debug.conf command to create the file with the following content.

*.debug /var/log/messages-debug

Restart the rsyslog service.

[root@servera ~]# systemctl restart rsyslog

Use the logger command with the -p option to generate a log message with the user facility and the debug priority.

[root@servera ~]# logger -p user.debug "Debug Message Test"

tail /var/log/messages-debug # check them