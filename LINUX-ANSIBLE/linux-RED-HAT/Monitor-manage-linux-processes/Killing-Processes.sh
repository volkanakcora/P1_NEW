Use the kill with the -SIGSTOP option to stop the network process. Run the jobs to confirm it is stopped.

[student@servera bin]$ kill -SIGSTOP %1
[1]+  Stopped                 killing network
[student@servera bin]$ jobs
[1]+  Stopped                 killing network
[2]   Running                 killing interface &
[3]-  Running                 killing connection & 

Process control using signals
A signal is a software interrupt delivered to a process. Signals report events to an executing program. Events that generate a signal can be an error, external event (an I/O request or an expired timer), or by explicit use of a signal-sending command or keyboard sequence.

The following table lists the fundamental signals used by system administrators for routine process management. Refer to signals by either their short (HUP) or proper (SIGHUP) name.

Table 8.2. Fundamental Process Management Signals

Signal number	Short name	Definition	Purpose
1	HUP	Hangup	
Used to report termination of the controlling process of a terminal. Also used to request process reinitialization (configuration reload) without termination.

2	INT	Keyboard interrupt	
Causes program termination. Can be blocked or handled. Sent by pressing INTR key sequence (Ctrl+c).

3	QUIT	Keyboard quit	
Similar to SIGINT; adds a process dump at termination. Sent by pressing QUIT key sequence (Ctrl+\).

9	KILL	Kill, unblockable	
Causes abrupt program termination. Cannot be blocked, ignored, or handled; always fatal.

15default	TERM	Terminate	
Causes program termination. Unlike SIGKILL, can be blocked, ignored, or handled. The “polite” way to ask a program to terminate; allows self-cleanup.

18	CONT	Continue	
Sent to a process to resume, if stopped. Cannot be blocked. Even if handled, always resumes the process.

19	STOP	Stop, unblockable	
Suspends the process. Cannot be blocked or handled.

20	TSTP	Keyboard stop	
Unlike SIGSTOP, can be blocked, ignored, or handled. Sent by pressing SUSP key sequence (Ctrl+z).


[user@host ~]$ kill -l
 1) SIGHUP      2) SIGINT      3) SIGQUIT     4) SIGILL      5) SIGTRAP
 6) SIGABRT     7) SIGBUS      8) SIGFPE      9) SIGKILL    10) SIGUSR1
11) SIGSEGV    12) SIGUSR2    13) SIGPIPE    14) SIGALRM    15) SIGTERM
16) SIGSTKFLT  17) SIGCHLD    18) SIGCONT    19) SIGSTOP    20) SIGTSTP

killall control