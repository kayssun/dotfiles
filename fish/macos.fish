if [ "$TERM_PROGRAM" = "iTerm.app" ]
  set ITERM2_INTEGRATION true
else
  set ITERM2_INTEGRATION false
end

set -g fish_user_paths "/usr/local/opt/ruby/bin" $fish_user_paths
set -gx LDFLAGS "-L/usr/local/opt/ruby/lib"
set -gx CPPFLAGS "-I/usr/local/opt/ruby/include"
set -gx PKG_CONFIG_PATH "/usr/local/opt/ruby/lib/pkgconfig"
