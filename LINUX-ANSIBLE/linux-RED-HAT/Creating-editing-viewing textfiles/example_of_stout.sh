Examples for Output Redirection

Many routine administration tasks are simplified by using redirection. Use the previous table to assist while considering the following examples:

    Save a time stamp for later reference.

    [user@host ~]$ date > /tmp/saved-timestamp

    Copy the last 100 lines from a log file to another file.

    [user@host ~]$ tail -n 100 /var/log/dmesg > /tmp/last-100-boot-messages

    Concatenate four files into one.

    [user@host ~]$ cat file1 file2 file3 file4 > /tmp/all-four-in-one

    List the home directory's hidden and regular file names into a file.

    [user@host ~]$ ls -a > /tmp/my-file-names

    Append output to an existing file.

    [user@host ~]$ echo "new line of information" >> /tmp/many-lines-of-information
    [user@host ~]$ diff previous-file current-file >> /tmp/tracking-changes-made

    The next few commands generate error messages because some system directories are inaccessible to normal users. Observe as the error messages are redirected. Redirect errors to a file while viewing normal command output on the terminal.

    [user@host ~]$ find /etc -name passwd 2> /tmp/errors

    Save process output and error messages to separate files.

    [user@host ~]$ find /etc -name passwd > /tmp/output 2> /tmp/errors

    Ignore and discard error messages.

    [user@host ~]$ find /etc -name passwd > /tmp/output 2> /dev/null

    Store output and generated errors together.

    [user@host ~]$ find /etc -name passwd &> /tmp/save-both

    Append output and generated errors to an existing file.

    [user@host ~]$ find /etc -name passwd >> /tmp/save-both 2>&1