#!/bin/bash

git clone --bare https://github.com/WolfBublitz/Dotfiles.git $HOME/.dotfiles

function dotfiles {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

dotfiles config --local status.showUntrackedFiles no

dotfiles checkout --force

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
