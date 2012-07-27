function Join-Object() {
    param (
        [parameter(ValueFromRemainingArguments=$true)] $arguments = @()
    )

    function Merge-Hashtables($master, $slave) {
      $slave.Keys | %{ 
        $key = $_
        $value = $slave.$key

        if ($value -is [hashtable]) {
          if ($master[$key] -eq $null) {
            $master[$key] = @{ }
          }

          Merge-Hashtables $master[$key] $value   
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

function Compare-Object($reference, $difference) {
  foreach ($key in $reference.Keys) {
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

  return $true
}