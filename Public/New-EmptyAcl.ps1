Function New-EmptyAcl {
<#
.SYNOPSIS
    Adds a single blank ACL to configure later. You would use this when a client requires only a certain set of ports
    like you might encounter when doing an on prem only config.
.PARAMETER name
    The new ACL name you wish to use
.PARAMETER aclOrder
    The aclOrder you wish the the new ACL to have 
.EXAMPLE
    New-EmptyAcl -name Blue_Group -aclOrder 5026

    Creates a new blank ACL named Blue_Group with aclOrder 5026

.EXAMPLE
     New-EmptyAcl -name Blue_Group -aclOrder 5026
     Add-Acl -name Blue_Group -action allow -dstStartPort 8888 -dstEndPort 8888 -dstSubnet 10.128.1.16/32 
     Add-Acl -name Blue_Group -action allow -dstStartPort 8888 -dstEndPort 8888 -dstSubnet 10.128.1.29/32 

     Shows use case where you create a new ACL to allow port 8888 on two seperate networks only
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