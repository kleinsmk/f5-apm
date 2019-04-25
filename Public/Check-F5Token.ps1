function Check-F5Token {
<#
.SYNOPSIS
    Graceuflly handles expired token attemps
.NOTES
    Requires F5-LTM modules from github
#>
   
    #Handle expired or non-existing F5-Sessions gracefully
    $exp = $F5Session.WebSession.Headers. 'Token-Expiration'
    if ($exp -lt (get-date)) {

      Write-Warning "F5 Session is not active or has expired." -ErrorAction Stop
      break

    }

 }
