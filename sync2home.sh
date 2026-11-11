#!/bin/sh
cp -R ~/git/dotfiles/home/.zsh ~
cp ~/git/dotfiles/home/.zshrc ~/.zshrc
cp -R  ~/git/dotfiles/home/.vim ~
cp ~/git/dotfiles/home/.vimrc ~/.vimrc
mkdir -p ~/.config && cp -R ~/git/dotfiles/home/.config/nvim ~/.config/
if [ ! -f "~/.zsh/secret.zsh" ]; then
  touch ~/.zsh/secret.zsh
fi

