package thx.macro;

#if (neko || macro)
import haxe.macro.Expr;
/**
Extension methods to work with class fields at macro time.
**/
class MacroFields {
/**
Returns true if the field has the `public` qualifier.
**/
  public static function isPublic(field : Field) {
    for(access in field.access) switch access {
      case APublic: return true;
      case _:
    }
    return false;
  }

/**
Returns true if the field has the `static` qualifier.
**/
  public static function isStatic(field : Field) {
    for(access in field.access) switch access {
      case AStatic: return true;
      case _:
    }
    return false;
  }

/**
Returns true if the field is a method.
**/
  public static function isMethod(field : Field)
    return switch field.kind {
      case FFun(_): true;
      case _:    false;
    };
}
#end