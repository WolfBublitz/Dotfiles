#!/bin/bash

git clone --bare https://github.com/WolfBublitz/Dotfiles.git $HOME/.dotfiles

function dotfiles {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

dotfiles config --local status.showUntrackedFiles no

dotfiles checkout --force

if [ -x "$(command -v zsh)" ]; then
   git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
   git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.zsh/zsh-autocomplete
fi

if [ -x "$(command -v apt-get)" ]; then
   sudo -- sh -c 'apt-get update; apt-get install -y neofetch htop vim'
fi
