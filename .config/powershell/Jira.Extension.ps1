# ┌──────────────────────────────────────────────────────────────────────┐
# │ Settings                                                             │
# └──────────────────────────────────────────────────────────────────────┘

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

# ┌──────────────────────────────────────────────────────────────────────┐
# │ Base Functions                                                       │
# └──────────────────────────────────────────────────────────────────────┘

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

Function Invoke-JiraPostMethod {
    param(
        [Parameter(Mandatory = $true)][string]$Method,
        [Parameter(Mandatory = $true)][string]$Body
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
        Method               = "Post"
        SkipCertificateCheck = $settings.SkipCertificateCheck
        Body                 = $Body
        ContentType          = "application/json"
    }

    return Invoke-RestMethod @parameters
}

# ┌──────────────────────────────────────────────────────────────────────┐
# │ Issues                                                               │
# └──────────────────────────────────────────────────────────────────────┘

Function Get-JiraIssue {
    param(
        [Parameter(Mandatory = $true)][string]$IssueKey
    )

    return Invoke-JiraGetMethod -Method "issue/$IssueKey"
}

Function Get-JiraIssueTypes {
    return Invoke-JiraGetMethod -Method "issuetype"
}

Function New-JiraIssue {
    param(
        [Parameter(Mandatory = $true)][string]$ProjectKey,
        [Parameter(Mandatory = $true)][string]$IssueType,
        [Parameter(Mandatory = $true)][string]$Summary,
        [Parameter(Mandatory = $false)][string]$Description,
        [Parameter(Mandatory = $false)][string]$Priority = "Medium",
        [Parameter(Mandatory = $false)][string]$Assignee,
        [Parameter(Mandatory = $false)][string]$Reporter,
        [Parameter(Mandatory = $false)][string[]]$Components,
        [Parameter(Mandatory = $false)][string[]]$Labels,
        [Parameter(Mandatory = $false)][string]$EpicLink,
        [Parameter(Mandatory = $false)][string]$FixVersion
    )

    $availableIssueTypes = Get-JiraIssueTypes
    $availableIssueTypes = $availableIssueTypes | Where-Object { $_.name -eq $IssueType } | Select-Object -First 1

    $body = @{
        fields    = @{
            project = @{
                key = $ProjectKey
            }
            summary = $Summary
        }
        issuetype = @{
            id = $issueTypeData.id
        }
    }

    if ($Description) {
        $body.fields.description = $Description
    }

    if ($IssueType) {
        $body.fields.issuetype = @{
            name = $IssueType
        }
    }

    if ($Priority) {
        $body.fields.priority = @{
            name = $Priority
        }
    }

    if ($Assignee) {
        $body.fields.assignee = @{
            name = $Assignee
        }
    }

    if ($Reporter) {
        $body.fields.reporter = @{
            name = $Reporter
        }
    }

    if ($Components) {
        $body.fields.components = @(
            $Components | ForEach-Object {
                @{
                    id = $_
                }
            }
        )
    }

    if ($Labels) {
        $body.fields.labels = $Labels
    }

    if ($EpicLink) {
        $body.fields.customfield_10008 = $EpicLink
    }

    if ($FixVersion) {
        $body.fields.fixVersions = @(
            @{
                name = $FixVersion
            }
        )
    }

    $body = $body | ConvertTo-Json

    return Invoke-JiraPostMethod -Method "issue" -Body $body
}

# ┌──────────────────────────────────────────────────────────────────────┐
# │ Components                                                           │
# └──────────────────────────────────────────────────────────────────────┘

Function Get-JiraComponents {
    param(
        [Parameter(Mandatory = $true)][string]$ProjectKey
    )

    return Invoke-JiraGetMethod -Method "project/$ProjectKey/components"
}
