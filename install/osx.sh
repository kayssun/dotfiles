#!/bin/zsh

PACKAGES=(tree imagemagick gnuplot nmap mtr git ack tmux unrar ruby fish)

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

	if [[ "$INSTALL_BREW" = "N" || "$INSTALL_BREW" = "n" ]]; then
		echo "${WARNING} Skipping Homebrew..."
	else
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

fi

# Install base packages
echo "Base packages include: ${PACKAGES}"
echo -n "Install base packages via brew [Y/n]? "
read INSTALL_BASE

if [[ "$INSTALL_BASE" = "N" || "$INSTALL_BASE" = "n" ]]; then
	echo "${WARNING} Skipping base packages..."
else
	echo "${STATUS} Installing base packages..."

	for PACKAGE in $PACKAGES; do
		/usr/local/bin/brew install $PACKAGE
	done
fi

# Install symlinks
cd $HOME

FILE="$HOME/.config/fish/config.fish"
if [[ -f $FILE ]]; then
	echo "${WARNING} Moving old config.fish to config.fish-bkp"
	mv $FILE ${FILE}-bkp
fi
if [[ -h $FILE ]]; then
	rm $FILE
fi
ln -s $HOME/.dotfiles/fish/config.fish $FILE

FILES=(vimrc gemrc pryrc gitignore_global)
for FILE in $FILES; do
	if [[ -f $HOME/.$FILE ]]; then
		echo "${WARNING} Moving old .$FILE to .${FILE}-bkp"
		mv "$HOME/.$FILE" "$HOME/.${FILE}-bkp"
	fi
	if [[ -h $HOME/.$FILE ]]; then
		rm $HOME/.$FILE
	fi
	ln -s .dotfiles/$FILE .$FILE
done

echo "${STATUS} Done."
