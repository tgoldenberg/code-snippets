#### Useful snippets 

- `git branch | grep -v "master" | xargs git branch -D` - delete all local branches except for `master`

- `git branch --merged | grep -v "\*" | grep -v master | grep -v dev | grep -v production| xargs -n 1 git branch -d` - delete all local branches that are merged into current branch except for dev and master

- `git rm -r --cached node_modules` - remove node_modules from git history
