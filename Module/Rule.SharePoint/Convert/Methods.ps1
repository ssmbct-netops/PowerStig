# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
#region Method Functions

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

function Get-SharePointRuleSubType
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
        
        {
            $PSItem -Match 'DoDI 8552.01' -or #V-59957
            $PSItem -Match 'session time-out' -or #V-59919
            $PSItem -Match 'Unique session IDs' -or #V-59977
            $PSItem -Match 'MSNBC online gallery' #V-59991
        }
        {
            $ruleType = 'SPWebAppGeneralSettings'
        }
        # information rights management/DocumentRule
        {
            $PSItem -Match 'AD DS console' -and
            $PSItem -Match 'WSS_WPG'
            
        }
        {
            $ruleType = 'ActiveDirectoryDsc'
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