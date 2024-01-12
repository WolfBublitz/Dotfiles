$hostname = (Get-Host).Name

if ($hostname -eq 'ConsoleHost' -or $hostname -eq 'Visual Studio Code Host' ) {

  # ┌──────────────────────────────────────────────────────────────────────┐
  # │ Commandlets                                                          │
  # └──────────────────────────────────────────────────────────────────────┘
  Function Test-CommandExists {
    Param ($command)

    $oldPreference = $ErrorActionPreference

    $ErrorActionPreference = ‘stop’

    try {
      if (Get-Command $command) { RETURN $true }
    }
    Finally {
      $ErrorActionPreference = $oldPreference
    }
  }

  # ┌──────────────────────────────────────────────────────────────────────┐
  # │ Shortcuts                                                            │
  # └──────────────────────────────────────────────────────────────────────┘

  # shortcut: dotfiles
  # git command for dotfiles
  Function dotfiles {
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME @args
  }

  # shortcut: l
  # lists files and directories
  if (Test-CommandExists lsd) {
    # use lsd if available
    Set-Alias -Name l -Value lsd
  }
  else {
    # ls otherwise
    Set-Alias -Name l -Value ls
  }

  # shortcut: o
  # opens current directory in explorer
  function o {
    Invoke-Item .
  }

  function Reload-Profile {
    & $profile
  }

  # shortcut: Get-Weather
  # shows the weather
  function Get-Weather {
    Invoke-RestMethod -Uri "de.wttr.in"
  }

  # shortcuts for going to parent directories
  function cd.. { Set-Location -Path .. }
  function cd... { Set-Location -Path ..\.. }
  function cd.... { Set-Location -Path ..\..\.. }
  function cd..... { Set-Location -Path ..\..\..\.. }

  # shortcut: Show-Files
  # shows a (filtered) list of files in the current directory
  function Show-Files {
    if ($args.Count -gt 0) {
      Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    }
    else {
      Get-ChildItem -Recurse | Foreach-Object FullName
    }
  }

  # creates a zip file from a file or folder
  function Compress-Zip {
    param(
      [Parameter(Mandatory = $true)][string]$Path,
      [Parameter(Mandatory = $false)][string]$DestinationPath = $null,
      [Parameter(Mandatory = $false)][string]$CompressionLevel = "Fastest")

    if ($DestinationPath -eq $null) {
      $DestinationPath = "$($Path).zip"
    }

    $compress = @{
      Path             = $Path
      CompressionLevel = $CompressionLevel
      DestinationPath  = $DestinationPath
    }

    Compress-Archive @compress
  }

  # expands a zip file to a folder
  function Expand-Zip {
    param(
      [Parameter(Mandatory = $true)][string]$Path,
      [Parameter(Mandatory = $false)][string]$DestinationPath = $null)

    if ([System.String]::IsNullOrEmpty($DestinationPath)) {
      $fileName = [System.IO.Path]::GetFileNameWithoutExtension($Path)
      $filePath = [System.IO.Path]::GetDirectoryName($Path)

      $DestinationPath = Join-Path  -Path $filePath -ChildPath $fileName
    }

    $expand = @{
      Path            = $Path
      DestinationPath = $DestinationPath
    }

    Expand-Archive @expand
  }

  # ┌──────────────────────────────────────────────────────────────────────┐
  # │ PSReadLine                                                           │
  # └──────────────────────────────────────────────────────────────────────┘

  Import-Module PSReadLine

  Import-Module CompletionPredictor

  Set-PSReadLineOption -PredictionSource HistoryAndPlugin
  Set-PSReadLineOption -PredictionViewStyle ListView
  Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
  Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
  Set-PSReadLineOption -HistorySearchCursorMovesToEnd

  Set-PSReadLineKeyHandler -Key Alt+d -Function ShellKillWord
  Set-PSReadLineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord
  Set-PSReadLineKeyHandler -Key Alt+LeftArrow -Function ShellBackwardWord
  Set-PSReadLineKeyHandler -Key Alt+RightArrow -Function ShellForwardWord

  Set-PSReadlineOption -Colors @{
    "Command"                = $PSStyle.Bold + $PSStyle.Foreground.FromRgb(0x0595f5)
    "Comment"                = $PSStyle.Foreground.White
    "ContinuationPrompt"     = '#7FFFD4'
    "Default"                = '#50C878'
    "Emphasis"               = $PSStyle.Bold + $PSStyle.Foreground.White
    "Error"                  = '#7DF9FF'
    "InlinePrediction"       = '#00A36C'
    "Keyword"                = '#32CD32'
    "ListPrediction"         = $PSStyle.Foreground.Green
    "ListPredictionSelected" = $PSStyle.Background.Blue
    "Member"                 = '#40E0D0'
    "Number"                 = $PSStyle.Foreground.FromRgb(0x0595f5)
    "Operator"               = $PSStyle.Foreground.White
    "Parameter"              = $PSStyle.Foreground.BrightWhite
    "Selection"              = $PSStyle.Foreground.White
    "String"                 = $PSStyle.Foreground.BrightYellow
    "Type"                   = '#C1E1C1'
    "Variable"               = $PSStyle.Foreground.Green
  }

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

  # ┌──────────────────────────────────────────────────────────────────────┐
  # │ Prompt                                                               │
  # └──────────────────────────────────────────────────────────────────────┘

  oh-my-posh init pwsh --config ~/.oh-my-posh/theme.omp.json | Invoke-Expression
}

Remove-Variable hostname
