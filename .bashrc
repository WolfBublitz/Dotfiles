alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

if [ -x "$(command -v lsd)" ]; then
  alias ls='lsd'
  alias l='ls -l'
  alias la='ls -a'
  alias lla='ls -la'
  alias lt='ls --tree'
fi

if ! [ -z "$PS1" ]; then

	eval "$(oh-my-posh init bash --config ~/.oh-my-posh/theme.omp.json)"

	if [ -x "$(command -v neofetch)" ]; then
  		neofetch
	fi
fi

if test -f "/etc/profile.d/bash_completion.sh"; then
	source /etc/profile.d/bash_completion.sh
fi
