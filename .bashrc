for f in $HOME/.config/bash/*.bash.sh; do
    [ -f "$f" ] && source "$f"
done
