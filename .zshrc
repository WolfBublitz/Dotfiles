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

	if [ -x "$(command -v fastfetch)" ]; then
  		fastfetch
	fi
fi

if test -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh; then
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if test -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

fastfetch

eval "$(oh-my-posh init zsh --config ~/.oh-my-posh/theme.omp.json)"
