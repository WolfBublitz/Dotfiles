# Import-Module PwshSpectreConsole 

<#
    .SYNOPSIS
        Writes an info message to the console.

    .DESCRIPTION
        Write an info message to the console.

    .PARAMETER Message
        The message to write.
#>
Function Write-Info {
    param(
        [Parameter(Mandatory = $true)][string]$Message
    )

    Write-SpectreHost "[[[blue]INFO[/]]] $Message"
}

<#
    .SYNOPSIS
        Writes a success message to the console.

    .DESCRIPTION
        Write a success info message to the console.

    .PARAMETER Message
        The message to write.
#>
Function Write-Success {
    param(
        [Parameter(Mandatory = $true)][string]$Message
    )

    Write-SpectreHost "[[[green]SUCC[/]]] $Message"
}

<#
    .SYNOPSIS
        Writes a failure message to the console.

    .DESCRIPTION
        Write a failure info message to the console.

    .PARAMETER Message
        The message to write.
#>
Function Write-Failure {
    param(
        [Parameter(Mandatory = $true)][string]$Message
    )

    Write-SpectreHost "[[[red]FAIL[/]]] $Message"
}

<#
    .SYNOPSIS
        Writes a error message to the console.

    .DESCRIPTION
        Write a error info message to the console.

    .PARAMETER Message
        The message to write.
#>
Function Write-Error {
    param(
        [Parameter(Mandatory = $true)][string]$Message
    )

    Write-SpectreHost "[[[default on red]ERRO[/]]] $Message"
}