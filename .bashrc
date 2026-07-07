export PATH="$HOME/.bin:$PATH"

for f in $HOME/.config/bash/*.profile.sh; do
    [ -f "$f" ] && source "$f"
done
