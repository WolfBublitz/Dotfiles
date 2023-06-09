$hostname = $(Get-Host).Name

if ($hostname -eq 'ConsoleHost' -or $hostname -eq 'Visual Studio Code Host' ) {
    Set-PSReadLineKeyHandler -Key Alt+Shift+B `
        -BriefDescription BuildDotnetProject `
        -LongDescription "Build the dotnet project in the current directory" `
        -ScriptBlock {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("dotnet build")
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }

    Set-PSReadLineKeyHandler -Key Alt+Shift+T `
        -BriefDescription RunDotnetTests `
        -LongDescription "Run the dotnet tests in the current directory" `
        -ScriptBlock {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("dotnet test")
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }

    Set-PSReadLineKeyHandler -Key Alt+Shift+P `
        -BriefDescription RunDotnetTests `
        -LongDescription "Run the dotnet tests in the current directory" `
        -ScriptBlock {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("git pull")
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}
