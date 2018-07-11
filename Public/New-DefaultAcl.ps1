Function New-DefaultAcl {
<#
.SYNOPSIS
    Returns Single ACL object
.NOTES
   
    Requires F5-LTM modules from github
#>
    [cmdletBinding()]
    param(
        
        [Alias("acl Name")]
        [Parameter(Mandatory=$true)]
        [string[]]$name='',

        [Alias('aws subnet')]
        [Parameter(Mandatory=$true)]
        [string]$subnet='',

        [Alias('acl order')]
        [Parameter(Mandatory=$true)]
        [ValidateRange(5021,9999)] 
        [int]$aclOrder=''

    )
    begin {
        #Test that the F5 session is in a valid format
        Test-F5Session($F5Session)
        
        $JSONBody = @"
{
    "kind": "tm:apm:acl:aclstate",
    "name": "$name",
    "partition": "Common",
    "aclOrder": "$aclOrder",
    "entries": [
        {
            "action": "allow",
            "dstEndPort": 20,
            "dstStartPort": 20,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 22,
            "dstStartPort": 22,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 80,
            "dstStartPort": 80,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 443,
            "dstStartPort": 443,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 1433,
            "dstStartPort": 1433,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 1521,
            "dstStartPort": 1521,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 1532,
            "dstStartPort": 1532,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 3306,
            "dstStartPort": 3306,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 3389,
            "dstStartPort": 3389,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 5900,
            "dstStartPort": 5900,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 7331,
            "dstStartPort": 7331,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 8000,
            "dstStartPort": 8000,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 8080,
            "dstStartPort": 8080,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 8081,
            "dstStartPort": 8081,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 8443,
            "dstStartPort": 8443,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 8686,
            "dstStartPort": 8686,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 27017,
            "dstStartPort": 27017,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 139,
            "dstStartPort": 135,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 6,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 139,
            "dstStartPort": 135,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 17,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        },
        {
            "action": "allow",
            "dstEndPort": 0,
            "dstStartPort": 0,
            "dstSubnet": "$subnet",
            "log": "packet",
            "protocol": 1,
            "scheme": "any",
            "srcEndPort": 0,
            "srcStartPort": 0,
            "srcSubnet": "0.0.0.0/0"
        }
    ]
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