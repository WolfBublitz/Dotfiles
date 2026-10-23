using namespace System

Function Test-ContainsChangelog {
    Param (
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Version,
        [Parameter(Mandatory = $false)][DateTime]$Date = (Get-Date)
    )
    
    $content = Get-Content -Path $Path
    
    foreach ($row in $content) {
        if ($row -match "## (?'Version'([0-9]+)\.([0-9]+)\.([0-9]+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+[0-9A-Za-z-]+)?) \((?'Date'\d\d\d\d-\d\d-\d\d)\)") {
            if (($Matches["Version"] -eq $Version) -and ($Matches["Date"] -eq $Date.ToString("yyyy-MM-dd"))) {
                return $true
            }
        }
    }

    return $false
}

Function Get-Changelogs {
    param(
        [Parameter(Mandatory = $true)][string]$Path
    )

    $content = Get-Content -Path $Path

    $changelogs = @()

    for ($i = 0; $i -lt $content.Length; $i++) {
        $row = $content[$i]

        if ($row -match "## (?'Version'([0-9]+)\.([0-9]+)\.([0-9]+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+[0-9A-Za-z-]+)?) \((?'Date'\d\d\d\d-\d\d-\d\d)\)") {
            [string[]]$changelogRows = @()
            $changelogRows += $row

            for ($j = $i + 1; $j -lt $content.Length; $j++) {
                $subRow = $content[$j]

                if ($subRow.StartsWith("## ")) {
                    break
                }
                else {
                    $changelogRows += $subRow
                }
            }

            $changelog = @{
                Date     = [DateTime]::Parse($Matches["Date"])
                FullText = $changelogRows -join [Environment]::NewLine
                Text     = ($changelogRows | Select-Object -Skip 1) -join [Environment]::NewLine
                Version  = $Matches["Version"]
            }

            $changelogs += $changelog

            $i = $j - 1
        }
    }

    return $changelogs
}