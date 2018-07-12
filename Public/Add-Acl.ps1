Function Add-Acl {
<#
.SYNOPSIS
    Add a new ACL to an Existing object on the f5 load balancer.

.PARAMETER name

    Name of Existing ACL

.PARAMETER action

    Allow or Deny for ACL


.PARAMETER dstStartPort

    Destination start port

.PARAMETER dstEndPort

    Desintation end port

.PARAMETER dstSubnet

    Destination subnet in format 192.168.1.1/32
    
    Single ip ACL changes are represented by /32 Larger network ranges can be used by passing the correct CIDR notation.


.EXAMPLE

    Add a new acl for a single port.
    
    Add-Acl -name Existing_ACL_Name -action allow -dstStartPort 80 -dstEndPort 80 -dstSubnet 192.168.1.1/32

.EXAMPLE

    Add a new acl for a port range.

    Add-Acl -name Existing_ACL_Name -action allow -dstStartPort 80 -dstEndPort 8000 -dstSubnet 192.168.1.1/32


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

            # append the entires if acls already exist
            if ( -not $acl.entries ) { 
            

                $baseAclEntry = [PSCustomObject]@{'entries' = @(
		                [PSCustomObject]@{
			            'action' = "$action"
			            'dstEndPort' = "$dstEndPort"
			            'dstStartPort' = "$dstStartPort"
			            'dstSubnet' = "$dstSubnet"
			            'log' = 'packet'
			            'protocol' = 6
			            'scheme' = 'any'
			            'srcEndPort' = 0
			            'srcStartPort' = 0
			            'srcSubnet' = '0.0.0.0/0'}
	                )}

                    $JSONBody = $baseAclEntry | ConvertTo-Json -Depth 10
            
            }

 
            else { 
                   
                   
                $acl.entries += $baseAclEntry
                $JSONBody = $acl | ConvertTo-Json -Depth 10 

                }
            

            $uri = $F5Session.BaseURL.Replace('/ltm/',"/apm/acl/~Common~$name")
            $response = Invoke-RestMethodOverride -Method Patch -Uri $URI -Body $JSONBody -ContentType 'application/json' -WebSession $F5Session.WebSession
            $response
        }
        
}

}