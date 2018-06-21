Function Add-Acl {
<#
.SYNOPSIS
    Adds a single ACL entry to existing ACL Object
.NOTES
    Requires F5-LTM modules from github
#>
    [cmdletBinding()]
    param(
        
        [Alias("existing acl Name")]
        [Parameter(Mandatory=$true)]
        [string[]]$name='',

        [Alias("Allow or Deny")]
        [Parameter(Mandatory=$true)]
        [string[]]$action='',

        [Alias("DestinationStart")]
        [Parameter(Mandatory=$true)]
        [string[]]$dstStartPort='',

        [Alias("DestinationEnd")]
        [Parameter(Mandatory=$true)]
        [string[]]$dstEndPort='',

        [Alias("Subnet")]
        [Parameter(Mandatory=$true)]
        [string[]]$dstSubnet=''


    )
    begin {
        #Test that the F5 session is in a valid format
        Test-F5Session($F5Session)
        $acl = Get-SingleAcl -name $name




    }
    process {
        foreach ($itemname in $Name) {
            #build

        $baseAclEntry =  [PSCustomObject]@{
	        'action' = "$action"
	        'dstEndPort' = "$dstEndPort"
	        'dstStartPort' = "$dstStartPort"
	        'dstSubnet' = "$dstSubnet"
	        'log' = 'packet'
	        'protocol' = 6
	        'scheme' = 'any'
	        'srcEndPort' = 0
	        'srcStartPort' = 0
	        'srcSubnet' = '0.0.0.0/0'
        }

            $acl.entries += $baseAclEntry

            $JSONBody = $acl | ConvertTo-Json -Depth 10

            $uri = $F5Session.BaseURL.Replace('/ltm/',"/apm/acl/~Common~$name")
            $response = Invoke-RestMethodOverride -Method Patch -Uri $URI -Body $JSONBody -ContentType 'application/json' -WebSession $F5Session.WebSession
            $response
        }
        
}

}