$hostname = (Get-Host).Name

if ($hostname -eq 'ConsoleHost' -or $hostname -eq 'Visual Studio Code Host' ) {

  $OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

  # ┌──────────────────────────────────────────────────────────────────────┐
  # │ PATH                                                                 │
  # └──────────────────────────────────────────────────────────────────────┘

  $env:PATH = $env:PATH + ":$HOME/.bin"
  $env:PATH = $env:PATH + ":$HOME/.local/share/powershell/Scripts"

  if ($IsMacOS) {
    $env:PATH = $env:PATH + ":/opt/homebrew/bin"
  }

  # ┌──────────────────────────────────────────────────────────────────────┐
  # │ Commandlets                                                          │
  # └──────────────────────────────────────────────────────────────────────┘
  Function Test-CommandExists {
    param(
      [Parameter(Mandatory = $true)][string]$Name
    )

    $oldErrorActionPreference = $ErrorActionPreference

    $ErrorActionPreference = "stop"

    try {
      if (Get-Command -Name $Name) { return $true }
    }
    catch {
      return $false
    }
    finally {
      $ErrorActionPreference = $oldErrorActionPreference
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

  # shortcut: l
  # lists files and directories
  if (Test-CommandExists lsd) {
    # use lsd if available
    Set-Alias -Name ls -Value lsd

    function l_ { lsd -l }
    function la_ { lsd -a }
    function lla_ { lsd -la }
    function lt_ { lsd --tree }

    Set-Alias -Name l -Value l_
    Set-Alias -Name la -Value la_
    Set-Alias -Name lla -Value lla_
    Set-Alias -Name lt -Value lt_
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

  function Update-Profile {
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

  # ┌──────────────────────────────────────────────────────────────────────┐
  # │ Loading Extensions                                                   │
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
  # │ System Info                                                          │
  # └──────────────────────────────────────────────────────────────────────┘
  if (!(Test-CommandExists "fastfetch")) {
    if ($IsMacOS) {
      brew install fastfetch
    }
    elseif ($IsLinux) {

    }
    elseif ($IsWindows) {
      scoop install fastfetch
    }
  }

  fastfetch

  # ┌──────────────────────────────────────────────────────────────────────┐
  # │ Prompt                                                               │
  # └──────────────────────────────────────────────────────────────────────┘

  if (!(Test-CommandExists "oh-my-posh")) {
    Install-OhMyPosh
  }

  oh-my-posh init pwsh --config ~/.oh-my-posh/theme.omp.json | Invoke-Expression
}

Remove-Variable hostname
