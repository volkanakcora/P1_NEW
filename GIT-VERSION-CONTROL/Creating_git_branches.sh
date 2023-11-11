'Organizing and Incorporating Changes with Branches'


[user@host repository]$ git log main..my-feature   -> 'Note that it only shows commits that are on the my-feature branch, but not ones on main.'




'Creating a Branch
'

#[user@host repository]$ git branch my-branch

!!! 'Note that the git branch command only creates the branch, it does not switch you to that branch.'


'Deleting a Branch'

'you can delete a branch by including the -d option.
'

#[user@host repository]$ git branch -d new-feature
Deleted branch new-feature (was ade3e6a).




'Navigating Branches'


'The git checkout command is largely responsible for navigating between locations 
in the repository. It takes a single argument of where you would like to go, usually a branch name.'


the following command switches to the my-bugfix branch:

#[user@host repository]$ git checkout my-bugfix
Switched to branch 'my-bugfix'


A common shortcut to create a branch and check it out in one go is to use the -b flag, for example:

#[user@host repository]$ git checkout -b wizard-dialog-prompt
Switched to a new branch 'wizard-dialog-prompt'




' MERGING '

assume you are on a branch named simple-change. Running git merge other-change would merge the commits 
from other-change into simple-change. In this case, simple-change gets updated, but other-change does not.



[[[[ EXERCISE ]]]]

#[user@host DO400]$ cd hello-branches
#[user@host hello-branches]$ git init .
Initialized empty Git repository in ...output omitted.../DO400/hello-branches/.git/


Create the helloworld.py file with the following content:

def say_hello(name):
    print(f"Hello, {name}!")

say_hello("world")


------------------------------------------------------------------------
'Stage and commit the file:'


#[user@host hello-branches]$ git add helloworld.py
#[user@host hello-branches]$ git commit -m "added helloworld"
[master (root-commit) d4e8453] added helloworld
 1 file changed, 4 insertions(+)
 create mode 100644 helloworld.py


'Rename the current branch master to main
'
[user@host hello-branches]$ git branch -M main

------------------------------------------------------------------------
'Create a new branch named different-name.
'
#[user@host hello-branches]$ git checkout -b different-name
Switched to a new branch 'different-name'







'Check that your current branch is the newly created different-name.'

#[user@host hello-branches]$ git status
On branch different-name
nothing to commit, working tree clean


------------------------------------------------------------------------
'Update the helloworld.py file to match:
'
def say_hello(name):
    print(f"Hello, {name}!")

say_hello("Pablo")


'View the changes made to helloworld.py.
'

#[user@host hello-branches]$ git diff


'Stage and commit the changes to helloworld.py:
'
#[user@host hello-branches]$ git add .
#[user@host hello-branches]$ git commit -m 'change name'
[different-name daf5db4] change name
 1 file changed, 1 insertion(+), 1 deletion(-)



Check git log 
#[user@host hello-branches]$ git log







------------------------------------------------------------------------
'Switch to the main branch:
'
#[user@host hello-branches]$ git checkout main
Switched to branch 'main'


'View the commit history of the main branch:
'
#[user@host hello-branches]$ git log
commit d4e8453f6bc58a757a15f5ace664b3cd9afb65f6 (HEAD -> main)
Author: Your User Name <your.email@example.com>
Date:   Mon Sep 28 16:32:52 2020 -0400

    added helloworld




------------------------------------------------------------------------

'Merge the different-name branch into the main branch'

#[user@host hello-branches]$ git merge different-name
Updating d4e8453..daf5db4
Fast-forward
 helloworld.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)



-----------------------------------------------------------------------

'In case there is an conflict, it will fail and will tell you to fix'

