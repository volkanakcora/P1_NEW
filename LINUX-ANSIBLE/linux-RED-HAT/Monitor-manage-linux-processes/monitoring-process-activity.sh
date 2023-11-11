"The uptime command is one way to display the current load average. It prints the current time, how long the machine has been up, 
how many user sessions are running, and the current load average.": uptime

"The lscpu command can help you determine how many CPUs a system has.": lscpu

"The top program is a dynamic view of the system's processes, displaying a summary": top

Process state (S) displays as:  ps S 

D = Uninterruptible Sleeping

R = Running or Runnable

S = Sleeping

T = Stopped or Traced

Z = Zombie



Table 8.3. Fundamental Keystrokes in top

"Key	Purpose
"? or h"	Help for interactive keystrokes.
"l, t, m"	Toggles for load, threads, and memory header lines.
"1"	Toggle showing individual CPUs or a summary for all CPUs in header.
"s (1)"	Change the refresh (screen) rate, in decimal seconds (e.g., 0.5, 1, 5).
b	Toggle reverse highlighting for Running processes; default is bold only.
Shift+b	Enables use of bold in display, in the header, and for Running processes.
Shift+h	Toggle threads; show process summary or individual threads.
u, Shift+u	Filter for any user name (effective, real).
Shift+m	Sorts process listing by memory usage, in descending order.
Shift+p	Sorts process listing by processor utilization, in descending order.
k (1)	Kill a process. When prompted, enter PID, then signal.
r (1)	Renice a process. When prompted, enter PID, then nice_value.
Shift+w	Write (save) the current display configuration for use at the next top restart.
q	Quit.
f	Manage the columns by enabling or disabling fields. Also allows you to set the sort field for top.
Note:	(1) Not available if top started in secure mode. See top(1)."

When finished observing the load average values, terminate each of the monitor processes from within top.

In the right terminal shell, press k. Observe the prompt below the headers and above the columns.

...output omitted...
PID to signal/kill [default pid = 11338] 
The prompt has chosen the monitor processes at the top of the list. Press Enter to kill the process.

...output omitted...
Send pid 11338 signal [15/sigterm] 
Press Enter again to confirm the SIGTERM signal 15.

Confirm that the selected process is no longer observed in top. 
If the PID still remains, repeat these terminating steps, substituting SIGKILL signal 9 when prompted.

"NOTE THAT "K" stops the process of the top process of the "top" command"

In the right terminal shell, press k. Observe the prompt below the headers and above the columns.h