
![SScriptLogo](https://github.com/TheWorldMachinima/SScript/assets/114953508/01fba6f6-caeb-4aa7-af4e-58b9d98984fc)

# SScript

S(uperlative)Script is an easy to use Haxe script parser and interpreter, including class support and more. It aims to support all of the Haxe structures while being fast and easy to use.

<details>
  <summary>About Classes</summary>
  Until 5.0.0, SScript used hscript-ex library by ianharrigan for class support.

  This was removed because it was only slowing development and it was not working at all.
  Unless hscript-ex gets updated, class support is not coming back.
</details>

## Installation
`haxelib install SScript`

Enter this command in command prompt to get the latest release from Haxe library.

------------

`haxelib git SScript https://github.com/TheWorldMachinima/SScript.git`

Enter this command in command prompt to get the latest git release from Github. 
Git releases have the latest features but they are unstable and can cause problems.

After installing SScript, don't forget to add it to your Haxe project.

------------

### OpenFL projects
Add this to `Project.xml` to add SScript to your OpenFL project:
```xml
<haxelib name="SScript"/>
<haxedef name="hscriptPos"/>
```

##### Enabling OpenFL Support 
SScript has support OpenFL, enabling it will replace the `sys` library with the `openfl` one. That means you can use SScript with HTML5 or any other OpenFL target.

To enable OpenFL support, add this line to `Project.xml`:
```xml
<haxedef name="openflPos"/>
```

This feature is supported on version 9.2.1 or higher.
Also remember that you can't define this flag on vanilla projects.

------------

### Haxe Projects
Add this to `build.hxml` to add SScript to your Haxe build.
```hxml
-lib SScript
-D hscriptPos
```

Flag `hscriptPos` is needed for error handling at runtime. It is optional but definitely recommended.

## Version checking
SScript can check if you are using the latest version of it.

It is disabled by default, but you can enable it with defining `CHECK_SUPERLATIVE`.

## Usage
To use SScript, you will need a file or a script. Using a file is recommended.

### Using without a file
```haxe
var script:tea.SScript = {}; // Create a new SScript class
script.doString("
	import Math; // Importing Math is unnecessary since SScript will set basic classes to script instance including Math but we do it just in case
	
	function returnRandom():Float
		return Math.random() * 100;
"); // Implement the script
var call = script.call('returnRandom');
var randomNumber:Float = call.returnValue; // Access the returned value with returnValue
```
Usage of `doString` should be minimalized.

### Using with a file
```haxe
var script:tea.SScript = new tea.SScript("script.hx"); // Has the same contents with the script above
var randomNumber:Float = script.call('returnRandom').returnValue;
```

------------

## Preprocessing Values
**This feature is not available on these targets:**
- JavaScript
- Flash
- ActionScript 3

You can preprocess values in Normal and Ex mode.
This feature is available in vanilla and OpenFL.

Example:
```haxe
#if sys
trace('sys is activated');
#end

#if (haxe > 4.3)
trace('haxe is bigger than 4.3');
#elseif (haxe == "4.3.0")
trace('haxe is 4.3');
#elseif (haxe >= "4.2")
trace('Haxe is between 4.2 and 4.3');
#else
trace('Haxe is older than 4.2');
#end
```

This feature works with libraries and other flags too.
If a flag has no value, like `sys`, their value will be `"1"`.
So you can check flags with no value like this:

```haxe
#if !sys
trace('sys is not active');
#elseif (sys == "1")
trace('sys is active');
#end
```

------------

## Using Haxe 4.3.0 Syntaxes
SScript supports both `?.` and `??` sytnaxes including `??=`.

```haxe
import tea.SScript;
class Main 
{
	static function main()
	{
		var script:SScript = {};
		script.doString("
			var string:String = null;
			trace(string.length); // Throws an error
			trace(string?.length); // Doesn't throw an error and returns null
			trace(string ?? 'ss'); // Returns 'ss';
			trace(string ??= 'ss'); // Returns 'ss' and assigns it to `string` variable
		");
	}
}
```

------------

## Extending SScript
You can create a class extending SScript to customize it better.
```haxe
class SScriptEx extends tea.SScript
{
	override function preset():Void
	{
		super.preset();
		
		// Only use 'set', 'setClass' or 'setClassString' in 'preset', avoid using 'interp.variables.set'!
		// Macro classes are not allowed to be set
		setClass(StringTools);
		set('NaN', Math.NaN);
		setClassString('sys.io.File');
	}
}
```
It is recommended to override only `preset`, other functions were not written with overridability in mind.

## Contact
If you have any questions or requests, open an issue here or message me on my Discord (tahirkarabekiroglu).