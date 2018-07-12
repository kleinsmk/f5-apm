Function New-EmptyAcl {
<#
.SYNOPSIS
    Adds a single blank ACL to configure later
.NOTES
   
    Requires F5-LTM modules from github
#>
    [cmdletBinding()]
    param(
        
        [Alias("acl Name")]
        [Parameter(Mandatory=$true)]
        [string[]]$name='',

        [Alias('acl order')]
        [Parameter(Mandatory=$false)]
        [ValidateRange(5021,9999)] 
        [int]$aclOrder=''

    )
    begin {
        #Test that the F5 session is in a valid format
        Test-F5Session($F5Session)
        
        #if statement below adds acl order if param is present or blank if false
     $JSONBody = @"
{
    "kind": "tm:apm:acl:aclstate",
    "name": "$name",
    "partition": "Common",
    $(if ( -not [string]::IsNullOrEmpty($aclOrder)) { "`"aclOrder`": `"$aclOrder`","})
    "entries": "none"
}
"@

    }
    process {
        foreach ($itemname in $Name) {
            $uri = $F5Session.BaseURL.Replace('/ltm/','/apm/acl/') 
            $response = Invoke-RestMethodOverride -Method Post -Uri $URI -Body $JSONBody -ContentType 'application/json' -WebSession $F5Session.WebSession
            $response
        }
        
}

}