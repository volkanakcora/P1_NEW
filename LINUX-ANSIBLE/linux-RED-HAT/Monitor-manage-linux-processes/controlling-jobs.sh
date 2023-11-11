The job is immediately placed in the background and is suspended.

The ps j command displays information relating to jobs. The PID is the unique process ID of the process. THe PPID is the PID of the parent process of this process, the process that started (forked) it. The PGID is the PID of the process group leader, normally the first process in the job's pipeline. The SID is the PID of the session leader, which (for a job) is normally the interactive shell that is running on its controlling terminal. Since the example sleep command is currently suspended, its process state is T.

[user@host ~]$ ps j
 PPID   PID  PGID   SID TTY      TPGID STAT   UID   TIME COMMAND
 2764  2768  2768  2768 pts/0     6377 Ss    1000   0:00 /bin/bash
 2768  5947  5947  2768 pts/0     6377 T     1000   0:00 sleep 10000
 2768  6377  6377  2768 pts/0     6377 R+    1000   0:00 ps j
To start the suspended process running in the background, use the bg command with the same job ID.

[user@host ~]$ bg %1
[1]+ sleep 10000 &
The shell will warn a user who attempts to exit a terminal window (session) with suspended jobs. If the user tries exiting again immediately, the suspended jobs are killed.

Running Jobs in the Background
Any command or pipeline can be started in the background by appending an ampersand (&) to the end of the command line. The Bash shell displays a job number (unique to the session) and the PID of the new child process. The shell does not wait for the child process to terminate, but rather displays the shell prompt.

[user@host ~]$ sleep 10000 &
[1] 5947
[user@host ~]$ 