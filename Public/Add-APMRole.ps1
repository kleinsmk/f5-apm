﻿Function Add-APMRole {
<#
.SYNOPSIS
    Adds a single ACL entry to existing ACL Role Object.  This function is hard coded for LDAP lookups. Change as needed.

.DESCRIPTION
F5 stores VPN user ACL to LDAP role mappings in what they call an aggreagte reasource assign group.

In our shop we link ACL permissions to LDAP user groups.  This will append 
'expression' = "expr { [mcget {session.ldap.last.attr.memberOf}] contains "CN=ldapgroupname," }
to the array of mappings tied to each specific ACL.

.PARAMETER name

The name of the aggregate reasrouce group assigned to the VPN access profile.
These can be found at the REST endpoint /apm/policy/agent/resource-assign/

As of 6/18 dev was using "aggregate_acl_act_full_resource_assign_ag" and prod was using acl_1_act_full_resource_assign_ag

.PARAMETER acl

The existing ACL we want to map and LDAP group to.

.PARAMETER group

The existing LDAP group we want to map to and ACL

.EXAMPLE

Add mapping for ACL myACL on the prod F5 to my_LDAPgroup

Add-APMRole -name "acl_1_act_full_resource_assign_ag" -acl "myACL" -group "my_LDAPgroup"


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