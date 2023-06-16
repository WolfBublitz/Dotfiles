using namespace System;
using namespace System.IO;
using namespace System.Globalization;

if ($host.Name -eq 'ConsoleHost' -or $host.Name -eq 'Visual Studio Code Host' ) {
    function Update-Dotfiles {
        Write-Host "Updating Dotfiles" -ForegroundColor Green

        $tempDirPath = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())

        Write-Host "-> Cloning Repository to $tempDirPath"
        $null = New-Item -ItemType Directory -Path $tempDirPath

        Push-Location $tempDirPath
        $null = git clone https://github.com/WolfBublitz/Dotfiles.git

        Push-Location Dotfiles

        $repositoryDateTime = [DateTime]::Parse($(git log -1 --format="%ai"))

        Write-Host "-> Repository version: $($repositoryDateTime.ToString($timestampFormat))"

        $timestampFormat = "yyyy-MM-dd HH-mm-ss"

        $timestampFile = [Path]::Combine([FileInfo]::new($Profile).DirectoryName, "Update.json");

        if ([File]::Exists($timestampFile)) {
            $update = $([File]::ReadAllText($timestampFile) | ConvertFrom-Json)

            $lastUpdate = [DateTime]::ParseExact($update.LastUpdate, $timestampFormat, [CultureInfo]::InvariantCulture)

            Write-Host "-> Local version: $($lastUpdate.ToString($timestampFormat))"
        }
        else {
            $lastUpdate = $null

            Write-Host "-> Local version: not found"
        }

        if (($null -eq $lastUpdate) -or ($lastUpdate -lt $repositoryDateTime)) {
            $scriptFilePath = [Path]::Combine($tempDirPath, "Dotfiles", "install.ps1")

            if ($IsLinux -or $IsMacOS) {
                sudo pwsh -C $scriptFilePath
            }
            else {
                pwsh -C  $scriptFilePath
            }

            [File]::WriteAllText($timestampFile, $(@{ "LastUpdate" = $repositoryDateTime.ToString($timestampFormat) } | ConvertTo-Json))
        }
        else {
            Write-Host "Everything is up to date!"
        }
    }
}
