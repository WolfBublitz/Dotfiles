$hostname = (Get-Host).Name

if ($hostname -eq 'ConsoleHost' -or $hostname -eq 'Visual Studio Code Host' ) {
  # ┌──────────────────────────────────────────────────────────────────────┐
  # │ System Info                                                          │
  # └──────────────────────────────────────────────────────────────────────┘

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
