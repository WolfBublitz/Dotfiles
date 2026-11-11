for file in "$HOME/.EnvManager/bash/"*.sh; do
    [ -f "$file" ] && source "$file"
done
