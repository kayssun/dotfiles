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

# Prefer fish on other hosts (they need to be configured to respect this)
set -x PREFERRED_SHELL "fish"

# This ensures bash can still be used
alias bash "env PREFERRED_SHELL=bash bash"

# Git shortcuts
# update local repo even with local changes
alias ks-update "git stash save 'ks-update'; and git pull --rebase; and git push; and git stash pop"
# update release branch
alias ks-release "git checkout release; and git merge master; and git push; and git checkout master"
# update preview branch
alias ks-preview "git checkout preview; and git merge master; and git push; and git checkout master"

# Default setting: show username and host in prompt
set -gx prompt_show_host 1

if test -f ~/.dotfiles/fish/functions.fish
  . ~/.dotfiles/fish/functions.fish
end

if test -f ~/.config/fish/local.fish
  . ~/.config/fish/local.fish
end

if status --is-interactive

  if test $hostname
  else
    set hostname (hostname | cut -d . -f 1)
  end

  # Configure iTerm variables
  printf "\033]1337;ShellIntegrationVersion=1\007"

  if status -i
    # we're interactive
    _set_promt_host_color
  end

  # Prompt with: Icon, path, git branch, return status
  function fish_prompt
    set -l last_status $status
    iterm2_status $last_status
    set -l git_status (_git_branch_name)
    set prompt_dircolor (set_color 050)

    set_color normal

    # Ensure the variable is always set (otherwise it breaks on old fish versions)
    test -n "$CMD_DURATION"; or set CMD_DURATION 0

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
    
    # Before we output the prompt, mark the spot
    iterm2_prompt_start
    
    # Add one space. You might want to add another one to $host_icon, because emoji are pretty wide
    if test $host_icon; echo -n "$host_icon "; end;

    if test $prompt_show_host
      echo -n "$prompt_host_color$prompt_user$hostname "
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
    iterm2_prompt_end
  end
end
