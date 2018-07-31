Function Find-Acl {
<#
.SYNOPSIS
    Returns Single ACL object
.NOTES
   
    Requires F5-LTM modules from github
#>

[cmdletBinding()]
    param(
        
        
        [Alias("Search String")]
        [Parameter(Mandatory=$true)]
        [string]$searchString=''
    )
        
    begin {
        #Test that the F5 session is in a valid format
        Test-F5Session($F5Session)       
    }
    process {
       
            $uri = $F5Session.BaseURL.Replace('/ltm/','/apm/acl/')
            $response = Invoke-RestMethodOverride -Method Get -Uri $URI -WebSession $F5Session.WebSession
            $searchReslts = $response.items.name | Select-String $searchString
            $searchReslts
        }
        
}

