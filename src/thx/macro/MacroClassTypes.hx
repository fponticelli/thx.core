package thx.macro;

#if (neko || macro)
using thx.Arrays;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.TypeTools;
import haxe.macro.Type;
/**
Extension methods to work with `ClassType`s at macro time.
**/
class MacroClassTypes {
/**
It returns an array of types in string format representing the inheritance chain of the
passed `ClassType`.
**/
  public static function inheritance(cls : ClassType) : Array<ClassType> {
    var types = [cls],
        parent = null == cls.superClass ? null : inheritance(cls.superClass.t.get());
    if(null != parent)
      types = types.concat(parent);
    return types;
  }

  public static function inheritanceAsStrings(cls : ClassType) : Array<String> {
    return inheritance(cls).map(function(c) return toString(c));
  }

  public static function toComplexType(cls : ClassType) : ComplexType {
    return TypeTools.toComplexType(toType(cls));
  }

  public static function toType(cls : ClassType) : Type {
    var typeName = cls.pack.concat([cls.name]).join(".");
    return Context.getType(typeName);
  }

  public static function interfaces(cls : ClassType) : Array<ClassType> {
    var types = [],
        current = cls;
    while(null != current) {
      types = types.concat(current.interfaces.map(function(int) {
        return int.t.get();
      }));
      current = null == current.superClass ? null : current.superClass.t.get();
    }
    return types;
  }

  public static function interfacesAsStrings(cls : ClassType) : Array<String> {
    return interfaces(cls).map(function(c) return toString(c));
  }

  public static function classExtends(cls : ClassType, superCls : ClassType) : Bool {
    var match = toString(superCls),
        types = inheritanceAsStrings(cls);
    return types.contains(match);
  }

  public static function classImplements(cls : ClassType, interf : ClassType) : Bool {
    var match = toString(interf),
        types = interfacesAsStrings(cls);
    return types.contains(match);
  }

  public static function resolveClass(fullname : String) : ClassType {
    var t = haxe.macro.Context.getType(fullname);
    return switch t {
      case TInst(ref, _): ref.get();
      case _: haxe.macro.Context.error('$fullname is not a class or interface type: $t', haxe.macro.Context.currentPos());
    };
  }

  public static function toString(cls : ClassType) : String {
    return parts(cls).join(".");
  }

  public static function parts(cls : ClassType) : Array<String> {
    return cls.pack.concat([cls.name]);
  }

/**
Returns true if the `cls` is public.
**/
  public static function isPublic(cls : ClassType)
    return !cls.isPrivate;

/**
Returns true if the `cls` has a meta with the supplied `name`.
**/
  public static function hasMeta(cls : ClassType, name : String) {
    var meta = cls.meta.get();
    if(null == meta) return false;
    return Arrays.any(meta, function(entry) return entry.name == name);
  }

/**
Extracts the first meta entry parameter for `name`. It returns `null` if it
does not exist.
*/
  public static function getFirstMetaParam(cls : ClassType, name : String)
    return getMetaParams(cls, name)[0];

/**
Returns the params of a meta with `name`. It always returns an array even if
no matches are found.
*/
  public static function getMetaParams(cls : ClassType, name : String) {
    var entry = getMetaEntry(cls, name);
    if(null == entry) return [];
    return entry.params;
  }
/**
Returns a `MetaEntry` with `name` if it exists or `null` otherwise.
*/
  public static function getMetaEntry(cls : ClassType, name : String) {
    var meta = cls.meta.get();
    if(null == meta) return null;
    return Arrays.find(meta, function(entry) return entry.name == name);
  }

  public static function fieldsInHierarchy(cls : ClassType) : Array<ClassField> {
    var fields = [];
    while(true) {
      fields = fields.concat(cls.fields.get());
      if(null == cls.superClass)
        break;
      cls = cls.superClass.t.get();
    }
    return fields;
  }
}
#end
