Function Get-NextAclOrder {
<#
.SYNOPSIS
    Returns the acl order number one less than 10,000
.NOTES
   
    Requires F5-LTM modules from github
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
            $sorted[-2]
        }
        
}

