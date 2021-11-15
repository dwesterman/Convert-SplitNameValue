function ConvertTo-SplitNameValue {

  [alias("CT-SNV")]
  [alias("ConvertTo-SNV")]
  [alias("CT-SplitNameValue")]

  param(
    [Parameter(Mandatory = $false,ValueFromPipeLine = $true)]
    [psobject]$InputData,
    [Parameter(Mandatory = $false)]
    [switch]$IncludeNull,
    [Parameter(Mandatory = $false)]
    [switch]$Preview,
    [Parameter(Mandatory = $false)]
    [string]$ObjectMarker,
    [Parameter(Mandatory = $false)]
    [switch]$Help

  )

  begin {
    $Index = 0
    $SplitNameValue = ""
  }
  process {

    if ($Help -eq $true) {
      Write-Output ""
      Write-Output "Info: You can use the '-InputData' parameter or the pipeline to Input Data containing 1 or more objects or arrays."
      Write-Output "Info: You can use the '-IncludeNull' parameter to show all object data even if it is null"
      Write-Output "Info: You can use the '-Preview' parameter to display the SplitNameValue Output as a list (For Debugging/Viewing)"
      Write-Output "Info: You can use the '-ObjectMarker' parameter to choose a custom postfix marker when InputData contains multiple objects or arrays."
      Write-Output "Info: The Default ObjectMarker is '_#' Example with 2 Objects: ( ObjectSize=10 | ObjectStatus=True | ObjectSize_#2=20 | ObjectStatus_#2=False )"
      break
    }

    if ($InputData -eq $null) {
      Write-Output ""
      Write-Output "Error: No data suppied in pipeline or in the '-InputData' parameter";
      break
    }

    $Index++

    if ($ObjectMarker -eq "") {
      $ObjectMarker = "_#"
    }

    if ($Index -eq 1) { $Count = "" } else { $Count = $ObjectMarker + $index }

    foreach ($prop in $InputData.psobject.properties) {

      if (($InputData | Format-List | Out-String) -match $prop.Name) {

        if ($IncludeNull -eq $false) {

          if ($InputData.$($prop.Name) -ne $null) {

            if ($SplitNameValue -eq "" -and $index -eq 1) {
              $SplitNameValue = ($prop.Name + $Count + "=" + $prop.Value)
            } else {
              $SplitNameValue = ($SplitNameValue += "|" + $prop.Name + $Count + "=" + $prop.Value)
            }
          }
        } else {

          if ($SplitNameValue -eq "") {
            $SplitNameValue = ($prop.Name + $Count + "=" + $prop.Value)
          } else {
            $SplitNameValue = ($SplitNameValue += "|" + $prop.Name + $Count + "=" + $prop.Value)
          }
        }
      }

    }

  }
  end {

    if ($Preview -eq $false) {
      Write-Output $SplitNameValue | Out-String
    } else {
      Write-Output ""
      Write-Output $SplitNameValue.Replace("|",[Environment]::NewLine)
    }

  }
}

function ConvertFrom-SplitNameValue {

  [alias("CF-SNV")]
  [alias("ConvertFrom-SNV")]
  [alias("CF-SplitNameValue")]

  param(
    [Parameter(Mandatory = $false,ValueFromPipeLine = $true)]
    [string[]]$InputString,
    [Parameter(Mandatory = $false)]
    [string]$ObjectMarker,
    [Parameter(Mandatory = $false)]
    [switch]$Help
  )

  process {


    function Split-Text {
      param(
        [Parameter(Mandatory = $True)] [string]$Text,
        [Parameter(Mandatory = $True)] [string]$Separator,
        [string]$EscapeChar = '\'
      )
      $Text -split
      ('(?<=(?<!{0})(?:{0}{0})*){1}' -f [regex]::Escape($EscapeChar),[regex]::Escape($Separator)) `
         -replace ('{0}(.)' -f [regex]::Escape($EscapeChar)),'$1'
    }

    if ($Help -eq $true) {
      Write-Output ""
      Write-Output "Info: You can use the '-InputString' parameter or the pipeline to Input a String in SplitNameValue Format"
      Write-Output "Info: SplitNameValue Format Exampe: ( Date=5/19/1999 | Time=12:03 AM | DOW=Wednesday )"
      Write-Output "Info: You can use the '-ObjectMarker' parameter to choose a custom postfix marker when InputString contains multiple objects or arrays"
      Write-Output "Info: You must supply the same custom ObjectMarker found in the InputString (If not using Default) in order to correctly separate objects"
      Write-Output "Info: The Default ObjectMarker is '_#' Example with 2 Objects: ( ObjectSize=10 | ObjectStatus=True | ObjectSize_#2=20 | ObjectStatus_#2=False )"
      break
    }

    if ($InputString -eq $null) {
      Write-Output ""
      Write-Output "Error: No String Suppied in Pipeline or in the '-InputString' parameter";
      break
    }

    if ($ObjectMarker -eq "") {
      $ObjectMarker = "_#"
    }

    $array = $InputString.Split("|");

    if ($array[-1] -like "*$ObjectMarker*") {
      $NumberOfObjects = (Split-Text -Text $array[-1] -Separator $ObjectMarker)[1].Split("=")[0]
    } else {
      $NumberOfObjects = 1;
    }

    $Count = 1
    while ($Count -le $NumberOfObjects) {
      $obj = [pscustomobject]::new()
      foreach ($split in $array) {
        if ((((Split-Text -Text ($split.Split("=")[0]) -Separator $ObjectMarker)[1]) -eq $Count) -or (($split.Split("=")[0] -notlike "*$ObjectMarker*") -and $Count -eq 1)) {
          if ($Count -eq 1) {
            Add-Member -InputObject $obj -NotePropertyName ($split.Split("=")[0]) -NotePropertyValue $split.Split("=",2)[1]

          } else {
            Add-Member -InputObject $obj -NotePropertyName ((Split-Text -Text $split -Separator ($ObjectMarker + $Count))[0]) -NotePropertyValue $split.Split("=",2)[1]

          }
        }
      }
      $Count = $Count + 1
      Write-Output $obj
    }
  }
}
