
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "..\Public\$sut"

Describe 'New-DeafaultAcl' {
    
    BeforeAll {

        Connect-F5 -ip aws -creds $f5
    }

    $testCases = @(
        @{ Acl = 'test1'  ; Expected = 'reject' }
        @{ Acl = 'test2'   ; Expected = 'allow' }
      )

    Context "Testing Each Switch" {

        It "Create New Default ACL with -name '<Acl>' -action '<Expected>', returns entries with '<Expected>'" -TestCases $testCases {

            param ($Acl, $Expected)

            $result = New-DefaultAcl -name $Acl -action $Expected -subnet 1.2.3.4/32
            $result.entries.action[0] | Should -Be $Expected

        }

    }

    AfterAll {

        $testCases | ForEach-Object {Remove-Acl -name $_.acl}

    }   

}