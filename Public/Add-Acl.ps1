Function Add-Acl {
<#
.SYNOPSIS
    Add a new ACL to an Existing object on the f5 load balancer.

.PARAMETER name

    Name of Existing ACL

.PARAMETER action

    'Allow' or 'Deny' for ACL


.PARAMETER dstStartPort

    Destination start port.  Can take multiples values in csv list format. Ex: 80,8080,443,8443

.PARAMETER dstEndPort

    Desintation end port.  Only mandatory for adding in port ranges.

.PARAMETER dstSubnet

    Destination subnet in format 192.168.1.1/32. Can take multiples values in csv list format. Ex: 10.22.33.200/24,10.224.30.2/28
    Single ip ACL changes are represented by /32 
    Larger network ranges can be used by passing the correct CIDR notation.


.EXAMPLE
    Add-Acl -name Existing_ACL_Name -action allow -dstStartPort 80 -dstEndPort 80 -dstSubnet 192.168.1.1/24
    
    Add a New ACL for a single port and network range /24
.EXAMPLE

    Add-Acl -name Existing_ACL_Name -action allow -dstStartPort 80 -dstEndPort 8000 -dstSubnet 192.168.1.1/24

    Add a New ACL for a port range 80-8000 and network range /24
.Example
    Add-Acl -name Existing_ACL_Name -action allow -dstStartPort 80 -dstEndPort 80 -dstSubnet 192.168.1.1/32

    Adds a New ACL for port 80 to a SINGLE IP
.Example
    Add-Acl -name Existing_ACL_Name -action allow -dstStartPort 80,8080,443 -dstSubnet 192.168.1.1/32,192.168.1.40/24

    Adds a New ACL for ports 80,8080,443 on Subnets 192.168.1.1/32 and 192.168.1.40/24

#>
    [cmdletBinding()]
    param(
        
        [Alias("Existing acl Name")]
        [Parameter(Mandatory=$true)]
        [string]$name='',

        [Alias("Allow or Deny")]
        [Parameter(Mandatory=$true)]
        [string]$action='',

        [Alias("DestinationStart")]
        [Parameter(Mandatory=$true)]
        [string []]$dstStartPort='',

        [Alias("DestinationEnd")]
        [Parameter(Mandatory=$false)]
        [string []]$dstEndPort= $dstStartPort,

        [Alias("Subnet")]
        [Parameter(Mandatory=$true)]
        [string []]$dstSubnet=''


    )
    begin {
        if( $F5Session.WebSession.Headers.'Token-Expiration' -lt (date) ){
            Write-Warning "F5 Session Token is Expired.  Please re-connect to the F5 device."
            break

        }
        #Test that the F5 session is in a valid format
        Test-F5Session($F5Session)
        $acl = Get-SingleAcl -name $name
    }

    process {

        foreach ($sub in $dstSubnet) {

            foreach ($port in $dstStartPort) {
                
                $index = $dstStartPort.IndexOf($port)

                $baseAclEntry =  [PSCustomObject]@{
	                'action' = "$action"
	                'dstEndPort' = $dstEndPort[$index]
	                'dstStartPort' = "$port"
	                'dstSubnet' = "$sub"
	                'log' = 'packet'
	                'protocol' = 6
	                'scheme' = 'any'
	                'srcEndPort' = 0
	                'srcStartPort' = 0
	                'srcSubnet' = '0.0.0.0/0'
                }

                # add first acl
                if ( -not $acl.entries ) { 
            

                    $baseAclEntry = [PSCustomObject]@{'entries' = @(
		                    [PSCustomObject]@{
			                'action' = "$action"
			                'dstEndPort' = $dstEndPort[$index]
			                'dstStartPort' = "$port"
			                'dstSubnet' = $sub
			                'log' = 'packet'
			                'protocol' = 6
			                'scheme' = 'any'
			                'srcEndPort' = 0
			                'srcStartPort' = 0
			                'srcSubnet' = '0.0.0.0/0'}
	                    )}

                        Add-Member -InputObject $acl -NotePropertyName entries -NotePropertyValue (New-Object System.Collections.ArrayList)  #add first acl into object so we don't hit this block again
                        $acl.entries += $baseAclEntry.entries 
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

}