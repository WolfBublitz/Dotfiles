alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

eval "$(oh-my-posh init bash --config ~/.oh-my-posh/theme.omp.json)"

if [ -x "$(command -v neofetch)" ]; then
  neofetch
fi
