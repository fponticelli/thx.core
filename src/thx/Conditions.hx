package thx;
#if macro
import haxe.macro.Expr;
import haxe.macro.ExprTools;
using haxe.macro.ExprTools;
#end

/**
Helper methods to generate conditional statements in a more
declarative way.
*/
class Conditions {
  public macro static function when(cond:Expr,then:Expr)
    return macro if($cond) { $then; };

  public macro static function unless(cond:Expr,then:Expr)
    return macro if(!$cond) { $then; };

  public macro static function and(cond1:Expr,cond2:Expr)
    return macro ($cond1 && $cond2);

  public macro static function or(cond1:Expr,cond2:Expr)
    return macro ($cond1 || $cond2);

  public macro static function not(cond:Expr)
    return macro !($cond);
}
