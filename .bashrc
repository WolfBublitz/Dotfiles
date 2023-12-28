alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

eval "$(oh-my-posh init bash --config ~/.oh-my-posh/theme.omp.json)"

if [ -x "$(command -v neofetch)" ]; then
  neofetch
fi
