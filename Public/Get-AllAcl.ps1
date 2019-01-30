Function Get-AllAcl {
<#
.SYNOPSIS
    Returns all ACL objects
.DESCRIPTION
    Allows the user to quickly return all user ACL objects in the F5.
.NOTES
    Requires F5-LTM modules from github
.EXAMPLE
    Get-AllAcl

    Returns the all the ACL objets on the connected F5
#>

    begin {
        #Test that the F5 session is in a valid format
        Test-F5Session($F5Session)       
    }
    process {
       
            $uri = $F5Session.BaseURL.Replace('/ltm/','/apm/acl/')
            $response = Invoke-RestMethodOverride -Method Get -Uri $URI -WebSession $F5Session.WebSession
            $response
        }
        
}

