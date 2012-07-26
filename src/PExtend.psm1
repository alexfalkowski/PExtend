function Join-Object() {
    param (
        [parameter(ValueFromRemainingArguments=$true)] $arguments = @()
    )

    function Merge-Hashtables($master, $slave) {
      foreach ($key in $slave.Keys) {
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
# Need to adapt it to just return $true or $false
function Compare-Object($reference, $difference, $includeEqual) {
  function Get-Result($side) {
    New-Object PSObject -Property @{
      'InputPath'= "$key";
      'SideIndicator' = $side;
      'ReferenceValue' = $refValue;
      'DifferenceValue' = $difValue;
    }
  }

  function Compare-Hashtables($ref, $dif) {
    $nonrefKeys = New-Object 'System.Collections.Generic.HashSet[string]'
    $dif.Keys | foreach { 
        [void]$nonrefKeys.Add($_) 
    }

    foreach ($key in $ref.Keys) {
      [void]$nonrefKeys.Remove($key)
      $refValue = $ref.$key
      $difValue = $dif.$key

      if (-not $dif.ContainsKey($key)) {
        Get-Result '<='
      }
      elseif ($refValue -is [hashtable] -and $difValue -is [hashtable]) {
        Compare-Hashtables $refValue $difValue
      }
      elseif ($refValue -ne $difValue) {
        Get-Result '<>'
      }
      elseif ($includeEqual) {
        Get-Result '=='
      }
    }

    $refValue = $null
    foreach ($key in $nonrefKeys) {
      $difValue = $dif.$key
      Get-Result '=>'
    }
  }

  Compare-Hashtables $reference $difference
}