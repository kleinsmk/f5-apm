Function New-ASMPolicy {
<#
.SYNOPSIS
    Creates a new ASM policy.
.PARAMETER name
    The new name of the ASM policy
.EXAMPLE
    New-ASMPolicy -name Test_ASM

    Creates a new ASM policy named Test_ASM

.EXAMPLE
    
.NOTES
   
    Requires F5-LTM modules from github
#>
    [cmdletBinding()]
    param(
        
        [Alias("acl Name")]
        [Parameter(Mandatory=$true)]
        [string[]]$policyname=''

    )
    begin {
      
      if( $F5Session.WebSession.Headers.'Token-Expiration' -lt (date) ){
            Write-Warning "F5 Session Token is Expired.  Please re-connect to the F5 device."
            break
        }
        #Test that the F5 session is in a valid format
        Test-F5Session($F5Session)
        
        #if statement below adds acl order if param is present or blank if false
     

    }
    process {
        foreach ($name in $policyname) {


        $JSONBody = @"
        {
  "commands": [
    {
      "uri": "/mgmt/tm/asm/policies",
      "body": {
        "type": "security",
        "name": "test_asm",
        "caseInsensitive": false,
        "protocolIndependent": false,
        "partition": "Common",
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "policy-builder": {
          "learningMode": "automatic"
        },
        "signature-settings": {
          "signatureStaging": true
        },
        "general": {
          "enforcementReadinessPeriod": 7
        },
        "templateReference": {
          "link": "/mgmt/tm/asm/policy-templates/KGO8Jk0HA4ipQRG8Bfd_Dw"
        }
      },
      "method": "POST"
    }
  ]
}
"@

            $uri = $F5Session.BaseURL.Replace('/ltm/','/asm/tasks/bulk')
            
            try{ 
                $response = Invoke-RestMethodOverride -Method Post -Uri $URI -Body $JSONBody -ContentType 'application/json' -WebSession $F5Session.WebSession
                Write-Output "New AMS policy creation task started..."
            }

            catch { 
                Write-Warning "Error creating ASM policy task."
                $_.ErrorDetails.Message
                break
            }

            #set uri to asm task iD
            $uri = $F5Session.BaseURL.Replace('/ltm/',"/asm/tasks/bulk/$($response.id)") 
            
            $taskStatus = $false

            #check until completed
            while( $taskStatus -eq $false ){
                try{ 
                    Write-Output "Checking Task..."
                    $response = Invoke-RestMethodOverride -Method GET -Uri $URI -ContentType 'application/json' -WebSession $F5Session.WebSession
                    if ( $response.result -eq "FAILURE" ){ Write-Output $response.errors }
                    if ( $response.result -eq "COMPLETED" ) { $taskStatus = $true }
                    Sleep -Seconds 3
                }

                catch { 
                    Write-Warning "Error checking ASM policy task."
                    $_.ErrorDetails.Message
                    break
                }
            }#while

            #set uri to filer for newly create policy id
            $uri = $F5Session.BaseURL.Replace('/ltm/',"asm/policies?`$filter=fullPath+eq+%27%2FCommon%2F$name%27&`$select=id") 

            try{ 
                    
                    $response = Invoke-RestMethodOverride -Method GET -Uri $URI -ContentType 'application/json' -WebSession $F5Session.WebSession
                    $id = $response.items.id
          
                }

                catch { 
                    Write-Warning "Error Getting ASM policy ID."
                    $_.ErrorDetails.Message
                    break
                }

            
            $uri = $F5Session.BaseURL.Replace('/ltm/',"asm/policies/$id") 

           

        }#foreach loop
        
}#proccess loop
}#function close