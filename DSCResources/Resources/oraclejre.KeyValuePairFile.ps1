# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

$rules = $stig.RuleList | Select-Rule -Type FileContentRule

foreach ($rule in $rules)
{
    switch ($rule.dscresource)
    {
        {$_ -eq 'KeyValuePairFile'}
        {
            if ($rule.Key -match "config")
            {
                $path = $ConfigPath
            }
            else
            {
                $path = $PropertiesPath
            }

            KeyValuePairFile "$(Get-ResourceTitle -Rule $rule)"
            {
                Path   = $path
                Name   = $rule.Key
                Ensure = 'Present'
                Text   = $rule.Value
            }
        }

        {$_ -eq 'ReplaceText'}
        {
            $content = $rule.Value -split ','
            foreach ($line in $content)
            {
                $line = $line.Trim()
                ReplaceText "$(Get-ResourceTitle -Rule $rule) $line"
                {
                    Path        = $rule.Key
                    Search      = $line
                    Type        = 'Text'
                    Text        = $line
                    AllowAppend = $true
                }
            }
        }
    }
}
