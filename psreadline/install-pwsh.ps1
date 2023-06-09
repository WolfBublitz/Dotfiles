Install-Module -Name PSReadLine -AllowClobber -Force;

$filePath = $PSScriptRoot/psreadline-setup.ps1

Add-Content -Path $PROFILE -Value ". $(filePath)"
