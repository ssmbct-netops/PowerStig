# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
#region Method Functions

<#
.SYNOPSIS
    Returns the log format.

.Parameter CheckContent
    An array of the raw string data taken from the STIG setting.
#>

<#
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
#>

#Begin Document region

<#
        .SYNOPSIS
            This is a placeholder for the DocumentRuleGetScript block.
        
        .DESCRIPTION
            
        
        .PARAMETER CheckContent
            
#>

function Get-DocumentRuleGetScript
{
    [CmdletBinding()]
    [OutputType([string])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        $CheckContent
    )

    return
}

<#
    .SYNOPSIS
        Placeholder for DocumentRuleTestScript

    .DESCRIPTION
        
    .PARAMETER CheckContent
        
#>

function Get-DocumentRuleTestScript
{
    [CmdletBinding()]
    [OutputType([string])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        $CheckContent
    )

        return
    
}

<#
    .SYNOPSIS Get-DocumentRuleSetScript
        Placeholder for DocumentRuleSetScript
    .DESCRIPTION
        
    .PARAMETER FixText
        

    .PARAMETER CheckContent
        
#>

function Get-DocumentRuleSetScript
{
    [CmdletBinding()]
    [OutputType([string])]
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [AllowEmptyString()]
        [string[]]
        $FixText,    

        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        $CheckContent
    )

        return
}

#End Document region

#Begin Permissions region

<#
    .SYNOPSIS
        This is a placeholder for PermissionRuleGetScript

    .DESCRIPTION
        

    .PARAMETER CheckContent
        
#>

function Get-PermissionGetScript
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string[]]
        $CheckContent
    )
   
    $queries = Get-Query -CheckContent $CheckContent

    $return = $queries[0]

    if ($return -notmatch ";$")
    {
        $return = $return + ";"
    }

    return $return
}

<#
    .SYNOPSIS
        This is a placeholder for PermissionRuleTestScript

    .DESCRIPTION
        

    .PARAMETER CheckContent
        
#>
function Get-PermissionTestScript
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string[]]
        $CheckContent
    )

    $queries = Get-Query -CheckContent $CheckContent

    $return = $queries[0]

    if ($return -notmatch ";$")
    {
        $return = $return + ";"
    }

    return $return
}

<#
    .SYNOPSIS
        This is a placeholder for PermissionSetScript

    .DESCRIPTION
        

    .PARAMETER FixText
        

    .PARAMETER CheckContent
        
#>
function Get-PermissionSetScript
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter()]
        [AllowEmptyString()]
        [string[]]
        $FixText,

        [Parameter()]
        [AllowEmptyString()]
        [string[]]
        $CheckContent
    )

    $permission = ((Get-Query -CheckContent $CheckContent)[0] -split "'")[1] #Get the permission that will be set
    <#
        The following lines of code should create variables containing values that change the content from what was returned from the Get block based on the results from the Test block.
    #>

    

    return $permission
}

#End Permissions region



#Begin Manual region



#End Manual region

#Begin RuleType region

<#
    .SYNOPSIS
        Labels a rule as a specific type to retrieve the proper script used to enforce the STIG rule.

    .DESCRIPTION
        This functions labels a rule as a specific type so the proper scripts can dynamically be retrieved.

    .PARAMETER CheckContent
        This is the 'CheckContent' derived from the STIG raw string and holds the query that will be returned
#>

function Get-SharePointRuleType
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string[]]
        $CheckContent
    )

    $content = $CheckContent -join " "

    switch ($content)
    {
        # Standard permissions parsers
        {
            $PSItem -Match 'WSS_ADMIN_WPG' -or #V-60391, V-60005
            $PSItem -Match 'least privilege' -or #V-59997, V-60001
            $PSItem -Match 'site collection audit settings' #V-59941
        }
        {
            $ruleType = 'PermissionRule'
        }
        # information rights management/DocumentRule
        {
            $PSItem -Match 'configure information rights management' -and
            $PSItem -Match 'Do not use IRM' -or #V-59947, V-59973, V-59945
            $PSItem -Match 'Anti-virus' #V-59987, V-60011
        }
        {
            $ruleType = 'DocumentRule'
        }
                
        <#
            Default parser if not caught before now - if we end up here we haven't trapped for the rule sub-type.
            These should be able to get, test, set via Get-Query cleanly
        #>
        default
        {
            $ruleType = 'ManualRule'
        }
    }

    return $ruleType
}

#End RuleType region

#Begin Helper function region

function Test-VariableRequired
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Rule
    )

    $requiresVariableList = @(
        ''
    )

    return ($Rule -in $requiresVariableList)
}

#End Helpfer function region