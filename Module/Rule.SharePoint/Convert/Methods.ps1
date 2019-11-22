# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
#region Method Functions

<#
.SYNOPSIS
    Returns the log format.

.Parameter CheckContent
    An array of the raw string data taken from the STIG setting.
#>
function Get-LogCustomFieldEntry
{
    [CmdletBinding()]
    [OutputType([object[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [psobject]
        $CheckContent
    )

    if ($checkContent -match $regularExpression.customFieldSection)
    {
        $customFieldEntries = @()
        [string[]] $customFieldMatch = $checkContent | Select-String -Pattern $regularExpression.customFields -AllMatches

        foreach ($customField in $customFieldMatch)
        {
            $customFieldEntry = ($customField -split $regularExpression.customFields).trim()
            $customFieldEntries += @{
                SourceType = $customFieldEntry[0] -replace ' ', ''
                SourceName = $customFieldEntry[1]
            }
        }
    }

    return $customFieldEntries
}

