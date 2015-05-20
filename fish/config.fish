set PATH ~/.bin /usr/local/sbin $PATH

# Git shortcuts
# update local repo even with local changes
alias ks-update "git stash; and git pull --rebase; and git push; and git stash apply"
# update release branch
alias ks-release "git checkout release; and git merge master; and git push; and git checkout master"
# update preview branch
alias ks-preview "git checkout preview; and git merge master; and git push; and git checkout master"

# Default setting: show username and host in prompt
set -gx prompt_show_host 1

if test -f ~/.config/fish/local.fish
  . ~/.config/fish/local.fish
end

function _is_staging_server
  /sbin/ifconfig | grep "2a01:4f8:191:13b4:"
end

if test $prompt_host_color
else
  set -gx prompt_host_color (set_color red)

  # use blue on the local macs
  if test (uname) = "Darwin"
    set -gx prompt_host_color (set_color blue)
  end
  
  # use orange on the staging machines
  if _is_staging_server
    set -gx prompt_host_color (set_color D71)
  end
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
    set prompt_user ''
  case '*'
    set prompt_finisher_color (set_color green)
    set prompt_finisher ' >'
    set prompt_user "$USER@"
  end
  
  echo -n "$host_icon "

  if test $prompt_show_host
    echo -n " $prompt_host_color$prompt_user"(hostname -s)
  end

  echo -n "$prompt_dircolor" (_short_pwd)

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
