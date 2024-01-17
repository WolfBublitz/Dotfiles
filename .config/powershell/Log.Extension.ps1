Add-Module PwshSpectreConsole 

Function Write-Info {
    param(
        [Parameter(Mandatory = $true)][string]$Message
    )

    Write-SpectreHost "[[[blue]INFO[/]]] $Message"
}

Function Write-Success {
    param(
        [Parameter(Mandatory = $true)][string]$Message
    )

    Write-SpectreHost "[[[green]SUCC[/]]] $Message"
}

Function Write-Failure {
    param(
        [Parameter(Mandatory = $true)][string]$Message
    )

    Write-SpectreHost "[[[red]FAIL[/]]] $Message"
}

Function Write-Error {
    param(
        [Parameter(Mandatory = $true)][string]$Message
    )

    Write-SpectreHost "[[[default on red]ERRO[/]]] $Message"
}