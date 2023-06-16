Install-Module Pansies -AllowClobber -Force

Push-Location oh-my-posh
./install.ps1
Pop-Location

if (Get-Command bash -ErrorAction SilentlyContinue) {
    Push-Location bash
    ./install.ps1
    Pop-Location
}

if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    Push-Location pwsh
    ./install.ps1
    Pop-Location
}

if (Get-Command zsh -ErrorAction SilentlyContinue) {
    Push-Location zsh
    ./install.ps1
    Pop-Location
}
