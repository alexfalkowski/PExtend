PExtend
=======

Provides the ability to extend objects. Inspired by jQuery.extend() http://api.jquery.com/jQuery.extend/

Usage
-----

Given this example:

	$test1 = @{
            test1 = "test1"
    }

    $test2 = @{
            test2 = "test2"
    }

    $result = Join-Object $test1 $test2

The result will be:

	$expected = @{
        test1 = "test1"
        test2 = "test2"
    }

Look for more examples in \specs folder