package thx.core;

#if macro
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Context;
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

/**
It traverses a chain of dot/array identifiers and it returns the last value in the chain or null if any of the identifiers is not set.

```haxe
var o : { a : { b : { c : String }}} = null;
trace((o.a.b.c).opt()); // prints null
var o = { a : { b : { c : 'A' }}};
trace((o.a.b.c).opt()); // prints 'A'
```
**/
  macro public static function opt(expr : Expr) {
    var ids = [];
    function traverse(e : haxe.macro.Type.TypedExprDef) switch e {
      case TArray(a, e):
        traverse(a.expr);
        traverse(e.expr);
      case TConst(TThis):
        ids.push('this');
      case TConst(TInt(index)):
        ids.push('$index');
      case TLocal(o):
        ids.push(o.name);
      case TField(f, v):
        traverse(f.expr);
        switch v {
          case FAnon(id):
            ids.push(id.toString());
          case FInstance(_, n):
            ids.push(n.toString());
          case _:
            throw 'invalid expression $e';
        }
      case TParenthesis(p):
        traverse(p.expr);
      case _:
        throw 'invalid expression $e';
    }
    traverse(Context.typeExpr(expr).expr);
    var first = ids.shift(),
        buf   = '(function(_) { if(null == _) return null; ',
        path  = '_';
    for(id in ids) {
      if(thx.core.Ints.canParse(id)) {
        path = '$path[$id]';
      } else {
        path = path == '' ? id : '$path.$id';
      }
      buf += 'if(null == $path) return null; ';
    }
    buf += 'return $path; })($first)';
    return Context.parse(buf , expr.pos);
  }
}

/* TODO:
11:49:51  Simn:  You could Context.typeExpr it I guess.
11:50:00  Simn:  And check if that returns something harmless.
*/
