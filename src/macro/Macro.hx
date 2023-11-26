package macro;

import haxe.macro.Compiler;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.ExprTools;
import haxe.macro.MacroStringTools;
import haxe.macro.Printer;
import haxe.macro.TypeTools;
import haxe.macro.TypedExprTools;

import tea.backend.SScriptVer;
import tea.backend.crypto.Base32;

#if sys
import sys.io.File;
#end

using StringTools;

class Macro
{
	public static var VERSION(default, null):SScriptVer = new SScriptVer(5, 0, 0);

	#if sys
	public static var isWindows(default, null):Bool =  ~/^win/i.match(Sys.systemName());
	public static var definePath(get, never):String;
	#end

	static var credits:Array<String> = [
		"Special Thanks:",
		"- CrowPlexus\n",
	];

	public static var macroClasses:Array<Class<Dynamic>> = [
		Compiler,
		Context,
		MacroStringTools,
		Printer,
		ComplexTypeTools,
		TypedExprTools,
		ExprTools,
		TypeTools,
	]; 

	macro
	public static function initiateMacro() 
	{
		var long:String = '-------------------------------------------------------------------';
		log('------------------------SScript ${VERSION} Macro------------------------');

		/*for (i in credits)
			log(i);

		log('Checking version...');
		
		#if CHECK_SUPERLATIVE
		var v = VERSION.checkVer();

		if (v)
			log('Done! You are using the latest SScript version!');
		else if (!v)
			log('You\'re using an outdated version of SScript (${VERSION}). Please update it to ${SScriptVer.newerVer}.');
		#else
		log('Done! You are using the latest SScript version!');
		#end*/

		final defines = Context.getDefines();

		#if sys
		var pushedDefines:Array<String> = [];
		var string:String = "";
		for (i => k in defines)
		{
			if (!pushedDefines.contains(i))
			{
				string += '$i|$k';
				string += '\n';
				pushedDefines.push(i);
			}
		}
		var splitString:Array<String> = string.split('\n');
		if (splitString.length > 1 && string.endsWith('\n'))
		{
			splitString.pop();
			string = splitString.join('\n');
		}
		
		var path:String = definePath;
		File.saveContent(path, new Base32().encodeString(string));
		#end

		if (defines.exists('openflPos') && (
		#if openfl
		#if (openfl < "9.2.0")
		true
		#else
		false
		#end 
		#else
		true
		#end))
		#if (openfl < "9.2.0") Context.fatalError('Your openfl is outdated (${defines.get('openfl')}), please update openfl', (macro null).pos) #else Context.fatalError('You cannot use \'openflPos\' without targeting openfl', (macro null).pos) #end;

		if (defines.get("dce") != "std")
			Context.fatalError("SScript needs DCE to be std to work properly", (macro null).pos);

		log(long);
		
		return macro {}
	}

	public static function log(log:String)
	{
		#if sys
		Sys.println(log);
		#else
		trace('\n' + log);
		#end
	}

	#if sys
	static function get_definePath():String 
	{
		var env:String = if (isWindows) Sys.getEnv('USERPROFILE') else Sys.getEnv('HOME');
		if (isWindows && !env.endsWith('\\'))
			env += '\\';
		else if (!isWindows && !env.endsWith('/'))
			env += '/';

		return env + 'defines.cocoa';
	}
	#end
}
