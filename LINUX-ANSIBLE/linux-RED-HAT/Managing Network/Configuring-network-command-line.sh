###
The nmcli dev status command displays the status of all network devices:

[user@host ~]$ nmcli dev status

Summary of Commands
The following table is a list of key nmcli commands discussed in this section.

Command	Purpose
'nmcli dev status'	Show the NetworkManager status of all network interfaces.
'nmcli con show'	List all connections.
'nmcli con show' name	List the current settings for the connection name.
'nmcli con add con-name' name	Add a new connection named name.
'nmcli con mod name'	Modify the connection name.
'nmcli con reload'	Reload the configuration files (useful after they have been edited by hand).
'nmcli con up name'	Activate the connection name.
'nmcli dev dis dev'	Deactivate and disconnect the current connection on the network interface dev.
'nmcli con del name	'Delete the connection name and its configuration file.