set PATH ~/.bin /usr/local/sbin $PATH
# Git shortcuts
# update local repo even with local changes
alias ks-update "git stash; and git pull --rebase; and git push; and git stash apply"
# update release branch
alias ks-release "git checkout release; and git merge master; and git push; and git checkout master"
# update preview branch
alias ks-preview "git checkout preview; and git merge master; and git push; and git checkout master"