# Convert-SplitNameValue Script / Module (WIP)
Is a Set of functions for Converting Data into a SplitNameValue String and vice versa. 

{ ConvertTo-SplitNameValue | ConvertFrom-SplitNameValue }

This is helpful for pulling in data from one or more objects/arrays and automatically setting that data to Labtech/Automate variables by using "Variable Set: Split NameValue Parameter". It could also be used to save objects to a text file and pull them back out again and still be able to intract with the objects like normal, and It makes creating new objects easy.

# Function "ConvertTo-SplitNameValue"
This function is used to convert data containing one or more objects or arrays into a SplitNameValue String.<br />
It has 4 useable parameters ( -InputData [psobject], -ObjectMarker [string],-IncludeNull [switch],-Preview [switch] )

The -InputData Parameter can be used as a normal parameter with the Data in rounded brackets ( Data ), or you can provide it in the pipeline.

The -ObjectMarker Parameter can be used to choose a custom postfix marker when InputData contains multiple objects or arrays.<br />
The Default ObjectMarker is &lowbar;#

The -Preview Parameter can be used to display the SplitNameValue String output as a "list" (For Debugging/Viewing)"

The -IncludeNull Parameter can be used to show ALL object or array data even if it is null"

Here is en example of some InputData:
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
Here is en example of the Output:
```
PS C:\Users\%Username%\Desktop> Get-Partition | select Size, IsReadOnly, IsSystem , IsBoot | ConvertTo-SplitNameValue

Size=554696704|IsReadOnly=False|IsSystem=False|IsBoot=False|Size_#2=104857600|IsSystem_#2=True|IsBoot_#2=False|Size_#3=16777216|IsSystem_#3=False|IsBoot_#3=False

```

# Function "ConvertFrom-SplitNameValue"
This function is used to convert a SplitNameValue String into one or more objects.<br />
It has 2 useable parameters ( -$InputString [string], -ObjectMarker [string] )

The -InputString Parameter can be used as a normal parameter with the SplitNameValue Formated string in quotes "string" or the pipeline.
Here is an Exampe of a string in SplitNameValue Format: 
```
Date=5/19/2005|Time=11:00 AM|DOW=Wednesday
```
The -ObjectMarker Parameter can be used to choose a custom postfix marker when the InputString contains multiple objects or arrays.<br />
Note, You must supply the same custom ObjectMarker found in the InputString (If not using Default) in order to correctly separate objects.<br />
The Default ObjectMarker is &lowbar;# Example with 2 Objects: 
```
ObjectSize=10|ObjectStatus=True|ObjectSize_#2=20|ObjectStatus_#2=False
```
Here is en example of some Output:

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
