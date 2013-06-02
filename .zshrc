# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew sublime osx)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
unsetopt correct_all

PROMPT=$'%{\e[1;32m%}%n@%m %{\e[1;34m%}%0(3c,%c,%~) %0(?,%{\e[0;32m%}:%),%{\e[0;31m%}:(%s)%{\e[1;34m%} %#%b '
export PATH=/usr/local/sbin:$PATH:~/.bin
export EDITOR=vim
alias latex="latex -interaction=nonstopmode"
alias su='sudo -i zsh'

# RVM
[[ -s "/Users/ksun/.rvm/scripts/rvm" ]] && source "/Users/ksun/.rvm/scripts/rvm"  # This loads RVM into a shell session.
PATH=/usr/local/opt/php54/bin:$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Report CPU usage for commands running longer than 10 seconds
REPORTTIME=10
