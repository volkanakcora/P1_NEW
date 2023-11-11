## A standard logging system based on the Syslog protocol is built into Red Hat Enterprise Linux. 
#Many programs use this system to record events and organize them into log files. The systemd-journald and rsyslog services handle the syslog messages in Red Hat Enterprise Linux 8.

Selected System Log Files

Log file	Type of Messages Stored
/var/log/messages

Most syslog messages are logged here. Exceptions include messages related to authentication and email processing, scheduled job execution, and those which are purely debugging-related.

/var/log/secure

Syslog messages related to security and authentication events.

/var/log/maillog

Syslog messages related to the mail server.

/var/log/cron

Syslog messages related to scheduled job execution.

/var/log/boot.log

Non-syslog console messages related to system startup.