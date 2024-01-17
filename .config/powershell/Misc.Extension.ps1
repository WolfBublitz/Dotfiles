using namespace System

<#
.SYNOPSIS
    Get the number of months since marriage.

.DESCRIPTION
    Get the number of months since marriage.
#>
Function Get-MonthsSinceMarriage {

    $marriageDate = [DateTime]::new(2016, 3, 11)

    $currentDate = Get-Date

    return [Math]::Abs(12 * $marriageDate.Year + $marriageDate.Month - 12 * $currentDate.Year - $currentDate.Month)
}