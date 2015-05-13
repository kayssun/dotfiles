set PATH ~/.bin /usr/local/sbin $PATH

# Git shortcuts
# update local repo even with local changes
alias ks-update "git stash; and git pull --rebase; and git push; and git stash apply"
# update release branch
alias ks-release "git checkout release; and git merge master; and git push; and git checkout master"
# update preview branch
alias ks-preview "git checkout preview; and git merge master; and git push; and git checkout master"

if test -f local.fish
  . local.fish
end

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

  set prompt_dircolor (set_color 050)

  set_color normal
  switch $USER
  case root
    set prompt_finisher_color (set_color red)
    set prompt_finisher ' #'
  case '*'
    set prompt_finisher_color (set_color green)
    set prompt_finisher ' >'
  end
  
  echo -n "$host_icon $prompt_dircolor" (_short_pwd)
  
  if test $git_status != ""
    echo -n " ($git_status)"
  end

  if test $last_status != 0
    set_color red
    echo -n " [$last_status]"
  end
  
  echo -n "$prompt_finisher_color$prompt_finisher "
end

function fish_greeting
  echo "$USER on "(hostname|cut -d . -f 1)
  date
end