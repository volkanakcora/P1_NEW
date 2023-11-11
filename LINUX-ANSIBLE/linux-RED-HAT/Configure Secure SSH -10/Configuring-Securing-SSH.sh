"how to print full hostname of remote system:" [student@servera ~]$ ssh student@serverb hostname

SSH Key-based Authentication
You can configure an SSH server to allow you to authenticate without a password by using key-based authentication. 
This is based on a private-public key scheme.

To do this, you generate a matched pair of cryptographic key files. One is a private key, 
the other a matching public key. The private key file is used as the authentication credential and, like a password, 
must be kept secret and secure. The public key is copied to systems the user wants to connect to, and is used to 
verify the private key. The public key does not need to be secret.

You put a copy of the public key in your account on the server. When you try to log in, 
the SSH server can use the public key to issue a challenge that can only be correctly answered by using the private key. 
As a result, your ssh client can automatically authenticate your login to the server with your unique copy of the private key. 
This allows you to securely access systems in a way that doesn't require you to enter a password interactively every time.

The -f option with the ssh-keygen command determines the files 
where the keys are saved. In the preceding example, the private and 
public keys are saved in the /home/user/.ssh/key-with-pass /home/user/.ssh/key-with-pass.pub files, respectively.

WARNING
During further SSH keypair generation, unless you specify a unique file name, you are prompted for 
permission to overwrite the existing id_rsa and id_rsa.pub files. If you overwrite the existing id_rsa 
and id_rsa.pub files, then you must replace the old public key with the new one on all the SSH servers 
that have your old public key.

Once the SSH keys have been generated, they are stored by default in the .ssh/ 
directory of the user's home directory. The permission modes must be 600 on the private key and 644 on the public key.


Sharing the Public Key

Before key-based authentication can be used, the public key 
needs to be copied to the destination system. The ssh-copy-id 
command copies the public key of the SSH keypair to the destination system. 
If you omit the path to the public key file while running ssh-copy-id, it uses the default /home/user/.ssh/id_rsa.pub file.

[user@host ~]$ ssh-copy-id -i .ssh/key-with-pass.pub user@remotehost
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/user/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
user@remotehosts password: redhat
Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'user@remotehost'"
and check to make sure that only the key(s) you wanted were added.
After the public key is successfully transferred to a remote system, 
you can authenticate to the remote system using the corresponding private key while 
logging in to the remote system over SSH. If you omit the path to the private key file while 
running the ssh command, it uses the default /home/user/.ssh/id_rsa file.

[user@host ~]$ ssh -i .ssh/key-with-pass user@remotehost
Enter passphrase for key '.ssh/key-with-pass': redhatpass
...output omitted...
[user@remotehost ~]$ exit
logout
Connection to remotehost closed.
[user@host ~]$ 




####### EXERCISE OF SSH#############


Guided Exercise: Customizing OpenSSH Service Configuration
In this exercise, you will disable direct logins as root and password-based authentication for the OpenSSH service on one of your servers.

Outcomes

You should be able to:

Disable direct logins as root over ssh.

Disable password-based authentication for remote users to connect over SSH.

Log in to workstation as student using student as the password.

On workstation, run lab ssh-customize start to start the exercise. This script creates the necessary user accounts and files.

[student@workstation ~]$ lab ssh-customize start
From workstation, open an SSH session to serverb as student.

'[student@workstation ~]$ ssh student@serverb
'...output omitted...
[student@serverb ~]$ 
Use the su command to switch to operator2 on serverb. Use redhat as the password of operator2.

[student@serverb ~]$ su - operator2
Password: redhat
[operator2@serverb ~]$ 
Use the ssh-keygen command to generate SSH keys. Do not enter any passphrase for the keys.

[operator2@serverb ~]$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/operator2/.ssh/id_rsa): Enter
Created directory '/home/operator2/.ssh'.
Enter passphrase (empty for no passphrase): Enter
Enter same passphrase again: Enter
Your identification has been saved in /home/operator2/.ssh/id_rsa.
Your public key has been saved in /home/operator2/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:JainiQdnRosC+xXhOqsJQQLzBNUldb+jJbyrCZQBERI operator1@serverb.lab.example.com
The key's randomart image is:
+---[RSA 2048]----+
|E+*+ooo .        |
|.= o.o o .       |
|o.. = . . o      |
|+. + * . o .     |
|+ = X . S +      |
| + @ +   = .     |
|. + =   o        |
|.o . . . .       |
|o     o..        |
+----[SHA256]-----+
Use the ssh-copy-id command to send the public key of the SSH key pair to operator2 on servera. Use redhat as the password of operator2 on servera.

[operator2@serverb ~]$ ssh-copy-id operator2@servera
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/operator1/.ssh/id_rsa.pub"
The authenticity of host 'servera (172.25.250.10)' can't be established.
ECDSA key fingerprint is SHA256:ERTdjooOIrIwVSZQnqD5or+JbXfidg0udb3DXBuHWzA.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
operator2@servera's password: redhat
Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'operator2@servera'"
and check to make sure that only the key(s) you wanted were added.
Confirm that you can successfully log in to servera as operator2 using the SSH keys.

Open an SSH session to servera as operator2.

[operator2@serverb ~]$ ssh operator2@servera
...output omitted...
[operator2@servera ~]$ 
Notice that the preceding ssh command used SSH keys for authentication.

Log out of servera.

[operator2@servera ~]$ exit
logout
Connection to servera closed.
Confirm that you can successfully log in to servera as root using redhat as the password.

Open an SSH session to servera as root using redhat as the password.

[operator2@serverb ~]$ ssh root@servera
root@servera's password: redhat
...output omitted...
[root@servera ~]# 
Notice that the preceding ssh command used the password of the superuser for authentication because SSH keys do not exist for the superuser.

Log out of servera.

[root@servera ~]# exit
logout
Connection to servera closed.
[operator2@serverb ~]$ 
Confirm that you can successfully log in to servera as operator3 using redhat as the password.

Open an SSH session to servera as operator3 using redhat as the password.

[operator2@serverb ~]$ ssh operator3@servera
operator3@servera's password: redhat
...output omitted...
[operator3@servera ~]$ 
Notice that the preceding ssh command used the password of operator3 for authentication because SSH keys do not exist for operator3.

Log out of servera.

[operator3@servera ~]$ exit
logout
Connection to servera closed.
[operator2@serverb ~]$ 
Configure sshd on servera to prevent users logging in as root. Use redhat as the password of the superuser when required.

Open an SSH session to servera as operator2 using the SSH keys.

[operator2@serverb ~]$ ssh operator2@servera
...output omitted...
[operator2@servera ~]$ 
On servera, switch to root. Use redhat as the password of the root user.

[operator2@servera ~]$ su -
Password: redhat
[root@servera ~]# 
Set PermitRootLogin to no in '/etc/ssh/sshd_config' and reload sshd. You may use vim /etc/ssh/sshd_config to edit the configuration file of sshd.

...output omitted...
PermitRootLogin no
...output omitted...
[root@servera ~]# systemctl reload sshd
Open another terminal on workstation and open an SSH session to serverb as operator2. From serverb, try logging in to servera as root. This should fail because you disabled root user login over SSH in the preceding step.

NOTE
For your convenience, password-less login is already configured between workstation and serverb in the classroom environment.

[student@workstation ~]$ ssh operator2@serverb
...output omitted...
[operator2@serverb ~]$ ssh root@servera
root@servera's password: redhat
Permission denied, please try again.
root@servera's password: redhat
Permission denied, please try again.
root@servera's password: redhat
root@servera: Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password).
By default, the ssh command attempts to authenticate using key-based authentication first and then, if that fails, password-based authentication.

Configure sshd on servera to allow users to authenticate using SSH keys only, rather than their passwords.

Return to the first terminal that has the root user's shell active on servera. 'Set PasswordAuthentication to no in /etc/ssh/sshd_config' and reload sshd. You may use vim /etc/ssh/sshd_config to edit the configuration file of sshd.

...output omitted...
PasswordAuthentication no
...output omitted...
[root@servera ~]# systemctl reload sshd
Go to the second terminal that has operator2 user's shell active on serverb and try logging in to servera as operator3. This should fail because SSH keys are not configured for operator3, and the sshd service on servera does not allow the use of passwords for authentication.

[operator2@serverb ~]$ ssh operator3@servera
operator3@servera: Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
NOTE
For more granularity, you may use the explicit -o PubkeyAuthentication=no and -o PasswordAuthentication=yes options with the ssh command. This allows you to override the ssh command's defaults and confidently determine that the preceding command fails based on the settings you adjusted in /etc/ssh/sshd_config in the preceding step.

Return to the first terminal that has the root user's shell active on servera. Verify that PubkeyAuthentication is enabled in /etc/ssh/sshd_config. You may use vim /etc/ssh/sshd_config to view the configuration file of sshd.

...output omitted...
#PubkeyAuthentication yes
...output omitted...
Notice that the PubkeyAuthentication line is commented. Any commented line in this file uses the default value. Commented lines indicate the default values of a parameter. The public key authentication of SSH is active by default, as the commented line indicates.

Return to the second terminal that has operator2 user's shell active on serverb and try logging in to servera as operator2. This should succeed because the SSH keys are configured for operator2 to log in to servera from serverb.

[operator2@serverb ~]$ ssh operator2@servera
...output omitted...
[operator2@servera ~]$ 
From the second terminal, exit the operator2 user's shell on both servera and serverb.

[operator2@servera ~]$ exit
logout
Connection to servera closed.
[operator2@serverb ~]$ exit
logout
Connection to serverb closed.
[student@workstation ~]$ 
Close the second terminal on workstation.

[student@workstation ~]$ exit
From the first terminal, exit the root user's shell on servera.

[root@servera ~]# exit
logout
From the first terminal, exit the operator2 user's shell on both servera and serverb.

[operator2@servera ~]$ exit
logout
Connection to servera closed.
[operator2@serverb ~]$ exit
logout
[student@serverb ~]$ 
Log out of serverb and return to the student user's shell on workstation.

[student@serverb ~]$ exit
logout
Connection to serverb closed.
[student@workstation ~]$ 
Finish

On workstation, run lab ssh-customize finish to complete this exercise.

[student@workstation ~]$ lab ssh-customize finish


Password authentication = no 
pukey authentication = yes no

ssh-keygen : to generate the pass 

ssh-copy-id : send the key to  the target server 

