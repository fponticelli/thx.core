package thx.macro;

#if (neko || macro)
import haxe.macro.Expr;
import thx.Arrays;
/**
Extension methods to work with `Expr`s at macro time.
**/
class MacroExprs {
/**
Returns true if the `field` has the `public` qualifier.
**/
  public static function unwrapBlock(expr : Expr) : Array<Expr>
    return switch expr.expr {
      case EBlock(exprs): exprs;
      case _: [expr];
    };
}
#end
