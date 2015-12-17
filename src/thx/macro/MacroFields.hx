package thx.macro;

#if (neko || macro)
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import thx.Arrays;
/**
Extension methods to work with class fields at macro time.
**/
class MacroFields {
/**
Returns true if the `field` has the `public` qualifier.
**/
  public static function isPublic(field : Field) {
    for(access in field.access) switch access {
      case APublic: return true;
      case _:
    }
    return false;
  }

/**
Returns true if the `field` has the `static` qualifier.
**/
  public static function isStatic(field : Field) {
    for(access in field.access) switch access {
      case AStatic: return true;
      case _:
    }
    return false;
  }

/**
Returns true if the `field` has NOT the `static` qualifier.
**/
  public static function isInstance(field : Field) {
    for(access in field.access) switch access {
      case AStatic: return false;
      case _:
    }
    return true;
  }

/**
Returns true if the `field` is a method.
**/
  public static function isMethod(field : Field)
    return switch field.kind {
      case FFun(_): true;
      case _:    false;
    };

/**
Returns true if the `field` is a variable.
**/
  public static function isVar(field : Field)
    return switch field.kind {
      case FVar(_): true;
      case _:    false;
    };

/**
Returns true if the `field` is a property.
**/
  public static function isProperty(field : Field)
    return switch field.kind {
      case FProp(_): true;
      case _:    false;
    };

/**
Returns true if the `field` has a meta with the supplied `name`.
**/
  public static function hasMeta(field : Field, name : String) {
    var meta = field.meta;
    if(null == meta) return false;
    return Arrays.any(meta, function(entry) return entry.name == name);
  }

/**
Returns the type of `field`.
**/
  public static function getType(field : Field) : ComplexType
    return switch field.kind {
      case FVar(t, _): t;
      case FFun(f): TFunction(f.args.map(function(arg) return arg.type), f.ret);
      case FProp(_, _, t, _): t;
    };

/**
Extracts the first meta entry parameter for `name`. It returns `null` if it
does not exist.
*/
  public static function getFirstMetaParam(field : Field, name : String)
    return getMetaParams(field, name)[0];

/**
Returns the params as `Array<String>` of a meta with `name`. It always returns an array even if
no matches are found.
*/
  public static function getMetaParamsAsStrings(field : Field, name : String)
    return getMetaParams(field, name).map(ExprTools.toString);

/**
Returns the params of a meta with `name`. It always returns an array even if
no matches are found.
*/
  public static function getMetaParams(field : Field, name : String) {
    var entry = getMetaEntry(field, name);
    if(null == entry) return [];
    return entry.params;
  }
/**
Returns a `MetaEntry` with `name` if it exists or `null` otherwise.
*/
  public static function getMetaEntry(field : Field, name : String) {
    var meta = field.meta;
    if(null == meta) return null;
    return Arrays.find(meta, function(entry) return entry.name == name);
  }
}
#end
