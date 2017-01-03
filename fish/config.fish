set PATH ~/.bin /usr/local/sbin $PATH

# Ensure the variable is set when fish starts
set CMD_DURATION 1
set REPORTTIME 0
if [ $TERM_PROGRAM = "iTerm.app" ]
  set ITERM2_INTEGRATION true
else
  set ITERM2_INTEGRATION false
end

# Set REPORTTIME to 10s on fish versions greater than 2.2.0
set version_major (echo $version | cut -d "." -f 1)
set version_minor (echo $version | cut -d "." -f 1)
if [ $version_major -ge 2 -a $version_minor -ge 2 ]
  set REPORTTIME 10000
end

set NOTIFICATION_TIME 0 # ENsure it's set
if which osascript > /dev/null
  set NOTIFICATION_TIME 300000 # default to 5 Minutes on OSX
end
# Exclude interactive programs, you probably know when you quit them
set NOTIFICATION_EXCLUDES ssh fish bash vim vi tmux nano less irb pry

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
set show_flow_context 1

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
  if eval $ITERM2_INTEGRATION; printf "\033]1337;ShellIntegrationVersion=1\007"; end

  if status -i
    # we're interactive
    _set_promt_host_color
  end

  # Prompt with: Icon, path, git branch, return status
  function fish_prompt
    set -l last_status $status
    if eval $ITERM2_INTEGRATION; iterm2_status $last_status; end
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

    if [ "$NOTIFICATION_TIME" != "0" -a "$CMD_DURATION" -gt "$NOTIFICATION_TIME" ]
      set last_program (echo $history[1] | awk '{print $1}')
      # Find program name in list (add spaces at beginning/end to not match parts of a command)
      if echo " $NOTIFICATION_EXCLUDES " | grep -v -q " $last_program "
        display_notification $history[1] (math "$CMD_DURATION/1000")
      end
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
    if eval $ITERM2_INTEGRATION; iterm2_prompt_start; end
    
    # Add one space. You might want to add another one to $host_icon, because emoji are pretty wide
    if test $host_icon; echo -n "$host_icon "; end;

    if test $prompt_show_host
      echo -n "$prompt_host_color$prompt_user$hostname "
    end

    echo -n "$prompt_dircolor"(_short_pwd)

    if test $last_status != 0
      set_color red
      echo -n " [$last_status]"
    end
    
    echo -n "$prompt_finisher_color$prompt_finisher "
    if eval $ITERM2_INTEGRATION; iterm2_prompt_end; end
  end

  function fish_right_prompt -d "Write out the right prompt"
    set -l git_status (_git_branch_name)
    set_color D71

    if test $git_status != ""
      echo -n " ($git_status)"
    end

    # Output FLOW_CONTEXT for Neos projects
    if [ "$show_flow_context" = "1" -a -f "./flow" ]
      echo -n " [$FLOW_CONTEXT]"
    end
    set_color normal
  end

end
