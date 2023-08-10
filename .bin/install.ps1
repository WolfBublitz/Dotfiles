git clone --bare https://github.com/WolfBublitz/Dotfiles.git $HOME/.dotfiles

function dotfiles {
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME @args
}

dotfiles config --local status.showUntrackedFiles no

dotfiles checkout --force
