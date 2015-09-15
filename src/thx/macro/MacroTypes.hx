package thx.macro;

#if(neko || macro)
import haxe.macro.TypeTools;
import haxe.macro.Type.ClassType;
import haxe.macro.Type;
/**
Extension methods to work with types at macro time.
**/
class MacroTypes {
/**
It returns true if the argument at position `index` is optional for the given function.
**/
  public static function argumentIsOptional(fun : Type, index : Int)
    return switch fun {
      case TFun(args, _) if(index < args.length):
        args[index].opt;
      case _:
        throw 'type $fun is not a function or $index is not a valid argument position';
    };

/**
It returns `true` if the passed `type` is a function.
**/
  public static function isFunction(type : Type)
    return switch type {
      case TFun(_, _):
        return true;
      case _:
        return false;
    };

/**
It returns the arity(number of arguments) of a given function.
**/
  public static function getArity(fun : Type)
    return switch fun {
      case TFun(args, _):
        return args.length;
      case _:
        return -1;
    };

/**
It returns the type of an argument at `index` for a given function.
**/
  public static function getArgumentType(fun : Type, index : Int)
    return getFunctionArgument(fun, index).t;

/**
It returns an array of argument descriptions for a given function.
**/
  public static function getFunctionArguments(fun : Type)
    return switch fun {
      case TFun(args, _):
        return args;
      case _:
        throw 'type $fun is not a function';
    };

/**
It returns the argument description for a function at `index`.
**/
  public static function getFunctionArgument(fun : Type, index : Int) {
    var arg = getFunctionArguments(fun)[index];
    if(null == arg)
      throw "invalid argument position $index";
    return arg;
  }

/**
It gets the return type of a function.
**/
  public static function getFunctionReturn(type : Type)
    return switch type {
      case TFun(_, ret):
        return ret;
      case _:
        throw 'type $type is not a function';
    };

/**
It returns an array of type parameters.
**/
  public static function getClassTypeParameters(type : Type)
    return switch type {
      case TInst(_, params):
        return params;
      case _:
        throw 'type $type is not a class';
    };

/**
It returns an array of types in string format representing the inheritance chain of the
passed `Type`.
**/
  public static function typeInheritance(type : Type) : Array<String>
#if macro
    return try {
      MacroClassTypes.inheritanceAsStrings(TypeTools.getClass(type));
    } catch(e : Dynamic) {
      [TypeTools.toString(type)];
    };
#else
    return null;
#end
}
#end
