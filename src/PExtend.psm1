function Join-Object() {
    param (
        [parameter(ValueFromRemainingArguments=$true)] $arguments = @()
    )
    $joinedObject = @{ }

    $arguments | %{
      foreach ($key in $_.Keys) {
        $value = $_.$key
        $joinedObject[$key] =  $_[$key] 
      }
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

  function Compare-Hashtable($ref, $dif) {
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
        Compare-Hashtable $refValue $difValue
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

  Compare-Hashtable $reference $difference
}