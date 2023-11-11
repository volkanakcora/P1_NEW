"Table 3.3. Table of Metacharacters and Matches

Pattern	Matches
*	Any string of zero or more characters.
?	Any single character.
[abc...]	Any one character in the enclosed class (between the square brackets).
[!abc...]	Any one character not in the enclosed class.
[^abc...]	Any one character not in the enclosed class.
[[:alpha:]]	Any alphabetic character.
[[:lower:]]	Any lowercase character.
[[:upper:]]	Any uppercase character.
[[:alnum:]]	Any alphabetic character or digit.
[[:punct:]]	Any printable character not a space or alphanumeric.
[[:digit:]]	Any single digit from 0 to 9.
[[:space:]]	Any single white space character. This may include tabs, newlines, carriage returns, form feeds, or spaces.
"


touch echo {sunday,monday}.log 

"SOME EXAMPLES:"

echo Today is $(date +%A).
Today is Wednesday.
[user@host glob]$ echo The time is $(date +%M) minutes past $(date +%l%p).

*b search for filenames ending with b 

"Create a total of 12 files with names tv_seasonX_episodeY.ogg. Replace X with the season number and Y with that season's episode, for two seasons of six episodes each.

[student@serverb ~]$ touch tv_season{1..2}_episode{1..6}.ogg
[student@serverb ~]$ ls tv*"


Use the man -k zip command to list detailed information about a ZIP archive

Use the man -k boot to list the man page containing a list of parameters that can be passed to the kernel at boot time.

"Info documentation is comprehensive and hyperlinked.
 It is possible to output info pages to multiple formats.
  By contrast, man pages are optimized for printed output.
   The Info format is more flexible than man pages, allowing thorough discussion of complex commands and concepts.
    Like man pages, Info nodes are read from the command line, using the pinfo command."

Some commands and utilities have both man pages and info documentation; usually,
 the Info documentation is more in depth. Compare the differences in tar documentation using man and pinfo: