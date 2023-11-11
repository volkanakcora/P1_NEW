# Each log message is categorized by a facility (the type of message) and a priority (the severity of the message). 
# Available facilities are documented in the rsyslog.conf(5) man page.


Code	Priority	Severity
0

        emerg

                    System is unusable

1

        alert

                    Action must be taken immediately

2

        crit

                    Critical condition

3

        err

                    Non-critical error condition

4

        warning

                    Warning condition

5

        notice

                    Normal but significant event

6

        info

                    Informational event

7

        debug

                    Debugging-level message

Each rule that controls how to sort syslog messages is a line in one of the configuration files. The left side of each line 
indicates the facility and severity of the syslog messages the rule matches. The right side of each line indicates what file 
to save the log message in (or where else to deliver the message). An asterisk (*) is a wildcard that matches all values.

For example, the following line would record messages sent to the authpriv facility at any priority to the file /var/log/secure:

authpriv.*                  /var/log/secure


## SAMPLE RULES OF Rsyslog

#### RULES ####

# Log all kernel messages to the console.
# Logging much else clutters up the screen.
#kern.*                                                 /dev/console

# Log anything (except mail) of level info or higher.
# Don't log private authentication messages!
*.info;mail.none;authpriv.none;cron.none                /var/log/messages

# The authpriv file has restricted access.
authpriv.*                                              /var/log/secure

# Log all the mail messages in one place.
mail.*                                                  -/var/log/maillog


# Log cron stuff
cron.*                                                  /var/log/cron

# Everybody gets emergency messages
*.emerg                                                 :omusrmsg:*

# Save news errors of level crit and higher in a special file.
uucp,news.crit                                          /var/log/spooler

# Save boot messages also to boot.log
local7.*                                                /var/log/boot.log


see the security log file: tail -f /var/log/secure

