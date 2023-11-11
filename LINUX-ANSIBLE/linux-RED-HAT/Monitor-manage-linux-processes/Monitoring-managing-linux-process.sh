Which state represents a process that has been stopped or suspended? T 

Which state represents a process that has released all of its resources except its PID? Z 

Table 8.1. Linux Process States

Name	Flag	Kernel-defined state name and description
Running	R	
TASK_RUNNING: The process is either executing on a CPU or waiting to run. Process can be executing user routines or kernel routines (system calls), or be queued and ready when in the Running (or Runnable) state.

Sleeping	S	
TASK_INTERRUPTIBLE: The process is waiting for some condition: a hardware request, system resource access, or signal. When an event or signal satisfies the condition, the process returns to Running.

D	
TASK_UNINTERRUPTIBLE: This process is also Sleeping, but unlike S state, does not respond to signals. Used only when process interruption may cause an unpredictable device state.

K	
TASK_KILLABLE: Identical to the uninterruptible D state, but modified to allow a waiting task to respond to the signal that it should be killed (exit completely). Utilities frequently display Killable processes as D state.

I	
TASK_REPORT_IDLE: A subset of state D. The kernel does not count these processes when calculating load average. Used for kernel threads. Flags TASK_UNINTERRUPTABLE and TASK_NOLOAD are set. Similar to TASK_KILLABLE, also a subset of state D. It accepts fatal signals.

Stopped	T	
TASK_STOPPED: The process has been Stopped (suspended), usually by being signaled by a user or another process. The process can be continued (resumed) by another signal to return to Running.

T	
TASK_TRACED: A process that is being debugged is also temporarily Stopped and shares the same T state flag.

Zombie	Z	
EXIT_ZOMBIE: A child process signals its parent as it exits. All resources except for the process identity (PID) are released.

X	
EXIT_DEAD: When the parent cleans up (reaps) the remaining child process structure, the process is now released completely. This state will never be observed in process-listing utilities.

"Perhaps the most common set of options, aux, displays all processes including processes without a controlling terminal. A long listing (options lax) provides more technical detail, but may display faster by avoiding user name lookups. The similar UNIX syntax uses the options -ef to display all processes."