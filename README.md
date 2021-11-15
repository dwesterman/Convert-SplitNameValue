# Convert-SplitNameValue
Is a Set of functions for Converting Data into a SplitNameValue String and vice versa. 

{ ConvertTo-SplitNameValue | ConvertFrom-SplitNameValue }

This is helpful for pulling in data from one or more objects/arrays and automatically setting that data to Labtech/Automate variables by using "Variable Set: Split NameValue Parameter". It could also be used to save objects to a text file and pull them back out again and still be able to intract with the objects like normal, and It makes creating new objects easy.

# ConvertTo-SplitNameValue
This function is used to convert data containing one or more objects or arrays into a SplitNameValue String.<br />
It has 4 parameters ( -InputData [psobject], -ObjectMarker [string],-IncludeNull [switch],-Preview [switch] )

The -InputData Parameter can be used as a normal parameter with the Data in rounded brackets "(Data)" or you can provide it in the pipeline.<br />
Here is a SplitNameValue Format Exampe: ( Date=5/19/2005 | Time=11:00 AM | DOW=Wednesday )

The -ObjectMarker Parameter can be used to choose a custom postfix marker when InputData contains multiple objects or arrays.    
The Default ObjectMarker is &lowbar;# Example with 2 Objects: (ObjectSize=10 | ObjectStatus=True | ObjectSize&lowbar;#2=20 | ObjectStatus&lowbar;#2=False)

The -Preview Parameter can be used to display the SplitNameValue String output as a "list" (For Debugging/Viewing)"

The -IncludeNull Parameter can be used to show ALL object or array data even if it is null"

# ConvertFrom-SplitNameValue
