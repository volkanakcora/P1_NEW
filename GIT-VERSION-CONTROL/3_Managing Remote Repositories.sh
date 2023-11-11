                                                       RMEOTE Branches

''Local branches': Branches that exist in your local repository. You normally organize, 
carry out your work, and commit changes by using local branches.'



Remote branches: 'Branches that exist in a remote repository. For example, all the branches in a 
GitHub repository are considered remote branches. Teams use remote branches for coordination, review and collaboration.'




                                                      Working with Remotes

Cloning a Repository:

#[user@host ~]$ git clone https://github.com/YOUR_GITHUB_USER/your-repo.git


Adding a Remote to a Local Repository:

#[user@host ~]$ cd your-repo
#[user@host your-repo]$ git remote -v
'origin	https://github.com/your_github_user/your-repo.git (fetch)
origin	https://github.com/your_github_user/your-repo.git (push)'


To add a new remote, use the git remote add command, followed by a name and the URL of the remote repository:

#[user@host your-local-repo]$ git remote add my-remote https://github.com/YOUR_GITHUB_USER/your-repo.git
[user@host your-local-repo]$


                                                            Pushing to the Remote

commit is in the local branch only. To update the remote branch with your new commit, you must push your changes to the remote. 
To push changes, use the git push command, specifying the remote and the branch that you want to push. When using the git push command, 
you push the currently selected local branch.

#[user@host your-local-repo]$ git status
On branch my-new-feature 
...output omitted...

#[user@host your-local-repo]$ git push origin my-new-feature 
Enumerating objects: 4, done.
Counting objects: 100% (4/4), done.
Delta compression using up to 12 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 297 bytes | 297.00 KiB/s, done.
Total 3 (delta 0), reused 1 (delta 0)
To https://github.com/your_github_user/test-repo.git
   e137e9b..1c016b6  my-new-feature -> my-new-feature


                                                            Pulling from the Remote


To keep your local copy up to date with the remote, you must pull changes from the remote frequently.


- > 'Fetching and Merging Changes':

#[user@host your-local-repo]$ git fetch
remote: Enumerating objects: 4, done.
remote: Counting objects: 100% (4/4), done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), done.
From https://github.com/your_github_user/test-repo
   e137e9b..1c016b6  main       -> origin/main



To also update your local main branch, you must merge the origin/main remote-tracking branch into your local main branch, by using the git merge command.

#[user@host your-local-repo]$ git checkout main
Switched to branch 'main'
Your branch is behind 'origin/main' by 1 commit, and can be fast-forwarded.
  (use "git pull" to update your local branch)


#[user@host your-local-repo]$ git merge origin/main   'ALTERNATIVELEY -> [user@host your-local-repo]$ git pull origin main 

Updating e137e9b..1c016b6
Fast-forward
...output omitted...




[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[   exercises ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

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


                'Navigate to the hello-remote folder and initialize a new repository:
'
#[user@host DO400]$ cd hello-remote
#[user@host hello-remote]$ git init .
Initialized empty Git repository in ...output omitted.../DO400/hello-remote/.git/



                'Stage and commit the file:'

#[user@host hello-remote]$ git add helloworld.py
#[user@host hello-remote]$ git commit -m "added helloworld"




                'Use the git remote add command to add the remote repository:
'
#[user@host hello-remote]$ git remote add origin https://github.com/YOUR_GITHUB_USER/hello-remote.git
Verify that the remote has been added:

#[user@host hello-remote]$ git remote -v
origin	https://github.com/your_github_user/hello-remote.git (fetch)
origin	https://github.com/your_github_user/hello-remote.git (push)



                'Set the upstream branch and push to the remote repository. '

#[user@host hello-remote]$ git push --set-upstream origin main


'Create a new branch named improve-greeting:
'
[user@host hello-remote]$ git branch improve-greeting

'Checkout the improve-greeting branch:
'
[user@host hello-remote]$ git checkout improve-greeting
Switched to branch 'improve-greeting'




                'AFTER YOU MAKE CHANGES ON BRANCH, HOW TO PUSH IT:'

'Set the branch upstream and push the branch to GitHub:
'
#[user@host hello-remote]$ git push --set-upstream origin improve-greeting



                'Check that the changes you just merged are not in the main remote tracking branch.'

#[user@host hello-remote]$ git log origin/main



                'Fetch changes from the remote repository.'

#[user@host hello-remote]$ git fetch -p


'Check that the merged commits have been fetched. Run the git log command again:'

#[user@host hello-remote]$ git log origin/main



'Merge the remote-tracking origin/main branch into the local main branch.'

#[user@host hello-remote]$ git merge origin/main


