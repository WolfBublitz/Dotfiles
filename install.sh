git clone --bare https://github.com/WolfBublitz/Dotfiles.git $HOME/.dotfiles

alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg/.git --work-tree=$HOME'

dotfiles config --local status.showUntrackedFiles no

dotfiles checkout git-bare-test