Write-Host "Installing Oh My Posh for Powershell" -ForegroundColor Green

$profileDirPath = [System.IO.Path]::GetDirectoryName($PROFILE)

if (Test-Path $PROFILE) {
  Write-Host "-> Backing up $PROFILE to $PROFILE.bak"
  Copy-Item -Path $PROFILE -Destination "$PROFILE.bak" -Force
  Remove-Item -Path $PROFILE -Force
}
else {
  Write-Host "-> Creating directory $profileDirPath"
  $null = New-Item -Path $profileDirPath -ItemType Directory -Force
}

Write-Host "-> Creating file $PROFILE"
$null = New-Item -Path $PROFILE -ItemType File -Force

Add-Content -Path $PROFILE -Value "oh-my-posh init pwsh --config ~/.poshthemes/theme.omp.json | Invoke-Expression"

Write-Host "-> Installing PSReadLine"
Install-Module -Name PSReadLine -AllowClobber -Force;

Copy-Item -Path "$PSScriptRoot/psreadline-setup.ps1" -Destination $profileDirPath -Force

Add-Content -Path $PROFILE -Value ". `"`$PSSCRIPTROOT/PSReadlineSetup.ps1`""
Add-Content -Path $PROFILE -Value ". `"`$PSSCRIPTROOT/Shortcuts.ps1`""
