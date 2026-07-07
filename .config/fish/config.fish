set -gx PATH $HOME/.bin $PATH

for f in $HOME/.config/fish/*.profile.fish
    if test -s $f
        echo "Loading profile: $f"
        source $f
    else
        echo "Skipping empty profile: $f"
    end
end