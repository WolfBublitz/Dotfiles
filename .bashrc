alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

if [ -x "$(command -v lsd)" ]; then
  alias ls='lsd'
  alias l='ls -l'
  alias la='ls -a'
  alias lla='ls -la'
  alias lt='ls --tree'
fi

if ! [ -z "$PS1" ]; then

eval "$(starship init bash)"
	if [ -x "$(command -v fastfetch)" ]; then
  		fastfetch
	fi
fi

if test -f "/etc/profile.d/bash_completion.sh"; then
	source /etc/profile.d/bash_completion.sh
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/wolf/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
