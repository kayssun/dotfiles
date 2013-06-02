#!/bin/zsh

PACKAGES="tree imagemagick gnuplot nmap mtr git ack tmux unrar"

autoload -U colors && colors

WARNING="$fg[blue]*$reset_color"
STATUS="$fg[green]*$reset_color"
ERROR="$fg[red]*$reset_color"

# Check if Homebrew is installed
BREW=`which brew`

if [[ -n "$BREW" ]]; then
	echo "${STATUS} Found Homebrew."
else
	# Ask first
	echo -n "Install Homebrew [Y/n]? "
	read INSTALL_BREW
	echo ""

	if [[ "$INSTALL_OMZ" = "N" || "$INSTALL_OMZ" = "n" ]]; then
		echo "${WARNING} Skipping Homebrew..."
	else
		ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
	fi

fi

# Check for oh my zsh
if [[ -d $HOME/.oh-my-zsh ]]; then
	echo "${STATUS} Found oh-my-zsh"
else
	# As first
	echo -n "Install oh-my-zsh [Y/n]? "
	read INSTALL_OMZ
	echo ""

	if [[ "$INSTALL_OMZ" = "N" || "$INSTALL_OMZ" = "n" ]]; then
		echo "${WARNING} Skipping oh-my-zsh..."
	else
		echo "${STATUS} Installing oh-my-zsh..."
		curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
	fi
fi

# Check if rvm is installed
if [[ -d $HOME/.rvm ]]; then
	echo "${STATUS} Found rvm."
else
	# As first
	echo -n "Install rvm [Y/n]? "
	read INSTALL_RVM
	echo ""

	if [[ "$INSTALL_RVM" = "N" || "$INSTALL_RVM" = "n" ]]; then
		echo "${WARNING} Skipping rvm..."
	else
		echo "${STATUS} Installing rvm..."
		curl -L https://get.rvm.io | bash -s stable
	fi

fi

# Install base packages
echo -n "Install base packages via brew [Y/n]? "
read INSTALL_BASE

if [[ "$INSTALL_BASE" = "N" || "$INSTALL_BASE" = "n" ]]; then
	echo "${WARNING} Skipping base packages..."
else
	echo "${STATUS} Installing base packages..."
	/usr/local/bin/brew install $PACKAGES
fi

# Install symlinks
cd $HOME

if [[ -f $HOME/.zshrc ]]; then
	echo "${WARNING} Moving old .zshrc to .zshrc-kayssun-bkp"
	mv $HOME/.zshrc $HOME/.zshrc-kayssun-bkp
fi
if [[ -h $HOME/.zshrc ]]; then
	rm $HOME/.zshrc
fi
ln -s .dotfiles/zshrc .zshrc

if [[ -f $HOME/.vimrc ]]; then
	echo "${WARNING} Moving old .vimrc to .vimrc-kayssun-bkp"
	mv $HOME/.vimrc $HOME/.vimrc-kayssun-bkp
fi
if [[ -h $HOME/.vimrc ]]; then
	rm $HOME/.vimrc
fi
ln -s .dotfiles/vimrc .vimrc

if [[ -f $HOME/.gitconfig ]]; then
	echo "${WARNING} Moving old .gitconfig to .gitconfig-kayssun-bkp"
	mv $HOME/.gitconfig $HOME/.gitconfig-kayssun-bkp
fi
if [[ -h $HOME/.gitconfig ]]; then
	rm $HOME/.gitconfig
fi

ln -s .dotfiles/gitconfig .gitconfig

if [[ -f $HOME/.gitignore_global ]]; then
	echo "${WARNING} Moving old .gitignore_global to .gitignore_global-kayssun-bkp"
	mv $HOME/.gitignore_global $HOME/.gitignore_global-kayssun-bkp
fi
if [[ -h $HOME/.gitignore_global ]]; then
	rm $HOME/.gitignore_global
fi
ln -s .dotfiles/gitignore_global .gitignore_global

echo "${STATUS} Done."
