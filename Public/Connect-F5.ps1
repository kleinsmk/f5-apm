function Connect-F5 {
<#
.SYNOPSIS
    Helper function to connect to an F5 using POSH F5-LTM module
.NOTES
    Creates a global varibale so that add-on functions can utilise the F5-LTM object for connectons
    Requires F5-LTM modules from github
#>

    param(

            [Alias('F5 IP Address')]
            [Parameter(Mandatory=$true)]
            [string]$ip='',
            [ValidateRange(300,36000)][int]$TokenLifespan=3600

        )

    $creds = Get-Credential -Message "Please enter credentials to access the F5 load balancer"

    #Force TLS for connection as onprem uses only tls12
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $Global:F5Session = New-F5Session -LTMName $ip -LTMCredentials $creds -Default -PassThru
}
