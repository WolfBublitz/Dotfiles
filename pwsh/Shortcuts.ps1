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