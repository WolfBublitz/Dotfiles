<#
    .SYNOPSIS
        Creats a zip file from a folder.

    .DESCRIPTION
        Creats a zip file from a folder.

    .PARAMETER Path
        The path to the folder to zip.
    
    .PARAMETER DestinationPath
        The path to the zip file to create.
    
    .PARAMETER CompressionLevel
        The compression level to use (default: Fastest).
#>
function Compress-Zip {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $false)][string]$DestinationPath = $null,
        [Parameter(Mandatory = $false)][string]$CompressionLevel = "Fastest")

    if ([System.String]::IsNullOrEmpty($DestinationPath)) {
        $DestinationPath = "$($Path).zip"
    }

    $compress = @{
        Path             = $Path
        CompressionLevel = $CompressionLevel
        DestinationPath  = $DestinationPath
    }

    Compress-Archive @compress
}

<#
    .SYNOPSIS
        Extracts a zip file to a folder.
    
    .DESCRIPTION
        Extracts a zip file to a folder.

    .PARAMETER Path
        The path to the zip file to extract.

    .PARAMETER DestinationPath
        The path to the folder to extract to.
#>
function Expand-Zip {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $false)][string]$DestinationPath = $null)

    if ([System.String]::IsNullOrEmpty($DestinationPath)) {
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($Path)
        $filePath = [System.IO.Path]::GetDirectoryName($Path)

        $DestinationPath = Join-Path  -Path $filePath -ChildPath $fileName
    }

    $expand = @{
        Path            = $Path
        DestinationPath = $DestinationPath
    }

    Expand-Archive @expand
}