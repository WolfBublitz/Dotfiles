# Add-Module PwshSpectreConsole 

Function Install-OhMyPosh {
    Write-Info "Installing [blue]Oh My Posh[/]"

    if ($IsWindows) {
        Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
    }
    elseif ($IsMacOS) {
        brew install oh-my-posh
    }

    Write-Success "[green][[SUCC]][/] Installed [blue]Oh My Posh[/]"
}

Function Update-OhMyPosh {
    Write-Info "Updating [blue]Oh My Posh[/]"

    if ($IsWindows) {
        Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
    }
    elseif ($IsMacOS) {
        brew upgrade oh-my-posh
    }
    elseif ($IsLinux) {
        curl -s https://ohmyposh.dev/install.sh | sudo bash -s
    }

    Write-Success "[green][[SUCC]][/] Updated [blue]Oh My Posh[/]"
}