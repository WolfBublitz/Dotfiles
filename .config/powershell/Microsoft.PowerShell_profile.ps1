$path = "$HOME/.EnvManager/powershell"

if (Test-Path $path) {
    Get-ChildItem $path -Filter *.ps1 -File | ForEach-Object { . $_.FullName }
}
