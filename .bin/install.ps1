git clone --bare https://github.com/WolfBublitz/Dotfiles.git $HOME/.dotfiles

function dotfiles {
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME @args
}

dotfiles config --local status.showUntrackedFiles no

dotfiles checkout --force

if ($IsWindows) {

    # backing up current $PROFILE if exists
    if (Test-Path -Path $Profile -PathType Leaf) {
        Move-Item -Path $Profile -Destination $PROFILE.$(get-date -f yyyyMMdd)
    }

    # referencing our $PROFILE 
    echo ". $HOME/.config/powershell/Microsoft.PowerShell_profile.ps1" >> $PROFILE
}
