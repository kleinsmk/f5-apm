
Invoke-psake .\psakefile.ps1 -Verbose
Step-ModuleVersion -Path .\F5-apm.psd1
Invoke-PSDeploy .\f5-apm.PSDeploy.ps1 -Verbose
#Publish-Module -Name f5-apm -NuGetApiKey 8b82dc58-4b19-4e17-a3a9-cd9081557914