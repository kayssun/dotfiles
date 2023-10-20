function _git_branch_name
  echo (command git rev-parse --abbrev-ref HEAD 2>/dev/null)
end

function _short_pwd
  echo $PWD | sed -e "s|^$HOME|~|"
end

function _update_environment --on-variable PWD --description "Update the environment according to .fish_environment"
  status --is-command-substitution; and return
  if [ ! -f .fish_environment ]
    return
  end

  # Read environment file and set variables
  # This version requirement will break at version 3.0
  for line in (cat .fish_environment)
    if string match -r  '^([a-zA-Z0-9_]+)\s([^ ]+)$' "$line" > /dev/null
      set set_command (string replace -r '^([a-zA-Z0-9_]+)\s([^ ]+)$' 'set -gx $1 $2' "$line")
      set info_command (string replace -r '^([a-zA-Z0-9_]+)\s([^ ]+)$' 'echo -n "Setting "; set_color D71; echo -n $1; set_color normal; echo -n " to "; set_color D71; echo $2; set_color normal' "$line")
      eval $set_command
      eval $info_command
    else
      echo "Found unparseable line in .fish_environment."
    end
  end
end

function _set_promt_host_color
  if test $host_color
  else
    set -g host_color "red"

    # use blue on the local macs
    if test (uname) = "Darwin"
      set -g host_color "blue"
    end
  end

  set -g prompt_host_color (set_color $host_color)
end

# Tell terminal to create a mark at this location
function iterm2_preexec
  printf "\033]133;C;\r\007"
end

# iTerm2 inform terminal that command starts here
function iterm2_precmd
  printf "\033]1337;RemoteHost=%s@%s\007\033]1337;CurrentDir=$PWD\007" $USER $hostname
end

function underscore_change -v _
  if [ $ITERM2_INTEGRATION = "true" ]
    if [ x$_ = xfish ]
      iterm2_precmd
    else
      iterm2_preexec
    end
  end
end

function display_notification
  # Remove double quotes, notification does not need to be 100% accurate for me
  set command_string (string replace -a "\"" "'" $argv[1])
  osascript -e "display notification \"$command_string\" with title \"Command finished after $argv[2] seconds\""
end
