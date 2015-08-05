package thx.macro;

#if (neko || macro)
import thx.Arrays;
import haxe.macro.TypeTools;
import haxe.macro.Type.ClassType;
/**
Extension methods to work with `ClassType`s at macro time.
**/
class MacroClassTypes {
/**
It returns an array of types in string format representing the inheritance chain of the
passed `ClassType`.
**/
  public static function inheritance(cls : haxe.macro.Type.ClassType) : Array<String> {
    var types = [cls.pack.concat([cls.name]).join(".")],
      parent = null == cls.superClass ? null : inheritance(cls.superClass.t.get());
    if(null != parent)
      types = types.concat(parent);
    return types;
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
}
#end
