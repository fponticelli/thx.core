package thx.fp;

import haxe.macro.Expr;
import haxe.macro.Context;
using Lambda;

class Monad {
/**
Simple "do notation" macro for chaining a series of monadic operations for a type that has a `flatMap` function.

The `flatMap` function can be a non-static member of the type or an extension method for the type.  For extension
methods, you must be `using` the class that has the extension method in the scope where `Do` is used.

Inspired by: https://github.com/m22spencer/Mdo

Example:
```
import thx.fp.Monad.Do;

var x : Int = 0;
var result : Either<String, Int> = Do(
  a <= Right(1),                // bind
  (b : Int) <= Right(a + 2),    // explicitly typed bind
  var c = b + 3,                // non-monadic assignment
  var d : Int = c + 4,          // non-monadic, explicitly typed assigned
  _ <= { x = 100; Right(5); },  // ignore result (can be used for side effects or binds for which you don't need the result)
  Right(a + b + c + d)
);
Assert.same(Right(20), result);
Assert.same(100, x);
```
**/
  macro public static function Do(exprs : Array<Expr>) : Expr {
    if (exprs.length == 0) {
      Context.error("thx.fp.Monad.Do expects at least one expression argument", Context.currentPos());
    }

    var lastExpr = exprs.pop();
    exprs.reverse();

    return exprs.fold(function(a,b) {
      return switch(a) {
        // x <= monadExpr
        case macro $i{bind} <= $val:
          macro @:pos(val.pos) $val.flatMap(function($bind) return $b);

        // (x : Type) <= monadExpr
        case macro ($i{bind}:$type) <= $val:
          macro @:pos(val.pos) $val.flatMap(function($bind:$type) return $b);

        // var x = expr
        case macro var $name = $val:
          macro { $a; $b; };

        // var x : Type = expr
        case macro var $name:$type = $val:
          macro { $a; $b; };

        // invalid
        case macro $inv <= $_:
          Context.error("thx.fp.Monad.Do: invalid <= binding - left side must be identifier or _", inv.pos);

        // _ <= monadExpr
        case _:
          macro @:pos(a.pos) $a.flatMap(function(_) return $b);
      }
    }, macro @:pos(lastExpr.pos) $lastExpr);
  }
}
