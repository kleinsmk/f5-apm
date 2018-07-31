Function Get-SingleAcl {
<#
.SYNOPSIS
    Returns Single ACL object
.DESCRIPTION
    Allows the user to quickly return a single ACL as refernced by name.  A good way to check for existing ACLs
    in addition to programatic ACL manipulation.
.PARAMETER name
    ACL name
.NOTES
    Requires F5-LTM modules from github
.EXAMPLE
    Get-SingleAcl -name myACL

    Returns the ACL object for ACL myACL
#>
    [cmdletBinding()]
    param(
        
        [Alias("acl Name")]
        [Parameter(Mandatory=$true)]
        [string[]]$name=''

    )
    begin {
        #Test that the F5 session is in a valid format
        Test-F5Session($F5Session)       
    }
    process {
       
            $uri = $F5Session.BaseURL.Replace('/ltm/','/apm/acl/~Common~') + $name 
            $response = Invoke-RestMethodOverride -Method Get -Uri $URI -WebSession $F5Session.WebSession
            $response
        }
        
}

