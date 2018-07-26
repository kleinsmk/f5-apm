Function Get-APMPolicy {
<#
.SYNOPSIS
    Returns APM Policy Ojbect
    CSN_VPN_Streamlined is an example
.DESCRIPTION 
    Returns APM policy object so that manipulations like applying policies can be done.

.EXAMPLE

Get-APMPolicy -name "CSN_VPN_Streamlined"

.NOTES
   
    Requires F5-LTM modules from github
#>
    [cmdletBinding()]
    param(
        
        [Alias("APM Policy Name")]
        [Parameter(Mandatory=$true)]
        [string[]]$name=''

    )
    begin {
        #Test that the F5 session is in a valid format
        Test-F5Session($F5Session)       
    }
    process {
       
            $uri = $F5Session.BaseURL.Replace('/ltm/','/apm/profile/access/~Common~') + $name 
            $response = Invoke-RestMethodOverride -Method GET -Uri $URI -WebSession $F5Session.WebSession
            $response
        }
        
}

