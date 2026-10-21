export PATH="$HOME/.bin:$PATH"

if [ -x "$(command -v lsd)" ]; then
  alias ls='lsd'
  alias l='ls -l'
  alias la='ls -a'
  alias lla='ls -la'
  alias lt='ls --tree'
fi

if test -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh; then
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if test -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ -x "$(command -v fastfetch)" ]; then
  fastfetch
fi

alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

eval "$(oh-my-posh init zsh --config ~/.oh-my-posh/theme.omp.json)"
