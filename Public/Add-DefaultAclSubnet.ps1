Function Add-DefaultAclSubnet {
<#
.SYNOPSIS
   Adds an entire set of CSN default subnet ports to an existing ACL.
   Current ports are TCP 20,22, 80, 443, 1443, 1521, 1532, 3306, 3389 UPD & TCP, 5432, 5433, 5900, 7331, 8000, 8081, 8443, 8086, 27017, 139-135 UDP, ICMP

.PARAMETER name
	The existing ACL name
.PARAMETER dstSubnet
	The subnet of the network to add.  /32 specifies a single ip instead of a network.

.EXAMPLE
	Add-DefaultAclSubnet -name aclName -dstSubnet 10.22.33.0/24

	Adds a new default port range to the ACL 'aclName' on the 10.22.33.0/24 network
.EXAMPLE
	Add-DefaultAclSubnet -name aclName -dstSubnet 10.22.33.234/32

	Adds a new default port range to ACL 'aclName' on Host 10.22.33.234
.EXAMPLE

#>
    [cmdletBinding()]
    param(
        
        [Alias("existing acl Name")]
        [Parameter(Mandatory=$true)]
		[string[]]$name,
		
		[Parameter(Mandatory=$false)]
        [string]$action="allow",

        [Alias("Subnet")]
        [Parameter(Mandatory=$true)]
        [string[]]$dstSubnet


    )
    begin {
        #Test that the F5 session is in a valid format
        Test-F5Session($F5Session)
        $acl = Get-SingleAcl -name $name

    }
    process {
        foreach ($subnet in $dstSubnet) {
            #build

    $baseAclEntry =  @(
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 20
		'dstStartPort' = 20
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 22
		'dstStartPort' = 22
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 80
		'dstStartPort' = 80
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 443
		'dstStartPort' = 443
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 1433
		'dstStartPort' = 1433
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 1521
		'dstStartPort' = 1521
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 1532
		'dstStartPort' = 1532
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 3306
		'dstStartPort' = 3306
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 3389
		'dstStartPort' = 3389
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
    [PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 3389
		'dstStartPort' = 3389
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 17
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 5433
		'dstStartPort' = 5432
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 5900
		'dstStartPort' = 5900
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},

	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 7331
		'dstStartPort' = 7331
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 8000
		'dstStartPort' = 8000
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 8080
		'dstStartPort' = 8080
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 8081
		'dstStartPort' = 8081
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 8443
		'dstStartPort' = 8443
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 8686
		'dstStartPort' = 8686
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 27017
		'dstStartPort' = 27017
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 139
		'dstStartPort' = 135
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 139
		'dstStartPort' = 135
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 17
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 6443
		'dstStartPort' = 6443
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 6
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	},
	[PSCustomObject]@{
		'action' = "$action"
		'dstEndPort' = 0
		'dstStartPort' = 0
		'dstSubnet' = "$subnet"
		'log' = 'packet'
		'protocol' = 1
		'scheme' = 'any'
		'srcEndPort' = 0
		'srcStartPort' = 0
		'srcSubnet' = '0.0.0.0/0'
	}
)

            $acl.entries += $baseAclEntry

            $JSONBody = $acl | ConvertTo-Json -Depth 10
   
            $uri = $F5Session.BaseURL.Replace('/ltm/',"/apm/acl/~Common~$name")
            $response = Invoke-RestMethodOverride -Method Patch -Uri $URI -Body $JSONBody -ContentType 'application/json' -WebSession $F5Session.WebSession
            $response
        }
}

}