Write-Host "Creating Visual Studio Code configuration"

function GetPath() {
    if ($IsLinux) {
        return "$env:HOME/.config/Code/User"
    } elseif ($IsMacOS) {
        return "$env:HOME/Library/Application\ Support/Code/User/"
    } elseif ($IsWindows) {
        return "$env:APPDATA/Code/User"
    }
}

$dirPath = GetPath

if ((!Test-Path $dirPath)) {
    Write-Host "-> Creating $dirPath"
    New-Item -Path $dirPath -ItemType Directory
}

$filePath = [System.IO.Path]::Combine($dirPath, "settings.json")

if (Test-Path $filePath) {
    Write-Host "-> Backing up filePath to $dirPath/settings.json.bak"
    Copy-Item -Path "$path/settings.json" -Destination "$dirPath/settings.json.bak" -Force
}

Write-Host "-> Copying settings.json to $filePath"
Copy-Item -Path "$PSSCRIPTROOT/settings.json" -Destination $filePath -Force
