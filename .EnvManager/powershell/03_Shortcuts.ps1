$hostname = (Get-Host).Name

if ($hostname -eq 'ConsoleHost' -or $hostname -eq 'Visual Studio Code Host' ) {
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
}