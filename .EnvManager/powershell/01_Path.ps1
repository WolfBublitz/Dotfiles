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
}

Remove-Variable hostname
