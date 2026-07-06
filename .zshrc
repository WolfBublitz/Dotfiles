for f in $HOME/.config/zsh/*.zsh.sh; do
    [ -f "$f" ] && source "$f"
done
