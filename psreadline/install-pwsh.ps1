Install-Module -Name PSReadLine -AllowClobber -Force;

$profileDirPath = [System.IO.Path]::GetDirectoryName($PROFILE)

if (!(Test-Item -Path $PROFILE)) {
    New-Item -Path $PROFILE -ItemType File
}

Copy-Item -Path "$PSScriptRoot/psreadline-setup.ps1" -Destination $profileDirPath -Force

Add-Content -Path $PROFILE -Value ". psreadline-setup.ps1"
