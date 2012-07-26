function Join-Object() {
    param (
        [parameter(ValueFromRemainingArguments=$true)] $arguments = @()
    )

    function Merge-Hashtables($master, $slave) {
      $slave.Keys | %{ 
        $key = $_
        $value = $slave.$key

        if ($value -is [hashtable]) {
          $hashValue = $master[$key]
          if ($hashValue -eq $null) {
            $hashValue = @{ }
            $master[$key] = $hashValue
          }

          Merge-Hashtables $hashValue $value   
        }
        else {
          $master[$key] = $slave[$key] 
        }
      }
    }

    $joinedObject = @{ }

    $arguments | %{
      Merge-Hashtables $joinedObject $_
    }

    return $joinedObject
}

# Taken from http://stackoverflow.com/questions/4521905/how-to-compare-associative-arrays-in-powershell
function Compare-Object($reference, $difference) {
  $nonrefKeys = New-Object 'System.Collections.Generic.HashSet[string]'
  $difference.Keys | %{ 
    $nonrefKeys.Add($_) 
  }

  foreach ($key in $reference.Keys) {
    $nonrefKeys.Remove($key)
    $refValue = $reference.$key
    $difValue = $difference.$key

    if (-not $difference.ContainsKey($key)) {
      return $false
    }
    elseif ($refValue -is [hashtable] -and $difValue -is [hashtable]) {
      Compare-Object $refValue $difValue
    }
    elseif ($refValue -ne $difValue) {
      return $false
    }
  }

  foreach ($key in $nonrefKeys) {
    return $false
  }

  return $true
}