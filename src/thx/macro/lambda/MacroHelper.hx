package thx.macro.lambda;
import thx.macro.Macros;

#if (neko || macro)
import haxe.macro.Context;
import haxe.macro.Expr;
using StringTools;
using haxe.macro.ExprTools;
#end

class MacroHelper {

  public static function replaceWildCard(expr:Expr):Expr {
    return switch expr {
      case macro $i{name} if (name == '_'): return macro __tmp0;
      case macro $i{name} if (name == '_0'): return macro __tmp0;
      case macro $i{name} if (name == '_1'): return macro __tmp1;
      case macro $i{name} if (name == '_2'): return macro __tmp2;
      case macro $i{name} if (name == '_3'): return macro __tmp3;
      case macro $i{name} if (name == '_4'): return macro __tmp4;
      default: return expr.map(function(expr) {
        return replaceWildCard(expr);
      });
    }
  }


  public static function countMaxWildcard(expr:Expr):Int {

    var cnt = 0;
    function traverse(expr:Expr) {
      return switch expr {
      case macro $i{name} if (name.startsWith("_")):
          if (Std.parseInt(name.substr(1)) > cnt ) {
            ++cnt; //= Std.parseInt(name.substr(1));
          }
        default: {
          expr.iter(function(expr) {
            traverse(expr);
          });
        }
      }
    };
    traverse(expr);
    return cnt;

  }

  public static function replace_() return Macros.replaceSymbol.bind(_,'_',macro __tmp0);
  public static function replace0() return Macros.replaceSymbol.bind(_,'_0',macro __tmp0);
  public static function replace1() return Macros.replaceSymbol.bind(_,'_1',macro __tmp1);
  public static function replace2() return Macros.replaceSymbol.bind(_,'_2',macro __tmp2);
  public static function replace3() return Macros.replaceSymbol.bind(_,'_3',macro __tmp3);
  public static function replace4() return Macros.replaceSymbol.bind(_,'_4',macro __tmp4);
}
