using namespace System.IO

param(
  [string]$Path
)

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

$ohMyPosh = @"
`$hostname = (Get-Host).Name
if (`$hostname -eq 'ConsoleHost' -or `$hostname -eq 'Visual Studio Code Host' ) {
  oh-my-posh init pwsh --config ~/.poshthemes/theme.omp.json | Invoke-Expression
}
"@

Add-Content -Path $PROFILE -Value $ohMyPosh

Write-Host "-> Installing PSReadline"
Install-Module -Name PSReadLine -AllowClobber -Force;

$files = @(
  "Functions.ps1",
  "PSReadlineSetup.ps1",
  "Shortcuts.ps1"
)

foreach ($file in $files) {
  $sourceFilePath = [Path]::Combine($PSScriptRoot, $file)

  Write-Host "-> Copying $sourceFilePath to $profileDirPath"
  Copy-Item -Path "$PSScriptRoot/$file" -Destination $profileDirPath -Force
  Add-Content -Path $PROFILE -Value ". `"`$PSSCRIPTROOT/$file`""
}
