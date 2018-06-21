Function Update-APMPolicy {
<#
.SYNOPSIS
    Applies changes to existing APM policy
.NOTES
    Requires F5-LTM modules fro
    m github to connect
#>
    [cmdletBinding()]
    param(
        
        [Alias("APM Policy Name")]
        [Parameter(Mandatory=$true)]
        [string[]]$name=''


    )
    begin {
        #Test that the F5 session is in a valid format
        Test-F5Session($F5Session)
        $profile = Get-APMPolicy -name $name

    }
    process {
       
           

            $profile.generationAction = "increment"

            $JSONBody = $profile | ConvertTo-Json -Depth 10

            $uri = $F5Session.BaseURL.Replace('/ltm/','/apm/profile/access/~Common~') + $name
            $response = Invoke-RestMethodOverride -Method Patch -Uri $URI -Body $JSONBody -ContentType 'application/json' -WebSession $F5Session.WebSession
            $response
        
        
}

}