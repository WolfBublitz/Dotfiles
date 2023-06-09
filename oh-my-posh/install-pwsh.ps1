if (!(Test-Path $PROFILE)) {
  New-Item -Path $PROFILE -Force
}

Write-Host oh-my-posh init pwsh --config ~/theme.omp.json | Invoke-Expression >> $PROFILE
