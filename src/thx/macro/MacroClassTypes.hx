package thx.macro;

#if (neko || macro)
import haxe.macro.TypeTools;
import haxe.macro.Type.ClassType;
/**
Extension methods to work with types at macro time.
**/
class MacroClassTypes {
/**
It returns an array of types in string format representing the inheritance chain of the
passed `ClassType`.
**/
  public static function inheritance(cls : haxe.macro.Type.ClassType) : Array<String> {
    var types = [cls.pack.concat([cls.name]).join(".")],
      parent = null == cls.superClass ? null : classInheritance(cls.superClass.t.get());
    if(null != parent)
      types = types.concat(parent);
    return types;
  }
}
#end
