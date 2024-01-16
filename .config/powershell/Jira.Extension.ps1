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
            id = $availableIssueTypes.id
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

    $body = $body | ConvertTo-Json -Depth 10

    return Invoke-JiraPostMethod -Method "issue" -Body $body
}

Function New-JiraSubTask {
    param(
        [Parameter(Mandatory = $true)][string]$ProjectKey,
        [Parameter(Mandatory = $true)][string]$Summary,
        [Parameter(Mandatory = $true)][string]$ParentIssueKey,
        [Parameter(Mandatory = $false)][string]$IssueType = "Sub-task",
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
            parent  = @{
                key = $ParentIssueKey
            }
            summary = $Summary
        }
        issuetype = @{
            id = $availableIssueTypes.id
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
                $id = Get-JiraComponent -ProjectKey $ProjectKey -Name $_ | Select-Object -ExpandProperty id

                @{
                    id = $id
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
            $id = Get-JiraVersion -ProjectKey $ProjectKey -Name $FixVersion | Select-Object -ExpandProperty id

            @{
                id = $id
            }
        )
    }

    $body = $body | ConvertTo-Json -Depth 10

    return Invoke-JiraPostMethod -Method "issue" -Body $body
}

# ┌──────────────────────────────────────────────────────────────────────┐
# │ Components                                                           │
# └──────────────────────────────────────────────────────────────────────┘

Function Get-JiraComponent {
    param(
        [Parameter(Mandatory = $true)][string]$ProjectKey,
        [Parameter(Mandatory = $true)][string]$Name
    )

    $components = Get-JiraComponents -ProjectKey $ProjectKey | Where-Object { $_.name -eq $Name } | Select-Object -First 1

    if ($components.count -eq 0) {
        throw "Component '$Name' not found in project '$ProjectKey'"
    }

    return $components
}

Function Get-JiraComponents {
    param(
        [Parameter(Mandatory = $true)][string]$ProjectKey
    )

    return Invoke-JiraGetMethod -Method "project/$ProjectKey/components"
}

# ┌──────────────────────────────────────────────────────────────────────┐
# │ Components                                                           │
# └──────────────────────────────────────────────────────────────────────┘

Function Get-JiraVersion {
    param(
        [Parameter(Mandatory = $true)][string]$ProjectKey,
        [Parameter(Mandatory = $true)][string]$Name
    )

    $versions = Get-JiraVersions -ProjectKey $ProjectKey | Where-Object { $_.name -eq $Name } | Select-Object -First 1

    if ($versions.count -eq 0) {
        throw "Version '$Name' not found in project '$ProjectKey'"
    }

    return $versions
}


Function Get-JiraVersions {
    param(
        [Parameter(Mandatory = $true)][string]$ProjectKey
    )

    return Invoke-JiraGetMethod -Method "project/$ProjectKey/versions"
}
