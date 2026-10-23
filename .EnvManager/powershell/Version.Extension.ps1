Function ConvertTo-SemanticVersion {
    Param (
        [Parameter(Mandatory = $true)][string]$Version
    )
    
    return [System.Management.Automation.SemanticVersion]::new($Version)
}

Function Get-NextMajorVersion {
    Param (
        [Parameter(Mandatory = $true)][System.Management.Automation.SemanticVersion]$Version
    )
        
    return [System.Management.Automation.SemanticVersion]::new($Version.Major + 1, 0, 0)
}

Function Get-NextMinorVersion {
    Param (
        [Parameter(Mandatory = $true)][System.Management.Automation.SemanticVersion]$Version
    )
        
    return [System.Management.Automation.SemanticVersion]::new($Version.Major, $Version.Minor + 1, 0)
}

Function Get-NextPatchVersion {
    Param (
        [Parameter(Mandatory = $true)][System.Management.Automation.SemanticVersion]$Version
    )
        
    return [System.Management.Automation.SemanticVersion]::new($Version.Major, $Version.Minor, $Version.Minor + 1)
}