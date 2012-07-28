PExtend
=======

Provides the ability to extend objects. Inspired by jQuery.extend() http://api.jquery.com/jQuery.extend/

Usage
-----

To use this module you need to install the module from [PSGet](http://psget.net/) using the command:
    
    Install-Module PExtend

Once you have module installed try this example:

	$test1 = @{
        test1 = "test1"
    }

    $test2 = @{
        test2 = "test2"
    }

    $result = Join-Hashtable $test1 $test2

The result will be:

	$expected = @{
        test1 = "test1"
        test2 = "test2"
    }

Look for more examples in \specs folder