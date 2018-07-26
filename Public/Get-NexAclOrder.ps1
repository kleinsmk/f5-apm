Function Get-NextAclOrder {
<#
.SYNOPSIS
    Returns the next open acl order number
.DESCRIPTION
    In many production environments it is customary to have a ANY ANY Deny as the final rulset to explicitly deny any
    network traffic that isn't otherwise stated.  This cmdlet allow the user to get the next free acl order number
    less than 10,000, which is useful in keeping multiple F5 ACL sets syncd across devices without conflict.
.NOTES
    Requires F5-LTM modules from github
.Example
    Get-NextAclOrder

    Returns the next free acl order number.
#>


    begin {
        #Test that the F5 session is in a valid format
        Test-F5Session($F5Session)       
    }
    process {
       
            $uri = $F5Session.BaseURL.Replace('/ltm/','/apm/acl/') 
            $acl = Invoke-RestMethodOverride -Method Get -Uri $URI -WebSession $F5Session.WebSession
            $sorted = $acl.items.aclorder | Sort-Object
            #return 2nd to last item as we have a deny at acl order 10000
            ($sorted[-2]) + 1
        }
        
}

