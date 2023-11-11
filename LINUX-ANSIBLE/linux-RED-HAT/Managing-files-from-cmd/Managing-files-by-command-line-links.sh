"/usr	Installed software, shared libraries, include files, and read-only program data. Important subdirectories include:
/usr/bin: User commands.

/usr/sbin: System administration commands.

/usr/local: Locally customized software.

/etc	Configuration files specific to this system.
/var	Variable data specific to this system that should persist between boots. Files that dynamically change, such as databases, cache directories, log files, printer-spooled documents, and website content may be found under /var.
/run	Runtime data for processes started since the last boot. This includes process ID files and lock files, among other things. The contents of this directory are recreated on reboot. This directory consolidates /var/run and /var/lock from earlier versions of Red Hat Enterprise Linux.
/home	Home directories are where regular users store their personal data and configuration files.
/root	Home directory for the administrative superuser, root.
/tmp	A world-writable space for temporary files. Files which have not been accessed, changed, or modified for 10 days are deleted from this directory automatically. Another temporary directory exists, /var/tmp, in which files that have not been accessed, changed, or modified in more than 30 days are deleted automatically.
/boot	Files needed in order to start the boot process.
/dev	Contains special device files that are used by the system to access hardware." 


ls-R "shows the different directories and their files"


"Activity	Command Syntax
Create a directory	"mkdir directory"
Copy a file	"cp file new-file"
Copy a directory and its contents	"cp -r directory new-directory"
Move or rename a file or directory "mv file new-file"
Remove a file	"rm file"
Remove a directory containing files"	rm -r directory"
Remove an empty directory	"rmdir directory""


"Use the mkdir -p command and space-delimited relative paths for
 each of the subdirectory names to create multiple parent
  directories with subdirectories.

[user@host Documents]$ mkdir -p Thesis/Chapter1 
Thesis/Chapter2 Thesis/Chapter3"

"copying files"  cd /home/volkan/music/song1.mp3 .(current dir means)

ls -il  "shown links"
ln -s "creates soft link"


ln /home/volkan/files/file /home/volkan/backups/source.backup "how to create
hard link"


how to move the file = mv film1.avi film2.avi film3.avi film4.avi \
film5.avi film6.avi Videos

how to copy files = cp ~/Music/song1.mp3 ~/Music/song2.mp3 \
~/Pictures/snap1.jpg ~/Pictures/snap2.jpg ~/Videos/film1.avi \
~/Videos/film2.avi .

