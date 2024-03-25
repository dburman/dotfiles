#!/bin/sh
cp -R ~/.zsh ~/git/dotfiles/home
cp  ~/.zshrc ~/git/dotfiles/home
cp -R ~/.vim ~/git/dotfiles/home
cp  ~/.vimrc ~/git/dotfiles/home
cp -R ~/.config/nvim ~/git/dotfiles/home/.config/
rm -Rf ~/git/dotfiles/home/.config/nvim/autoload/plugged

