for file in "$HOME/.EnvManager/bash/"*; do
    [ -f "$file" ] && source "$file"
done
