function Join-Object($first, $second) {
    $joinedObject = @{ }

    $first.Keys | %{ $joinedObject[$_] =  $first[$_] }
    $second.Keys | %{ $joinedObject[$_] =  $second[$_] }

    return $joinedObject
}

function Get-ComparedObject($first, $second, $expected) {
    $actual = Join-Object $first $second
    return Compare-Object -ref ($actual.GetEnumerator() | %{$_.Key + "-" + $_.Value}) -dif ($expected.GetEnumerator() | %{$_.Key + "-" + $_.Value}) 
}

Describe "Extend for PowerShell" {
    it "should extend simple object" {
        $test1 = @{
            test = "test1"
        }

        $test2 = @{
            test = "test2"
        }

        $expected = @{
            test = "test2"
        }

        $comparison = Get-ComparedObject $test1 $test2 $expected
        $exists = $comparison -eq $null
        $exists.should.be($true)
    }

    it "should extend objetc with second property" {
        $test1 = @{
            test1 = "test1"
        }

        $test2 = @{
            test2 = "test2"
        }

        $expected = @{
            test1 = "test1"
            test2 = "test2"
        }

        $comparison = Get-ComparedObject $test1 $test2 $expected
        $exists = $comparison -eq $null
        $exists.should.be($true)
    }
}