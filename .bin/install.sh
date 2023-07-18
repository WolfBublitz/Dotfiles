#!/bin/bash

git clone --bare https://github.com/WolfBublitz/Dotfiles.git $HOME/.dotfiles

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

dotfiles config --local status.showUntrackedFiles no

dotfiles checkout --force
