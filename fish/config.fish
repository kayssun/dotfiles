set PATH ~/.bin /usr/local/sbin $PATH

# Ensure the variable is set when fish starts
set CMD_DURATION 1
set REPORTTIME 0

# Set REPORTTIME to 10s on fish versions greater than 2.2.0
set version_major (echo $version | cut -d "." -f 1)
set version_minor (echo $version | cut -d "." -f 1)
if [ $version_major -ge 2 -a $version_minor -ge 2 ]
  set REPORTTIME 10000
end

function fish_greeting
  echo "$USER on "(hostname|cut -d . -f 1)
  date
end

# Prefer vim
set -x EDITOR "vim"

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
  /sbin/ifconfig | grep "2a01:4f8:191:13b4:" > /dev/null
end

function _set_promt_host_color
  if test $host_color
  else
    set -g host_color "red"

    # use blue on the local macs
    if test (uname) = "Darwin"
      set -g host_color "blue"
    end

    # use orange on the staging machines
    if _is_staging_server
      set -g host_color "D71"
    end
  end

  set -g prompt_host_color (set_color $host_color)
end

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _short_pwd
  echo $PWD | sed -e "s|^$HOME|~|"
end

if status -i
  # we're interactive
  _set_promt_host_color
end

# Prompt with: Icon, path, git branch, return status
function fish_prompt
  set -l last_status $status
  set -l git_status (_git_branch_name)
  set prompt_dircolor (set_color 050)

  set_color normal

  if [ "$REPORTTIME" != "0" -a "$CMD_DURATION" -gt "$REPORTTIME" ]
    set_color blue
    echo ""
    echo "Last command took" (math "$CMD_DURATION/1000") "seconds."
    set_color normal    
  end

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
  
  # Add one space. You might want to add another one to $host_icon, because emoji are pretty wide
  if test $host_icon; echo -n "$host_icon "; end;

  if test $prompt_show_host
    echo -n "$prompt_host_color$prompt_user"(hostname -s)" "
  end

  echo -n "$prompt_dircolor"(_short_pwd)

  if test $git_status != ""
    echo -n " ($git_status)"
  end

  if test $last_status != 0
    set_color red
    echo -n " [$last_status]"
  end
  
  echo -n "$prompt_finisher_color$prompt_finisher "
end

