'Sending Email with Postfix'

Postfix is a powerful and easy to configure mail server, provided by the postfix RPM package. Postfix operates as a set of cooperating programs that are coordinated by a daemon called master. The most important 
Postfix configuration file is '/etc/postfix/main.cf.'



'Modifying the Main Postfix Configuration'

 You can manage /etc/postfix/main.cf configuration file settings in one of two ways: by editing the file directly with a text editor, 
 or by using the postconf utility.

The postconf command can display current values for all Postfix configuration settings or for individual settings. 
It can modify settings, display the built-in default values for settings not explicitly set, or show only the current configuration 
settings that differ from the built-in defaults.

'    Running postconf without parameters displays all /etc/postfix/main.cf settings.
'
    [root@host ~]# postconf
    2bounce_notice_recipient = postmaster
    access_map_defer_code = 450
    access_map_reject_code = 554
    address_verify_cache_cleanup_interval = 12h
    address_verify_default_transport = $default_transport
    ...output omitted...

     Specify a particular set of options, separated by white space, to display only their values.

    [root@host ~]# postconf inet_interfaces myorigin
    inet_interfaces = loopback-only
    myorigin = $myhostname



!!! IMPORTANT  /etc/postfix/main.cf values that start with a dollar sign ($) are not literal values, but reference the value of another setting. In the preceding example, the myorigin setting has the same value as the myhostname setting. This syntax simplifies maintenance, because the value only has to be updated in one place. 

Change /etc/postfix/main.cf settings with the 'postconf -e 'setting = value'' command. This command edits an existing setting with the 
specified value, otherwise it adds a line at the bottom of the configuration file with the new setting.

For example, the following command changes the myorigin setting so that messages sent from the server use example.com as 
the domain part of the sender's email address instead of the server's hostname.

[root@host ~]# postconf -e 'myorigin = example.com'

###You must reload (or restart) the postfix service when you change any settings in /etc/postfix/main.cf to make the changes take effect. 




                                                            'Configuring Postfix as a Null Client'



Postfix Null Client Configuration Settings


inet_interfaces                   'Set to loopback-only. This configures Postfix to listen for new email messages on port 25/TCP only on the addresses 127.0.0.1 or ::1. (Therefore, only for messages sent by the null client itself.) '


mynetworks                        ' Set to 127.0.0.0/8 [::1]/128. This configures Postfix to submit messages to the mail relay for hosts on any network on the mynetworks settings list of values. The items on this list may be separated by commas or white space.'


myorigin                          'Set to the DNS domain that email sent by users of this system should appear to be coming from.'


relayhost                         'This submits all outgoing messages to that relay for delivery. For example, relayhost = [smtp.example.com] submits all messages to the relay on smtp.example.com. By default, messages are submitted in plain text to port 25/TCP on the mail relay, with no authentication'


mydestination                      'Mail addressed to a user on the list of domains in mydestination domains is accepted by Postfix for delivery to a local mailbox. Because a null client does not accept email for local delivery, this should be blank.'




                                                'Submitting Email to an Authenticated Relay'


The preceding example assumes that your outbound mail relay does not require authentication or authenticates null clients based on their 
IP addresses. However, it is common to implement a mail relay as a message submission agent (MSA) that listens for its null clients on port 
587/TCP instead of 25/TCP, requires TLS encryption, and requires authentication of the null client. 


 Assuming that your MSA accepts user name and password authentication, you would need to make the following changes to the Postfix configuration on the null client:

    'relayhost' = [smtp.example.com]:587 (add :587 to your relayhost value)

    'smtp_use_tls' = yes to use TLS

    'smtp_sasl_auth_enable' = yes to use authentication

    'smtp_sasl_security_options' = noanonymous to require authentication and allow username/password as a method

    'smtp_sasl_password_maps' = hash:/etc/postfix/sasl_passwd to use /etc/postfix/sasl_passwd to store the user name and password for authentication 



Edit your /etc/postfix/sasl_passwd file to contain the definition of your relayhost and the colon-separated user name and password needed to 
authenticate to the MSA. In this example, relayuser@example.com is the user name and mysecretpassword is the password for relaying mail:

#[smtp.example.com]:587 relayuser@example.com:mysecretpassword


Run postmap /etc/postfix/sasl_passwd to update the Postfix configuration with your password. Make sure that both /etc/postfix/sasl_passwd 
and the /etc/postfix/sasl_passwd.db file that postmap creates are owned by user root, group root, and are readable only by root. 




                                                'Troubleshooting Email Transmission'

The systemd journal keeps a log of all mail-related operations about the postfix.service daemon. Additionally, the /var/log/maillog 
log file includes information about any mail server-related actions. 


Use the postqueue command when messages are not being delivered to a remote SMTP server. The 'postqueue -p' command displays a list of any 
outgoing mail messages that have been queued. The postqueue -f command immediately attempts to deliver all queued messages again. Postfix 
normally attempts to resend queued messages about once an hour until they are either accepted or expire. 


If your emails are delivered to a server that provides POP3 or IMAP access to clients, you can install the mutt package and use the mutt 
command to retrieve your messages. The following command connects to an IMAP server on imap.lab.example.com, prompts you to authenticate, 
and displays your messages on that server in your terminal window:

#[user@host ~]$ mutt -f imaps://imap.lab.example.com









                                                        'EXERCISE'

                                                         
1)        
'Install the postfix package.
'
[root@servera ~]# yum install postfix


2)
'Use the relayhost directive to configure Postfix to deliver all messages to the corporate mail relay. Enclose the host name of the corporate mail relay in square brackets to prevent an MX record lookup with the DNS server.
'
[root@servera ~]# postconf -e 'relayhost=[smtp.lab.example.com]'


3)

'Configure the servera Postfix null client to only relay mail from the local system.
'
    Configure Postfix to only listen on the loopback interfaces. Add the inet_interfaces=loopback-only directive to the 
    /etc/postfix/main.cf configuration file.

    [root@servera ~]# postconf -e 'inet_interfaces=loopback-only'


    Configure Postfix to only deliver messages that originate from the 127.0.0.0/8 IPv4 network and the [::1]/128 IPv6 network.

    [root@servera ~]# postconf -e 'mynetworks=127.0.0.0/8 [::1]/128'



5)
'Configure the null client to rewrite the sender email addresses of all outgoing messages to the company domain lab.example.com.'

[root@servera ~]# postconf -e 'myorigin=lab.example.com'

6)

'Prohibit the Postfix null client from delivering any mail to local accounts.'

    Configure the null client to forward all mail to the relay server. Set the mydestination option to an empty value to achieve this.

    [root@servera ~]# postconf -e 'mydestination='



7)
'Enable and start Postfix on servera.'

[root@servera ~]# systemctl enable --now postfix


8)

'Open a new terminal on servera. Test the null client configuration by sending a message with servera null client as the subject and null 
client test as the content to student@lab.example.com. The mail command uses /usr/sbin/sendmail, provided by Postfix, to transfer email.'

#[student@servera ~]$ mail -s 'servera null client' student@lab.example.com
#null client test
#.
EOT


9)
'Use the mutt command-line mail client to verify that the mail was delivered to the specified recipient. Access the IMAP server running on imap.lab.example.com with the IMAPS protocol. Authenticate to the IMAP server as the student user with the password student.
'
    Read mail for student on imap.lab.example.com with the mutt command-line email client, using the IMAPS protocol.

    #[student@servera ~]$ mutt -f imaps://imap.lab.example.com

    The command prompts you to accept the host SSL certificate, and then prompts you for your user name and password. Type a to permanently accept the certificate.

    Authenticate to the IMAP server as the student user with the password student.

    'Username at imap.lab.example.com: student
    Password for student@imap.lab.example.com: student'
    

    Verify that the test message arrived in the student user's email account. Read the message and confirm the sender's email address is student@lab.example.com.

    q:Quit  d:Del  u:Undel  s:Save  m:Mail  r:Reply  g:Group  ?:Help
    ...
       1   F May 20                 (0.4K) servera null client
    q

    Press q to return to the main menu when you finish reading the message. Press q again to exit mutt. 