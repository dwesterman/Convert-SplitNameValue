# Convert-SplitNameValue Script / Module (WIP)
Is a Set of functions for Converting Data into a SplitNameValue String and vice versa. 

This is helpful for pulling in data from one or more objects/arrays and automatically setting that data to Labtech/Automate variables by using "Variable Set: Split NameValue Parameter". It could also be used to save objects to a text file and pull them back out again and still be able to intract with the objects like normal, You could also use it to combine multiple objects into one, or to make new objects using a string.

Here is some code you can use to pull the latest version of the module temporarily for your current session.

```
$Raw = (([System.Net.WebRequest]::CreateHttp("https://gitcdn.link/cdn/AlecMcCutcheon/Convert-SplitNameValue/main/Convert-SplitNameValue.psm1")).GetResponse()).GetResponseStream(); $ScriptData = [Scriptblock]::Create(([System.IO.StreamReader]$Raw).ReadToEnd()); 
New-Module -Name Convert-SplitNameValue -ScriptBlock $ScriptData   
```

# Function "ConvertTo-SplitNameValue"
Aliases: ConvertTo-SplitNameValue, CT-SNV, ConvertTo-SNV, CT-SplitNameValue <br />

This function is used to convert data containing one or more objects or arrays into a SplitNameValue String.<br />
It has 4 useable parameters ( -InputData [psobject], -ObjectMarker [string], -DisableObjectMarkers [switch], -IncludeNull [switch],-Preview [switch] )

The -InputData Parameter can be used as a normal parameter with the Data in rounded brackets ( Data ), or you can provide it in the pipeline. 
Also Note that you can Have more then one InputData in the pipeline separated by , Exampe: Data1, Data2 | CT-SNV

The -ObjectMarker Parameter can be used to choose a custom postfix marker when InputData contains multiple objects or arrays. The Default ObjectMarker is &lowbar;#

The -DisableObjectMarkers Parameter can be used to Stop the separation of multiple objects, but be WARNED this will cause weird overwritten/mangled objects to be generated if any objects data has the same name as another objects data. On the other hand if you know all the objects data has different names then you could combine them into one object by doing this.

The -Preview Parameter can be used to display the SplitNameValue String output as a "list" (For Debugging/Viewing)"

The -IncludeNull Parameter can be used to output ALL object or array data even if it is null

Here is an example of some InputData:
```
PS C:\Users\%Username%\Desktop> Get-Partition | select Size, IsReadOnly, IsSystem , IsBoot

Size       : 554696704
IsReadOnly : False
IsSystem   : False
IsBoot     : False

Size       : 104857600
IsReadOnly : 
IsSystem   : True
IsBoot     : False

Size       : 16777216
IsReadOnly : 
IsSystem   : False
IsBoot     : False

```
Here is en example of the SplitNameValue String Output:
```
PS C:\Users\%Username%\Desktop> Get-Partition | select Size, IsReadOnly, IsSystem , IsBoot | ConvertTo-SplitNameValue

Size=554696704|IsReadOnly=False|IsSystem=False|IsBoot=False|Size_#2=104857600|IsSystem_#2=True|IsBoot_#2=False|Size_#3=16777216|IsSystem_#3=False|IsBoot_#3=False

```

# Function "ConvertFrom-SplitNameValue"
Aliases: ConvertFrom-SplitNameValue, CF-SNV, ConvertFrom-SNV, CF-SplitNameValue <br />

This function is used to convert one or more SplitNameValue Strings, into one or more objects.<br />
While you can input more then one SplitNameValue String at a time I do not recommend it because it will combine the output and may be confusing.<br />
It has 2 useable parameters ( -$InputString [string[]], -ObjectMarker [string] )

The -InputString Parameter can be used as a normal parameter with the SplitNameValue Formated string in quotes "string" or the pipeline.<br />
Here is an Exampe of a string in SplitNameValue Format: 
```
Date=5/19/2005|Time=11:00 AM|DOW=Wednesday
```
The -ObjectMarker Parameter can be used to choose a custom postfix marker when the InputString contains multiple objects or arrays.<br />
Note, You must supply the same custom ObjectMarker found in the InputString (If not using Default) in order to correctly separate objects.<br />
The Default ObjectMarker is &lowbar;# <br />
Here is an Example of a string in SplitNameValue Format with 2 Objects: 
```
ObjectSize=10|ObjectStatus=True|ObjectSize_#2=20|ObjectStatus_#2=False
```
Here are some examples of it's Output:

```
PS C:\Users\%Username%\Desktop> "Date=5/19/2005|Time=11:00 AM|DOW=Wednesday" | ConvertFrom-SplitNameValue |format-list

Date : 5/19/2005
Time : 11:00 AM
DOW  : Wednesday

PS C:\Users\%Username%\Desktop> "ObjectSize=10|ObjectStatus=True|ObjectSize_#2=20|ObjectStatus_#2=False" | ConvertFrom-SplitNameValue |format-list

ObjectSize   : 10
ObjectStatus : True

ObjectSize   : 20
ObjectStatus : False

PS C:\Users\%Username%\Desktop> "Size=554696704|IsReadOnly=False|IsSystem=False|IsBoot=False|Size_#2=104857600|IsSystem_#2=True|IsBoot_#2=False|Size_#3=16777216|IsSystem_#3=False|IsBoot_#3=False" | ConvertFrom-SplitNameValue | format-list

Size       : 554696704
IsReadOnly : False
IsSystem   : False
IsBoot     : False

Size       : 104857600
IsSystem   : True
IsBoot     : False
           
Size       : 16777216
IsSystem   : False
IsBoot     : False

```
```
PS C:\Users\%Username%> $example = "size=small|cost=14.00|size_#2=large|cost_#2=15.50" | CF-SNV
PS C:\Users\%Username%> $example | format-list

size : small
cost : 14.00

size : large
cost : 15.50

PS C:\Users\%Username%> $example.size
small
large

PS C:\Users\%Username%> $example.cost[0]
14.00

```
