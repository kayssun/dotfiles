set PATH ~/.bin /usr/local/sbin $PATH

# Git shortcuts
# update local repo even with local changes
alias ks-update "git stash; and git pull --rebase; and git push; and git stash apply"
# update release branch
alias ks-release "git checkout release; and git merge master; and git push; and git checkout master"
# update preview branch
alias ks-preview "git checkout preview; and git merge master; and git push; and git checkout master"

# My MacBook Luna
set host_icon '🌒'

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _short_pwd
  echo $PWD | sed -e "s|^$HOME|~|"
end

# Prompt with: Icon, path, git branch, return status
function fish_prompt
  set -l last_status $status
  set -l git_status (_git_branch_name)

  set_color green
  echo -n "$host_icon " (_short_pwd)
  
  if test $git_status != ""
    echo -n " ($git_status)"
  end

  if test $last_status != 0
    set_color red
    echo -n " [$last_status]"
  end
  
  set_color normal
  echo ' > '
end