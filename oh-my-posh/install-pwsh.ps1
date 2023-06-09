if (!(Test-Path $PROFILE)) {
  New-Item -Path $PROFILE -Force
}

Add-Content -Path $PROFILE -Value "oh-my-posh init pwsh --config ~/theme.omp.json | Invoke-Expression"
