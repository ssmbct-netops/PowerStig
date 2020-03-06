# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

<#
    Instructions:  Use this file to add/update/delete regsitry expressions that are used accross 
    multiple technologies files that are considered commonly used.  Enure expressions are listed
    from MOST Restrive to LEAST Restrictive, similar to exception handling.  Also, ensure only
    UNIQUE Keys are used in each hashtable to orevent errors and conflicts.
#>

$global:SingleLineRegistryValueName += [ordered]@{
    McAfee1 = @{
        Match  = '\\Software\\McAfee'
        Select = '(?<=If the value of\s)([^\s]+)'
    }
    McAfee2 = @{
        Match  = '\\Software\\McAfee'
        Select = '(?<=If the value\s)([^\s]+)'
    }
}

$global:SingleLineRegistryValueData += [ordered]@{
    McAfee1 = @{
        Select = '(If\sthe\svalue\sof\s{0}\sis\s)([^\s]*)'
    }
}
