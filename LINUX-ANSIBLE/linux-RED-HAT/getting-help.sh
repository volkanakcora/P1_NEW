"Create a formatted output file of the passwd man page.
Call the file passwd.ps. Determine the file content format. Inspect the contents of the passwd.ps file."
q
man -t passwd > passwd.ps

file passwd.ps -> show the file type 

"man command is used for viewing and printing postrscript files"

man -k postrscript viewer

"View your PostScript file using the various evince
options you researched.
Close your document file when you are finished."

[student@workstation ~]$ evince /home/student/passwd.ps


"how to view files by firefox"

firefox /usr/share/doc


Section

Content type

1

User commands (both executable and shell programs)

2

System calls (kernel routines invoked from user space)

3

Library functions (provided by program libraries)

4

Special files (such as device files)

5

File formats (for many configuration files and structures)

6

Games (historical section for amusing programs)

7

Conventions, standards, and miscellaneous (protocols, file systems)

8

System administration and privileged commands (maintenance tasks)

9

Linux kernel API (internal kernel calls)





Command	Result
'Spacebar'	Scroll forward (down) one screen
'PageDown'	Scroll forward (down) one screen
'PageUp'	Scroll backward (up) one screen
'DownArrow'	Scroll forward (down) one line
'UpArrow'	Scroll backward (up) one line
'D'	Scroll forward (down) one half-screen
'U'	Scroll backward (up) one half-screen
'/string'	Search forward (down) for string in the man page
'N'	Repeat previous search forward (down) in the man page
'Shift+N'	Repeat previous search backward (up) in the man page
'G'	Go to start of the man page.
'Shift+G'	Go to end of the man page.
'Q'	Exit man and return to the command shell prompt
