Function Get-Subnets {
<#
.SYNOPSIS
    Returns all the subnets for a CR
.Parameter aclName
    Existing jira CR Ticket in format CR-####
.Example
    Get-Subnets -aclName AWS_30090989898

    Returns all the subnets for ACL named AWS_30090989898
.NOTES
   
    Requires F5-LTM, F5-APM
#>
    [cmdletBinding()]
    param(
        
        #ACL Name
        [Parameter(Mandatory=$true)]
        [string]$aclName

    )
    begin {
        
             
    }
    process {
       
                try 
                {
                
                    (Get-SingleAcl -name $aclName ).entries | Select-Object dstsubnet -Unique

                }

                catch 
                {
                        Write-Error $_.Exception.Message
                        break
                        
                }

                
                 
   }#end process

}