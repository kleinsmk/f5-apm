function Connect-F5 {
<#
.SYNOPSIS
    Helper function to connect to an F5 using POSH F5-LTM module,  This is required as the f5-apm module
    leverages the work of https://github.com/joel74/POSH-LTM-Rest for connecting and inovking ssl based Rest Requests
.DESCRIPTION
    Creates a global varibale so that add-on functions can utilise the F5-LTM object for connectons
    Requires F5-LTM modules from github
.PARAMETER ip
    The ip or dns entry of the f5 to connect to.

.PARAMETER TokenLifeSpan
    The token lifespan for connection.  Possibly in seconds no documenation is availbale.  The default is set.
.Example
    Connect-F5 -ip yourf5dns.workisfun.com
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
