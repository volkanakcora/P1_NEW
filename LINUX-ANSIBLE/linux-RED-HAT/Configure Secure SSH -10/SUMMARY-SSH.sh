'Generate SSH-Keygen' 

# ssh-keygen
'
If you do not specify a passphrase 
when ssh-keygen prompts you, the generated private key is not protected. In this case, anyone with your private key file could use it 
for authentication'


'The following example of the ssh-keygen command shows the creation of the passphrase-protected private key alongside the public key.
'
[user@host ~]# ssh-keygen -f .ssh/key-with-pass

'HOW TO SHARE PUBLIC KEY TO REMOTE HOST'

#ssh-copy-id -i .ssh/key-with-pass.pub user@remotehost

'After the public key is successfully transferred to a remote system, you can authenticate to the remote system using the corresponding private key'

#ssh -i .ssh/key-with-pass user@remotehost 


'Using ssh-agent for Non-interactive Authentication'

[user@host ~]$ eval $(ssh-agent)


'Once ssh-agent is running, you need to tell it the passphrase for your private key or keys. You can do this with the ssh-add command.
'
'The following ssh-add commands add the private keys from /home/user/.ssh/id_rsa (the default) and /home/user/.ssh/key-with-pass files, respectively.
'
[user@host ~]# ssh-add
Identity added: /home/user/.ssh/id_rsa (user@host.lab.example.com)
[user@host ~]# ssh-add .ssh/key-with-pass
Enter passphrase for .ssh/key-with-pass: redhatpass
Identity added: .ssh/key-with-pass (user@host.lab.example.com)

if you store pass somewhere else, use -i option 


'How to execute command remotely':

#ssh operator1@servera hostname 

'How to execute command remotely with specified key':

#ssh -i  .ssh/key2.pub operator1@servera hostname 

'Add prase to make it more secure and send it to remote host':

#ssh-copy-id .ssh/key2.pub operator1@servera

'Another important point is that you should generate -f command to have different directory'


### SSH AGENTS 

'You can use ssh-agent, as in the following step, to avoid interactively typing in the passphrase while logging in with SSH. Using ssh-agent is both more convenient and more secure in 
situations where the administrators log in to remote systems regularly.'

eval $(ssh-agent)

ssh-add .ssh/key2 


basically use phrasepass to make it more secure ssh-keygen ,,, then copy it

ssh-copy-id -i (path)  operator1@servera 

then use ssh-agent via eval to avoid entering pass each time 



#### controlling openssh service configuration in bash

'You might want to prohibit direct remote login to the root account, and you might want to prohibit password-based authentication
 (in favor of SSH private key authentication).'


'The OpenSSH server uses the PermitRootLogin configuration setting in the /etc/ssh/sshd_config configuration file to allow or prohibit users logging in to the system as root.
'
PermitRootLogin yes -> change this to no, so others cant access to root

[root@host ~]# systemctl reload sshd


'Prohibiting Password-Based Authentication for SSH
'

PasswordAuthentication yes  -> change this to no, so others cant log in without sshd

'The default value of yes for the PasswordAuthentication parameter in the /etc/ssh/sshd_config configuration file causes the SSH server to allow users to use password-based authentication while logging in. The value of no for 
PasswordAuthentication prevents users from using password-based authentication.'

