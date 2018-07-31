Function Get-APMRole {
<#
.SYNOPSIS
    Returns Single APM reasource assign role object
.DESCRIPTION
    APM stores ACL role mappings in a container object called a resrouce assign group.  In order to maniupulate the
    contents of its roles and rulsets you need to first retrieve it from the F5 via its name.
.PARAMETER name
    The name of the existing resource assign group.  These can be found at rest endpoint /apm/policy/agent/resource-assign/
.NOTES
    Requires F5-LTM modules from github
.EXAMPLE
    Get-APMRole -name acl_1_act_full_resource_assign_ag
#>
    [cmdletBinding()]
    param(
        
        [Alias("APM Role Name")]
        [Parameter(Mandatory=$true)]
        [string[]]$name=''

    )
    begin {
        #Test that the F5 session is in a valid format
        Test-F5Session($F5Session)       
    }
    process {
       
            $uri = $F5Session.BaseURL.Replace('/ltm/','/apm/policy/agent/resource-assign/~Common~') + $name 
            $response = Invoke-RestMethodOverride -Method Get -Uri $URI -WebSession $F5Session.WebSession
            $response
        }
        
}

