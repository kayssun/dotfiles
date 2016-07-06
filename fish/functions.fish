function _is_staging_server
  /sbin/ifconfig | grep "2a01:4f8:191:13b4:" > /dev/null
end

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _short_pwd
  echo $PWD | sed -e "s|^$HOME|~|"
end

# Mark start of prompt for iTerm
function iterm2_prompt_start
  printf "\033]133;A\007"
end

# Mark end of prompt for iTerm
function iterm2_prompt_end
  printf "\033]133;B\007"
end

# Output the last status to iTerm
function iterm2_status
  printf "\033]133;D;%s\007" $argv
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

# Tell terminal to create a mark at this location
function iterm2_preexec
  printf "\033]133;C;\r\007"
end

# iTerm2 inform terminal that command starts here
function iterm2_precmd
  printf "\033]1337;RemoteHost=%s@%s\007\033]1337;CurrentDir=$PWD\007" $USER $hostname
end

function -v _ underscore_change
  if [ x$_ = xfish ]
    iterm2_precmd
  else
    iterm2_preexec
  end
end

  # Allow setting of custom variables for iTerm
function iterm2_set_user_var
  printf "\033]1337;SetUserVar=%s=%s\007" "$argv[1]" (printf "%s" "$argv[2]" | base64)
end

function display_notification
  osascript -e "display notification \"$argv[1]\" with title \"Command finished after $argv[2] seconds\""
end