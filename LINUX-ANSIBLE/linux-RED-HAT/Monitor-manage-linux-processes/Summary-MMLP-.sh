ps aux 

ps lax 

ps -ef 

& = runs process in the background 

ps j = 'The ps j command displays information relating to jobs'

'Use the vim command to create a script called control in the 
/home/student/bin directory. To enter Vim interactive mode, press the i key. Use the :wq command to save the file.
'
[student@servera ~]$ vim /home/student/bin/control
#!/bin/bash
while true; do
  echo -n "$@ " >> ~/control_outfile
  sleep 1
done 


'Use the chmod command to make the control file executable.
'
[student@servera ~]# chmod +x /home/student/bin/control

jobs = 'shows current jobs' 

'The job number of each new process is printed in square brackets. '

bg %1 -> brings the background to foreground, -> ctrl + c (kills) ,,, ctrl + z (terminates)


#3 Killing processes



Term - 'Cause a program to terminate (exit) at once.'

Core - 'Cause a program to save a memory image (core dump), then terminate.'

Stop - 'Cause a program to stop executing (suspend) and wait to continue (resume).'

to 'suspend' (Ctrl+z), 'kill' (Ctrl+c), or 'core dump' (Ctrl+\) the process.


kill -l

kill -9 5199


# pkill for multiple killings

pkill control
[1]   Terminated              control pkill1
[2]-  Terminated              control pkill2


pkill -U user  'kills all process of an user'

' It is recommended to send SIGTERM first, 
then try SIGINT, and only if both fail retry with SIGKILL.'


'catch process of an user' = #pgrep -l -u oh856

'all process of oh856 will be killed '=# pkill -SIGKILL -u oh856


'se the pstree command to view a process tree for the system or a single user. 
'
pstree -p bob
bash(8391)─┬─sleep(8425)
           ├─sleep(8426)
           └─sleep(8427)

pkill -P 8391
[root@host ~]# pgrep -l -u bob
bash(8391)

kill -SIGTERM 
kill -SIGTERM 
kill -SIGCONT %1



#### KEYSTROKES IN TOP 

? or h	'Help for interactive keystrokes.'
l, t, m	'Toggles for load, threads, and memory header lines.'
1	'Toggle showing individual CPUs or a summary for all CPUs in header.'
s (1)	'Change the refresh (screen) rate, in decimal seconds (e.g., 0.5, 1, 5).'
b	'Toggle reverse highlighting for Running processes; default is bold only.'
Shift+b	'Enables use of bold in display, in the header, and for Running processes.'
Shift+h	'Toggle threads; show process summary or individual threads.'
u, Shift+u	'Filter for any user name (effective, real).'
Shift+m	'Sorts process listing by memory usage, in descending order.'
Shift+p	'Sorts process listing by processor utilization, in descending order.'
k (1)	'Kill a process. When prompted, enter PID, then signal.'
r (1)	'Renice a process. When prompted, enter PID, then nice_value.'
Shift+w	'Write (save) the current display configuration for use at the next top restart.'
q	Quit.
f	'Manage the columns by enabling or disabling fields. Also allows you to set the sort field for top.'
Note:	(1) Not available if top started in secure mode. See top(1).



make file running in background = # process101 &



shift w => save conf of 'top'

create scripts to make artificial cpu load, run them, and kill them by pkill -SIGSTOP process101

or pkill 'name of process'

fg %1 -> brings job foreground, then you might kill them by control zc

bg &1 -back ground 

