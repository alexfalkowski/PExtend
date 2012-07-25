Import-Module ../src/PExtend.psm1

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

        $actual = Join-Object $test1 $test2
        $comparison = Compare-Object $actual $expected
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

        $actual = Join-Object $test1 $test2
        $comparison = Compare-Object $actual $expected
        $exists = $comparison -eq $null
        $exists.should.be($true)
    }

    it "should extend object with an single inner hashtable" {
        $test1 = @{
            test = "test1"
            innerTest = @{
                test = "test1"
            }
        }

        $test2 = @{
            test = "test2"
        }

        $expected = @{
            test = "test2"
            innerTest = @{
                test = "test1"
            }
        }

        $actual = Join-Object $test1 $test2
        $comparison = Compare-Object $actual $expected
        $exists = $comparison -eq $null
        $exists.should.be($true)
    }

    it "should extend object with both objects having inner hashtables" {
        $test1 = @{
            test = "test1"
            innerTest1 = @{
                test = "test1"
            }
        }

        $test2 = @{
            test = "test2"
            innerTest2 = @{
                test = "test1"
            }
        }

        $expected = @{
            test = "test2"
            innerTest1 = @{
                test = "test1"
            }
            innerTest2 = @{
                test = "test1"
            }
        }

        $actual = Join-Object $test1 $test2
        $comparison = Compare-Object $actual $expected
        $exists = $comparison -eq $null
        $exists.should.be($true)
    }
}