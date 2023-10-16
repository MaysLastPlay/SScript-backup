package tea;

import tea.SScript;

interface SScriptInterface<T:SScript>
{
    var active:Bool;

    function set(key:String, obj:Dynamic):T;
    function setClass(cl:Class<Dynamic>):T;
    function setClassString(cl:String):T;
    function unset(key:String):T;
    function clear():T;
    function call(func:String, ?args:Array<Dynamic>, ?className:String):SCall;
}

interface SScriptGroupInterface<T:SScript> extends SScriptInterface<T>
{
    var members(default, null):Array<T>;
    var length(default, null):Null<Int>;

    function add(script:T):T;
    function addMultiple(...scripts:T):Void;
}

/**
    An alias for `SScriptTypedGroup`, meaning you can add vanilla `SScript` or classes extending `SScript`.

    You cannot add another group to a group.
**/
@:keep
typedef SScriptGroup = SScriptTypedGroup<SScript>;

/**
    A simple group that allows you to control multiple scripts at once.

    Limitations:
    - Lacks `preset`.
    - Lacks initial return value (no functions).
    - Lacks basic SScript functions like `get`, `doString` etc.
**/
@:keepSub
class SScriptTypedGroup<T:SScript> implements SScriptGroupInterface<T>
{
    /**
		This variable tells if this group is active or not.

		Set this to false if you do not want your group to get executed!
	**/
    public var active:Bool = true;

    /**
        The script members in this group as an array.
    **/
    public var members(default, null):Array<T>;    

    /**
        How many scripts are in this group. 
    **/
    public var length(default, null):Null<Int>;

    @:noPrivateAccess var _destroyed(default, null):Bool = false;

    /**
        Creates a new Group.
    **/
    public function new() 
    {
        members = new Array();
        length = 0;
    }

    /**
        Adds a script to this group.
        @param script Script to add.
        @return Returns the script if it's active, null otherwise.
    **/
    public function add(script:T):T
    {
        if (_destroyed)
            return null;

        if (!active)
            return null;

        members.push(script);
        length++;

        return script;
    }

    /**
        Adds multiple scripts to this group.
        
        This function needs at least 1 argument, but argument length is indefinite.
    **/
    public function addMultiple(...scripts:T):Void
    {
        if (_destroyed)
            return;

        if (!active)
            return;

        for (i in scripts)
        {
            members.push(i);
            length++;
        }
    }

    /**
		Sets a variable to this group. 

		If `key` already exists it will be replaced.
		@param key Variable name.
		@param obj The object to set. If the object is a macro class, function will be aborted.
		@return Returns always `null`.
	**/
	public function set(key:String, obj:Dynamic):T 
    {
        if (_destroyed)
            return null;

        if (!active)
            return null;

		if (members.length < 1)
            return null;

        for (i in members)
        {
            if (i != null)
                i.set(key, obj);
        }

        return null;
	}

    /**
		This is a helper function to set classes easily.
		For example; if `cl` is `sys.io.File` class, it'll be set as `File`.
		@param cl The class to set. It cannot be macro classes.
		@return Returns always `null`.
	**/
	public function setClass(cl:Class<Dynamic>):T 
    {
        if (_destroyed)
            return null;

        if (!active)
            return null;

		if (members.length < 1)
            return null;

        for (i in members)
        {
            if (i != null)
                i.setClass(cl);
        }

        return null;
	}

    /**
		Sets a class to this group from a string.
		`cl` will be formatted, for example: `sys.io.File` -> `File`.
		@param cl The class to set. It cannot be macro classes.
		@return Returns always `null`.
	**/
	public function setClassString(cl:String):T 
    {
        if (_destroyed)
            return null;

        if (!active)
            return null;

		if (members.length < 1)
            return null;

        for (i in members)
        {
            if (i != null)
                i.setClassString(cl);
        }

        return null;
	}

    /**
		Removes a variable from this group. 

		If a variable named `key` doesn't exist, unsetting won't do anything.
		@param key Variable name to remove.
		@return Returns always `null`.
	**/
	public function unset(key:String):T 
    {
        if (_destroyed)
            return null;

        if (!active)
            return null;

		if (members.length < 1)
            return null;

        for (i in members)
        {
            if (i != null)
                i.unset(key);
        }

        return null;
	}

    /**
		Clears all of the keys assigned to this group.

		@return Returns always `null`.
	**/
	public function clear():T 
    {
        if (_destroyed)
            return null;

        if (!active)
            return null;

		if (members.length < 1)
            return null;

        for (i in members)
        {
            if (i != null)
                i.clear();
        }

        return null;
	}

    /**
		Calls a function from the group.

        Return value will be null if no members has one. Otherwise, it will be first not null return value.
	**/
	public function call(func:String, ?args:Array<Dynamic>, ?className:String):SCall 
    {
        if (_destroyed)
            return null;

        if (!active)
            return null;

        var call:SCall = {
            exceptions: [],
            calledFunction: func,
            succeeded: false,
            returnValue: null
        };

        if (members.length < 1)
            return call;

        var calls:Array<SCall> = [];

        for (i in members) 
            if (i != null)
                calls.push(i.call(func, args, className));

        var checkReturns:Bool = true;
        for (i in calls) 
        {
            if (i.exceptions.length > 0)
            {
                for (e in i.exceptions)
                    call.exceptions.push(e);
            }

            if (i.returnValue != null && call.returnValue == null)
            {
                if (i.returnValue == SScript.STOP_RETURN)
                    checkReturns = false;
                else if (checkReturns)
                    Reflect.setProperty(call, "returnValue", i.returnValue);
            }
        }

		return call;
	}

    /**
		This function makes this group **COMPLETELY** unusable and unrestorable.

		If you don't want to destroy your group just yet, just set `active` to false!
	**/
    public function destroy()
    {
        if (_destroyed)
            return;
        
        for (i in members)
            i.destroy();

        while (members.length > 0)
            members.pop();

        members = null;
        length = null;
        active = false;
        _destroyed = true;
    }
}