#!/bin/bash

cd $HOME

FILES=(vimrc gemrc pryrc gitignore_global rspec)
for FILE in ${FILES[@]}; do
  # Delete existing symlink
	if [ -h $HOME/.$FILE ]; then
		rm $HOME/.$FILE
	fi

  # Backup existing file
	if [ -f $HOME/.$FILE ]; then
		echo "${WARNING} Moving old .$FILE to .${FILE}-bkp"
		mv "$HOME/.$FILE" "$HOME/.${FILE}-bkp"
	fi

  # Create new symlink (duh)
	ln -s .dotfiles/$FILE .$FILE
done

# And now for the fish
FILE="$HOME/.config/fish/config.fish"
DIR=`dirname $FILE`
mkdir -p $DIR
mkdir -p "$HOME/.bin"

# Delete existing link
if [[ -h $FILE ]]; then
	rm $FILE
fi

# Backup existing config if any
if [[ -f $FILE ]]; then
	echo "${WARNING} Moving old config.fish to config.fish-bkp"
	mv $FILE ${FILE}-bkp
fi

# Symlink new
ln -s $HOME/.dotfiles/fish/config.fish $FILE
