Write-Host "Installing Oh My Posh for Powershell"

if (Test-Path $PROFILE) {
  Write-Host "-> Backing up $PROFILE to $PROFILE.bak"
  Copy-Item -Path $PROFILE -Destination "$PROFILE.bak" -Force
  Remove-Item -Path $PROFILE -Force
}

$null = New-Item -Path $PROFILE -ItemType File

Add-Content -Path $PROFILE -Value "oh-my-posh init pwsh --config ~/.poshthemes/theme.omp.json | Invoke-Expression"

Write-Host "-> Installing PSReadLine"
Install-Module -Name PSReadLine -AllowClobber -Force;

$profileDirPath = [System.IO.Path]::GetDirectoryName($PROFILE)
Copy-Item -Path "$PSScriptRoot/psreadline-setup.ps1" -Destination $profileDirPath -Force

Add-Content -Path $PROFILE -Value ". `"`$PSSCRIPTROOT/psreadline-setup.ps1`""
