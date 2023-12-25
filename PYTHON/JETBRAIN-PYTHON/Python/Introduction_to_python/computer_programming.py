#As you know, every variable has a name that uniquely identifies it among other variables.
#Giving a good name to a variable may not be as simple as it seem

#Code style convention
#PEP 8 provides some rules for variable names to increase code readability.

#Use lowercase and underscores to split words. Even if it's an abbreviation.

http_response  # yes!
httpresponse   # no
myVariable     # no, that's from Java

#However, if you want to define a constant, it's common to write its name in all capital letters and, again, 
#separate words with underscores. Normally, constants are stored in special files called modules. 
#Although we'll cover this later, here is a small example:

SPEED_OF_LIGHT = 299792458

#Other variable names best practices:


score  # yes!
s      # no

count  # yes!
n      # no


http_response                  # yes!
var1                           # no
http_response_from_the_server  # no, some words can be dropped

#If a word is long, try to find the most common and expected short form to make it easier to guess later.

output_file_path  # yes!
fpath             # no
output_flpth      # no