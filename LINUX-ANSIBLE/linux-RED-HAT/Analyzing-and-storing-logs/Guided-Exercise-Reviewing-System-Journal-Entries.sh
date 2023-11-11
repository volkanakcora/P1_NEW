Use the _PID=1 match with the journalctl command to display only log events originating from the systemd process running with the process 
identifier of 1 on servera. To quit journalctl, press q.

[student@servera ~]$ journalctl _PID=1

Use the _UID=81 match with the journalctl command to display all log events originating from a system service started with the user identifier of 81 on servera. 
To quit journalctl press q.

journalctl _UID=81


Use the -p warning option with the journalctl command to display log events with priority warning and above on servera. To quit journalctl press q.

[student@servera ~]$ journalctl -p warning