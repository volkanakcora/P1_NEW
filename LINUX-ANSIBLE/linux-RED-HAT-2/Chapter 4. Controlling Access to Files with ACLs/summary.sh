'Access Control List Concepts
'
'
Standard Linux file permissions are satisfactory when files are used by only a single owner, and a single designated group of people. 
However, some use cases require that files are accessed with different file permission sets by multiple named users and groups. 
Access Control Lists (ACLs) provide this function.'


'Changing group permissions on a file with an ACL by using chmod does not change the group owner permissions, but does change the ACL mask. 
Use 'setfacl -m g::perms file' if the intent is to update the files group owner permissions.'



'View File ACLs
'
To display ACL settings on a file, use getfacl file:

[user@host content]# getfacl reports.txt
#file: reports.txt
#owner: user
#group: operators
user::rwx
user:consultant3:---
user:1005:rwx       #effective:rw-
group::rwx          #effective:rw-
group:consultant1:r--
group:2210:rwx      #effective:rw-
mask::rw-
other::---


'Viewing Directory ACLs
'
To display ACL settings on a directory, use the getfacl directory command:

[user@host content]$ getfacl .
# file: .
# owner: user
# group: operators
# flags: -s-
user::rwx
user:consultant3:---
user:1005:rwx
group::rwx
group:consultant1:r-x
group:2210:rwx
mask::rwx
other::---
default:user::rwx
default:user:consultant3:---
default:group::rwx
default:group:consultant1:r-x
default:mask::rwx
default:other::---


'o add or modify a user or named user ACL:
'
[user@host ~]$ setfacl -m u:name:rX file


'To add or modify a group or named group ACL:
'
[user@host ~]$ setfacl -m g:name:rw file


'To add or modify the other ACL:
'
[user@host ~]$ setfacl -m o::- file    ##ypical permission settings for others are: no permissions at all, set with a dash (-); and read-only permissions set as usual with r. Of course, you can set any of the standard permissions.



'You can add multiple entries with the same command; use a comma-separated list of entries:
'
[user@host ~]$ setfacl -m u::rwx,g:consultants:rX,o::- file



'Using getfacl as Input
'
'You can use the output from getfacl as input to setfacl:
'
[user@host ~]$ getfacl file-A | setfacl --set-file=- file-B

'The '--set-file' option accepts input from a file or from stdin. The dash character '(-)' specifies the use of stdin. In this case,
'file-B' will have the same ACL settings as 'file-A.''






S'etting an Explicit ACL Mask

You can set an ACL mask explicitly on a file or directory to limit the maximum effective permissions for named users, the group owner, 
and named groups. This restricts any existing permissions that exceed the mask, but does not affect permissions that are less permissive than the mask.'

[user@host ~]$ setfacl -m m::r file

'This adds a mask value that restricts any named users, the group owner, and any named groups to read-only permission, 
regardless of their existing settings. The file owner and other users are not impacted by the mask setting.'




'Recursive ACL Modifications
'

[user@host ~]$ setfacl -R -m u:name:rX directory

'Deleting ACLs
'
'Deleting specific ACL entries follows the same basic format as the modify operation, except that '":perms"' is not specified.
'
[user@host ~]$ setfacl -x u:name,g:name file


'Controlling Default ACL File Permissions'

[user@host ~]$ setfacl -m d:u:name:rx directory

'Deleting Default ACL Entries

Delete a default ACL the same way that you delete a standard ACL, prefacing with d:, or use the -d option.'

[user@host ~]$ setfacl -x d:u:name directory