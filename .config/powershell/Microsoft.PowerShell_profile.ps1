$hostname = (Get-Host).Name

if ($hostname -eq 'ConsoleHost' -or $hostname -eq 'Visual Studio Code Host' ) {

  $OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

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

  Function Add-Module {
    param(
      [Parameter(Mandatory = $true)][string]$Name
    )
    # check if module is imported
    if (Get-Module | Where-Object { $_.Name -eq $Name }) {
      return
    }
    else {

      # check if module is not imported, but available on disk then import
      if (Get-Module -ListAvailable | Where-Object { $_.Name -eq $Name }) {
        Import-Module $Name
      }
      else {

        # If module is not imported, not available on disk, but is in online gallery then install and import
        if (Find-Module -Name $Name | Where-Object { $_.Name -eq $Name }) {
          Install-Module -Name $Name -Force -Scope CurrentUser
          Import-Module $Name
        }
        else {

          # If the module is not imported, not available and not in the online gallery then abort
          throw "Module $Name not imported, not available and not in an online gallery."
        }
      }
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
  # │ Extensions                                                           │
  # └──────────────────────────────────────────────────────────────────────┘

  foreach ($file in Get-ChildItem -Path $PSScriptRoot) {
    if ($file.Name.EndsWith(".Extension.ps1")) {
      . $file.FullName
    }
  }

  Function New-Extension {
    Param (
      [Parameter(Mandatory = $true)][string]$Name
    )

    $extensionPath = Join-Path -Path $PSScriptRoot -ChildPath "$Name.Extension.ps1"

    if (Test-Path -Path $extensionPath) {
      Write-Host "Extension $Name already exists" -ForegroundColor Red
    }
    else {
      New-Item -Path $extensionPath -ItemType File

      Invoke-Item $extensionPath
    }
  }

  Function Edit-Extension {
    Param (
      [Parameter(Mandatory = $true)][string]$Name
    )

    $extensionPath = Join-Path -Path $PSScriptRoot -ChildPath "$Name.Extension.ps1"

    if (Test-Path -Path $extensionPath) {
      Invoke-Item $extensionPath
    }
    else {
      Write-Host "Extension $Name does not exist" -ForegroundColor Red
    }
  }

  # ┌──────────────────────────────────────────────────────────────────────┐
  # │ Prompt                                                               │
  # └──────────────────────────────────────────────────────────────────────┘
  oh-my-posh init pwsh --config ~/.oh-my-posh/theme.omp.json | Invoke-Expression
}

Remove-Variable hostname
