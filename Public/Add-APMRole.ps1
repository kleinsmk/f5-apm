Function Add-APMRole {
<#
.SYNOPSIS
    Adds a single ACL entry to existing ACL Role Object
.NOTES
    Requires F5-LTM modules from github
#>
    [cmdletBinding()]
    param(
        
        [Alias("APM Role Name")]
        [Parameter(Mandatory=$true)]
        [string[]]$name='',

        [Alias("existing acl Name")]
        [Parameter(Mandatory=$true)]
        [string[]]$acl='',

        [Alias("LDAP group")]
        [Parameter(Mandatory=$true)]
        [string[]]$group=''


    )
    begin {
        #Test that the F5 session is in a valid format
        Test-F5Session($F5Session)
        $role = Get-APMRole -name $name




    }
    process {
        foreach ($itemname in $Name) {
            #build

        $newRoleMapping =  [PSCustomObject]@{
		                                        'acls' = @(
			                                    "/Common/$acl")
		                                        'expression' = "expr { [mcget {session.ldap.last.attr.memberOf}] contains \`"CN=$acl,\`" }"
	                       }

            $role.rules += $newRoleMapping

            $JSONBody = $role | ConvertTo-Json -Depth 10
            $JSONBody
            $uri = $F5Session.BaseURL.Replace('/ltm/','/apm/policy/agent/resource-assign/~Common~') + $name
            $response = Invoke-RestMethodOverride -Method Patch -Uri $URI -Body $JSONBody -ContentType 'application/json' -WebSession $F5Session.WebSession
            $response
        }
        
}

}