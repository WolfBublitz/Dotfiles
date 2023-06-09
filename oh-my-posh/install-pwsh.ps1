if (!Test-Path $PROFILE) {
  New-Item -Path $PROFILE -Force
}

Write-Host $env:OMP_DIR/oh-my-posh init pwsh --config $env:OMP_THEMES_DIR/theme.omp.json | Invoke-Expression >> $PROFILE
