/**
 * ...
 * @author Franco Ponticelli
 */

package thx.macro;

import haxe.macro.TypeTools;
import haxe.macro.Type.ClassType;

class MacroTypes
{
	public static function argumentIsOptional(type : haxe.macro.Type, index : Int)
	{
		return switch(type)
		{
			case TFun(args, _) if(index < args.length):
				args[index].opt;
			case _:
				throw 'type $type is not a function or $index is not a valid argument position';
		}
	}

	public static function isFunction(type : haxe.macro.Type)
	{
		return switch(type)
		{
			case TFun(_, _):
				return true;
			case _:
				return false;
		}
	}

	public static function getArity(type : haxe.macro.Type)
	{
		return switch(type)
		{
			case TFun(args, _):
				return args.length;
			case _:
				return -1;
		}
	}

	public static function getArgumentType(type : haxe.macro.Type, index : Int)
	{
		return getFunctionArgument(type, index).t;
	}

	public static function getFunctionArguments(type : haxe.macro.Type)
	{
		return switch(type)
		{
			case TFun(args, _):
				return args;
			case _:
				throw 'type $type is not a function';
		}
	}

	public static function getFunctionArgument(type : haxe.macro.Type, index : Int)
	{
		var arg = getFunctionArguments(type)[index];
		if (null == arg)
			throw "invalid argument position $index";
		return arg;
	}

	public static function getFunctionReturn(type : haxe.macro.Type)
	{
		return switch(type)
		{
			case TFun(_, ret):
				return ret;
			case _:
				throw 'type $type is not a function';
		}
	}

	public static function getClassTypeParameters(type : haxe.macro.Type)
	{
		return switch(type)
		{
			case TInst(_, params):
				return params;
			case _:
				throw 'type $type is not a class';
		}
	}

	public static function toString(type : haxe.macro.Type, ?withparams = false)
	{
		return switch(type) {
			case TMono(t):
				return t.toString();
			case TEnum(t, params):
				return t.toString() + (withparams ? '<' + params.map(function(param) return toString(param, withparams)).join(", ") + '>' : '');
			case TInst(t, params):
				return t.toString() + (withparams ? '<' + params.map(function(param) return toString(param, withparams)).join(", ") + '>' : '');
			case TType(t, params):
				return t.toString() + (withparams ? '<' + params.map(function(param) return toString(param, withparams)).join(", ") + '>' : '');
			case TFun(args, ret):
				return args.map(function(arg) return (arg.opt?'?':'') + toString(arg.t, withparams)).concat([toString(ret, withparams)]).join(' -> ');
			case TAnonymous(a):
				return a.toString();
			case TDynamic(t):
				return null == t ? 'Null' : toString(t);
			case TLazy(f):
				return toString(f());
			case TAbstract(t, params):
				return t.toString() + (withparams ? '<' + params.map(function(param) return toString(param, withparams)).join(", ") + '>' : '');
		}
	}

	public static function classInheritance(cls : ClassType)
	{
		var types = [cls.pack.concat([cls.name]).join(".")],
			parent = null == cls.superClass ? null : classInheritance(cls.superClass.t.get());
		if(null != parent)
			types = types.concat(parent);
		return types;
	}

	public static function typeInheritance(type)
	{
		try {
			return classInheritance(TypeTools.getClass(type));
		} catch(e : Dynamic) {
			return [TypeTools.toString(type)];
		}
	}
}