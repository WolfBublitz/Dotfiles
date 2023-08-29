$hostname = (Get-Host).Name

if ($hostname -eq 'ConsoleHost' -or $hostname -eq 'Visual Studio Code Host' ) {
  oh-my-posh init pwsh --config ~/.oh-my-posh/theme.omp.json | Invoke-Expression
}

function dotfiles {
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME @args
}

. $PSSCRIPTROOT/Aliases.ps1
. $PSSCRIPTROOT/Functions.ps1
. $PSSCRIPTROOT/PSReadLine.ps1
. $PSSCRIPTROOT/Shortcuts.ps1
