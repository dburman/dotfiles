#!/bin/sh
cp -R ~/.zsh ~/git/dotfiles/home
cp  ~/.zshrc ~/git/dotfiles/home
cp -R ~/.vim ~/git/dotfiles/home
cp  ~/.vimrc ~/git/dotfiles/home
cp -R ~/.config/nvim ~/git/dotfiles/home/.config/

# Plugin clones and compiled zsh files are machine-local, not config. Their files
# are read-only (git objects, .zwc), so carrying them into the repo made
# sync2home.sh spew hundreds of "Permission denied" errors copying them back.
rm -Rf ~/git/dotfiles/home/.vim/plugged
rm -f ~/git/dotfiles/home/.zsh/*.zwc
