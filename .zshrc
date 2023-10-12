alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

if test -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh; then
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if test -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

eval "$(oh-my-posh init zsh --config ~/.oh-my-posh/theme.omp.json)"
