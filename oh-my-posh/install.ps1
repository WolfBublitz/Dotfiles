param(
    [string]$Path
)

Write-Host "Installing Oh My Posh" -ForegroundColor Green

if ($IsWindows) {
    throw "Windows is currently not supported!"
}

Write-Host "-> Installation path $Path"

# installing oh my posh
sudo curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $Path

# copying theme
function GetDirPath() {
    if ($IsLinux) {
        return [System.IO.Path]::Combine($env:HOME, ".poshthemes")
    }
    elseif ($IsMacOS) {
        return [System.IO.Path]::Combine($env:HOME, ".poshthemes")
    }
    elseif ($IsWindows) {
        return [System.IO.Path]::Combine($env:APPDATA, ".poshthemes")
    }
}

$dirPath = GetDirPath
if (!(Test-Path $dirPath)) {
    Write-Host "-> Creating $dirPath"
    $null = New-Item -Path $dirPath -ItemType Directory
}

Write-Host "-> copying theme"
$sourceFile = [System.IO.Path]::Combine($PSScriptRoot, "theme.omp.json")
$destinationFile = [System.IO.Path]::Combine($dirPath, "theme.omp.json")
Copy-Item $sourceFile -Destination $destinationFile -Force

# installing fonts
Write-Host "-> installing font FiraCode"
oh-my-posh font install FiraCode
