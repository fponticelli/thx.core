package thx.core;

#if macro
import haxe.macro.Expr;
import haxe.macro.ExprTools;
#end

class Defaults {
/**
The method can provide an alternative value `alt` in case `value` is `null`.

```haxe
var s : String = null;
trace(s.or('b')); // prints 'b'
s = 'a';
trace(s.or('b')); // prints 'a'
```

Notice that the subject `value` must be a constant identifier (eg: fields, local variables, ...).
**/
  macro public static function or<T>(value : ExprOf<Null<T>>, alt : ExprOf<T>) {
    switch value.expr {
      case EMeta({name:':this'},{expr:EConst(CIdent(_))}),
           EField({expr:EConst(CIdent(_))}, _),
           EConst(CIdent(_)):
        return macro (function(t) return null == t ? $alt : t)($value);
      case _:
        trace(value);
        throw '"or" method can only be used on constant identifiers (eg: fields, local variables, ...)';
    }
  }
}

/* TODO:
11:49:51  Simn:  You could Context.typeExpr it I guess. 
11:50:00  Simn:  And check if that returns something harmless. 
*/
