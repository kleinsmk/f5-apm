Function Add-APMRole {
<#
.SYNOPSIS
    Adds a single ACL entry to existing ACL Role Object

.DESCRIPTION
    A detailed description of the function or script.

.PARAMETER name

.PARAMETER acl

.PARAMETER group


.EXAMPLE

.EXAMPLE

.EXAMPLE

.INPUTS
    The Microsoft .NET Framework types of objects that can be piped to the
    function or script. You can also include a description of the input
    objects.

.OUTPUTS
    The .NET Framework type of the objects that the cmdlet returns. You can
    also include a description of the returned objects.

.NOTES
    Additional information about the function or script.

.LINK

.LINK

.COMPONENT
    The technology or feature that the function or script uses, or to which
    it is related.

.ROLE
    The user role for the help topic. This content appears when the Get-Help
    command includes the Role parameter of Get-Help.

.FUNCTIONALITY
    The intended use of the function. This content appears when the Get-Help
    command includes the Functionality parameter of Get-Help.

.FORWARDHELPTARGETNAME <Command-Name>
    Redirects to the help topic for the specified command. You can redirect
    users to any help topic, including help topics for a function, script,
    cmdlet, or provider.

.FORWARDHELPCATEGORY  <Category>
    Specifies the help category of the item in ForwardHelpTargetName.
    Valid values are Alias, Cmdlet, HelpFile, Function, Provider, General,
    FAQ, Glossary, ScriptCommand, ExternalScript, Filter, or All. Use this
    keyword to avoid conflicts when there are commands with the same name.

.REMOTEHELPRUNSPACE <PSSession-variable>
    Specifies a session that contains the help topic. Enter a variable that
    contains a PSSession. This keyword is used by the Export-PSSession
    cmdlet to find the help topics for the exported commands.

.EXTERNALHELP  <XML Help File>
    Specifies an XML-based help file for the script or function.

    The ExternalHelp keyword is required when a function or script
    is documented in XML files. Without this keyword, Get-Help cannot
    find the XML-based help file for the function or script.

    The ExternalHelp keyword takes precedence over other comment-based
    help keywords. If ExternalHelp is present, Get-Help does not display
    comment-based help, even if it cannot find a help topic that matches
    the value of the ExternalHelp keyword.

    If the function is exported by a module, set the value of the
    ExternalHelp keyword to a file name without a path. Get-Help looks for
    the specified file name in a language-specific subdirectory of the module
    directory. There are no requirements for the name of the XML-based help
    file for a function, but a best practice is to use the following format:
    <ScriptModule.psm1>-help.xml

    If the function is not included in a module, include a path to the
    XML-based help file. If the value includes a path and the path contains
    UI-culture-specific subdirectories, Get-Help searches the subdirectories
    recursively for an XML file with the name of the script or function in
    accordance with the language fallback standards established for Windows,
    just as it does in a module directory.

    For more information about the cmdlet help XML-based help file format,
    see "How to Create Cmdlet Help" in the MSDN (Microsoft Developer Network)
    library at http://go.microsoft.com/fwlink/?LinkID=123415.
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