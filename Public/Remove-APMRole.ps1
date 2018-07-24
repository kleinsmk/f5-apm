Function Remove-APMRole {
<#
.SYNOPSIS
    Removes a single ACL entry mapped existing ACL Role Object.  This function is hard coded for LDAP lookups. Change as needed.

.DESCRIPTION
F5 stores VPN user ACL to LDAP role mappings in what they call an aggreagte reasource assign group.

In our shop we link ACL permissions to LDAP user groups.  This will remove 
'expression' = "expr { [mcget {session.ldap.last.attr.memberOf}] contains "CN=ldapgroupname," }
from the array of mappings tied to each specific ACL.

 

.PARAMETER name

The name of the aggregate reasrouce group assigned to the VPN access profile.
These can be found at the REST endpoint /apm/policy/agent/resource-assign/

As of 6/18 dev was using "aggregate_acl_act_full_resource_assign_ag" and prod was using acl_1_act_full_resource_assign_ag

.PARAMETER acl

The existing ACL we want to remove from the existing mapping

.EXAMPLE

Remove mapping for ACL myACL on the prod F5 to my_LDAPgroup

Remove-APMRole -acl "myACL" -group "myACL"


#>

    [cmdletBinding()]
    param(
        
        
        [Alias("existing acl Name")]
        [Parameter(Mandatory=$true)]
        [string]$acl='',

        [Alias("existing acl group")]
        [Parameter(Mandatory=$true)]
        [string]$group='',

        #this is set as default dev for testing change to prod when stable
        [Alias("APM Role Name")]
        [Parameter(Mandatory=$false)]
        [string]$name='aggregate_acl_act_full_resource_assign_ag'

    )
    begin {
        #Test that the F5 session is in a valid format
        Test-F5Session($F5Session)
        $role = Get-APMRole -name $name

    }
    process {
       
            #build full object just in case you ever fiure out why you only get an -eq match on the expression field
            # and can replace this code with a simple array.remove($obj) logic

            $acl_Remove =  [PSCustomObject]@{
		                                        'acls' = @(
			                                    "/Common/$acl")
		                                        'expression' = "expr { [mcget {session.ldap.last.attr.memberOf}] contains \`"CN=$group,\`" }"
	                       }

            $rules_withoutAcl = @()

            #need to loop through array as powershell doesn't have a - operator 
            foreach ($row in $role.rules) {
                    #keep only what we don't want to remove
              if( $row.acls -ne $acl_Remove.acls ){
                
                $rules_withoutAcl += $row
                
              } 
            }

            $role.rules = $rules_withoutAcl         

            $JSONBody = $role | ConvertTo-Json -Depth 10
            
            $uri = $F5Session.BaseURL.Replace('/ltm/','/apm/policy/agent/resource-assign/~Common~') + $name
            $response = Invoke-RestMethodOverride -Method Patch -Uri $URI -Body $JSONBody -ContentType 'application/json' -WebSession $F5Session.WebSession
            $response
        }
        
}

