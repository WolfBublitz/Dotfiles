alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

export PATH="$HOME/.bin:$PATH"

if [ -x "$(command -v lsd)" ]; then
  alias ls='lsd'
  alias l='ls -l'
  alias la='ls -a'
  alias lla='ls -la'
  alias lt='ls --tree'
fi

if test -f "/etc/profile.d/bash_completion.sh"; then
	source /etc/profile.d/bash_completion.sh
fi

eval "$(oh-my-posh init bash --config $HOME/.oh-my-posh/theme.omp.json)"
