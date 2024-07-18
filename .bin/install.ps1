git clone --bare https://github.com/WolfBublitz/Dotfiles.git $HOME/.dotfiles

function dotfiles {
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME @args
}

function Test-CommandExists {
    Param ($command)
     
    $oldPreference = $ErrorActionPreference

    $ErrorActionPreference = ‘stop’

    try {
         if(Get-Command $command) {
             return $true
         }
    } catch {
        return $false
    }

    finally {
        $ErrorActionPreference=$oldPreference
    }
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

if (!(Test-CommandExists oh-my-posh)) {
    if ($IsLinux) {
        curl -s https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin
    }
}
