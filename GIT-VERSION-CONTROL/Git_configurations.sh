'Open a new terminal window on your workstation, and use the git config command to set up your user name.
'
#[user@host DO400]$ git config --global user.name "Your User Name"


'Use the git config command to set up your user email.
'
#[user@host DO400]$ git config --global user.email your@user.email

'Use the git config command to review your identity settings.'

#[user@host DO400]$ git config --list
user.name=Your User Name
user.email=your@user.email






'Use the 'git init' command to initialize the git repository in the current directory.
'
#[user@host git-basics]$ git init .
Initialized empty Git repository in ...output omitted.../DO400/git-basics/.git/





'Use the 'git add' command to add the new file to the staging area.
'
#[user@host git-basics]$ git add person.py




'un the 'git status' command to check that the file changes are in the staging area.
'
#[user@host git-basics]$ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

new file:   person.py






'commit a meaningful comment with the -m option.
'
#[user@host git-basics]$ git commit -m "Initial Person implementation"

[master (root-commit) b030555] Initial Person implementation
 1 file changed, 7 insertions(+)
 create mode 100644 person.py







'HOW TO RENAME THE BRANCH'

Rename the current branch master (the default in Git) to main

#[user@host git-basics]$ git branch -M main








''diff' command to view the differences between the original version of the file, and the latest changes.'



# [user@host git-basics]$ git diff
diff --git a/person.py b/person.py
index 0652fa3..7750914 100644
--- a/person.py
+++ b/person.py
@@ -1,7 +1,7 @@
 class Person:
-    def greet(self) -> None:
-        print('Hello Red Hatter!')
+    def greet(self, name: str = 'Red Hatter') -> None:
+        print('Hello {}!'.format(name))





'Run the git log command to inspect the commit history of the repository.
'
#[user@host git-basics]$ git log
commit b567b44b1fa64c428a199e9776c64fcb99c2b40d (HEAD -> main)
Author: Your User Name <your@user.email>
Date:   Mon Sep 28 11:54:23 2020 +0200

    Enhanced greeting

commit fd86e63c430e5232e028bce4e8998ec3433859bd
Author: Your User Name <your@user.email>
Date:   Mon Sep 28 11:24:07 2020 +0200

    Initial Person implementation







'Run the git show command to view the latest commit, and the changes made in the repository files.
'
#[user@host git-basics]$ git show
commit b567b44b1fa64c428a199e9776c64fcb99c2b40d (HEAD -> main)
Author: Your User Name <your@user.email>
Date:   Mon Sep 28 11:54:23 2020 +0200

    Enhanced greeting

diff --git a/person.py b/person.py
index 0652fa3..634d287 100644
--- a/person.py
+++ b/person.py
@@ -1,7 +1,8 @@
 class Person:
-    def greet(self) -> None:
-        print('Hello Red Hatter!')
+    def greet(self, name: str = 'Red Hatter') -> None:
+        print('Hello {}!'.format(name))



