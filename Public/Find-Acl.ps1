Function Find-Acl {
<#
.SYNOPSIS
    Search F5 for an existing ACL
.NOTES
   
    Requires F5-LTM modules from github
.Example
    Find-Acl -searchstring "123456"

    Returns, if matching, a list of any ACL with 123456 in its name.
#>

[cmdletBinding()]
    param(
        
        #text that you match matched
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

