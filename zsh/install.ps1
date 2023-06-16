Write-Host "Installing Oh My Posh for ZSH" -ForegroundColor Green

$dirPath = $env:HOME
$filePath = [System.IO.Path]::Combine($dirPath, ".zshrc")
$backupFilePath = [System.IO.Path]::Combine($dirPath, ".zshrc.bak")

if (Test-Path $filePath) {
    Write-Host "-> Backing up $(New-Text $filePath -fg "Yellow") to $(New-Text $backupFilePath -fg "Yellow")"
    Copy-Item -Path $filePath -Destination $backupFilePath -Force
    Remove-Item -Path $filePath -Force
}

Write-Host "-> Creating $filePath"
$null = New-Item -Path $filePath -ItemType File

$themeFilePath = [System.IO.Path]::Combine($env:HOME, ".poshthemes", "theme.omp.json")

Write-Host "-> Enabling Oh My Posh"
Add-Content -Path $filePath -Value "eval `"`$(oh-my-posh init zsh --config $themeFilePath)`""
