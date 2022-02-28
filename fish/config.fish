set PATH ~/.bin /usr/local/sbin $PATH

# Ensure the variable is set when fish starts
set CMD_DURATION 1
set REPORTTIME 0

# Disable custom prompt for python virtual environments (breaks custom prompt)
set VIRTUAL_ENV_DISABLE_PROMPT 1

set REPORTTIME 10000

set NOTIFICATION_TIME 0 # Ensure it's set
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

# Default setting: show username and host in prompt
set -gx prompt_show_host 1
set show_flow_context 1
set fish_emoji_width 2

if test -f ~/.dotfiles/fish/functions.fish
  source ~/.dotfiles/fish/functions.fish
end

#if test -f ~/.dotfiles/fish/macos.fish -a (uname) = "Darwin"
#  source ~/.dotfiles/fish/macos.fish
#end

if test -f ~/.config/fish/local.fish
  source ~/.config/fish/local.fish
end

if status --is-interactive

  if test $prompt_hostname
  else
    set prompt_hostname (hostname | cut -d . -f 1)
  end

  if status -i
    # we're interactive
    _set_promt_host_color
  end

  # Prompt with: Icon, path, git branch, return status
  function fish_prompt
    set -l last_status $status
    # if eval $ITERM2_INTEGRATION; iterm2_status $last_status; end
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

    # Add one space. You might want to add another one to $host_icon, because emoji are pretty wide
    if test $host_icon; echo -n "$host_icon "; end;

    if test $prompt_show_host
      echo -n "$prompt_host_color$prompt_user$prompt_hostname "
    end

    echo -n "$prompt_dircolor"(_short_pwd)

    if test -n "$VIRTUAL_ENV"
        echo -n " 🐍"
    end

    if test $last_status != 0
      set_color red
      echo -n " [$last_status]"
    end

    echo -n "$prompt_finisher_color$prompt_finisher "
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

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
