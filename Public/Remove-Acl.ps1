Function Remove-Acl {
<#
.SYNOPSIS
    Removes existing ACL object.  ACL must not be linked to a reasource group
.PARAMETER name
    Existing ACL name
.EXAMPLE
    Remove-ACL -name My_ACL

    Removes ACL My_ACL
.NOTES
   
    Requires F5-LTM modules from github
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
        foreach ($itemname in $Name) {
            $uri = $F5Session.BaseURL.Replace('/ltm/',"/apm/acl/~Common~$name") 
            $response = Invoke-RestMethodOverride -Method Delete -Uri $URI -WebSession $F5Session.WebSession
            $response
        }
    }

}
        


