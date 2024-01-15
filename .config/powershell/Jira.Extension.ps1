Function Read-JiraSettings {
    $configDirectory = [System.IO.Path]::GetDirectoryName($PSScriptRoot)

    $jiraSettingsPath = Join-Path -Path $configDirectory -ChildPath "JiraSettings.json"

    $settings = @{
        RestUri              = ""
        SkipCertificateCheck = $false
        Token                = ""
    }

    if (Test-Path -Path $jiraSettingsPath) {
        $savedSettings = Get-Content -Path $jiraSettingsPath | ConvertFrom-Json

        foreach ($key in $savedSettings.PSObject.Properties.Name) {
            $settings[$key] = $savedSettings.$key
        }
    }

    return $settings
}

Function Write-JiraSettings {
    Param (
        [Parameter(Mandatory = $false)][string]$Token,
        [Parameter(Mandatory = $false)][string]$RestUri,
        [Parameter(Mandatory = $false)][bool]$SkipCertificateCheck = $false
    )

    $configDirectory = [System.IO.Path]::GetDirectoryName($PSScriptRoot)

    $jiraSettingsPath = Join-Path -Path $configDirectory -ChildPath "JiraSettings.json"

    if (Test-Path -Path $jiraSettingsPath) {
        $settings = Read-JiraSettings -Path $jiraSettingsPath
    }
    else {
        $settings = @{ }
    }

    if ($Token) {
        $settings.Token = $Token
    }

    if ($RestUri) {
        $settings.RestUri = $RestUri
    }

    if ($SkipCertificateCheck) {
        $settings.SkipCertificateCheck = $SkipCertificateCheck
    }

    $settings | ConvertTo-Json | Out-File -FilePath $jiraSettingsPath
}

Function Invoke-JiraGetMethod {
    param(
        [Parameter(Mandatory = $true)][string]$Method
    )

    $settings = Read-JiraSettings

    if ($settings.Token) {
        $headers = @{ Authorization = "Bearer $($settings.Token)" }
    }
    else {
        $headers = @{ }
    }

    $uri = "$($settings.RestUri)/$Method"

    $parameters = @{
        Uri                  = $uri
        Headers              = $headers
        Method               = "Get"
        SkipCertificateCheck = $settings.SkipCertificateCheck
    }

    return Invoke-RestMethod @parameters
}

Function Get-JiraIssue {
    param(
        [Parameter(Mandatory = $true)][string]$IssueKey
    )

    return Invoke-JiraGetMethod -Method "issue/$IssueKey"
}

Function Get-JiraComponents {
    param(
        [Parameter(Mandatory = $true)][string]$ProjectKey
    )

    return Invoke-JiraGetMethod -Method "project/$ProjectKey/components"
}
