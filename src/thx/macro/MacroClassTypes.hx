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

}
#end
