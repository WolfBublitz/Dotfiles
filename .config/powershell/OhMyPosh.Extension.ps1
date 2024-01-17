Add-Module PwshSpectreConsole 

Function Install-OhMyPosh {
    if ($IsWindows) {
        Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
    }
    elseif ($IsMacOS) {
        brew install oh-my-posh
    }
}

Function Update-OhMyPosh {
    Write-SpectreHost "Updating [blue]Oh My Posh[/]"
    if ($IsWindows) {
        Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
    }
    elseif ($IsMacOS) {
        brew upgrade oh-my-posh
    }
    elseif ($IsLinux) {
        curl -s https://ohmyposh.dev/install.sh | sudo bash -s
    }

    Write-SpectreHost "[green][[SUCC]][/] updated [blue]Oh My Posh[/]"
}