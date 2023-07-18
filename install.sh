git clone --bare https://github.com/WolfBublitz/Dotfiles.git $HOME/.dotfiles

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

dotfiles checkout git-bare-test

dotfiles config --local status.showUntrackedFiles no

