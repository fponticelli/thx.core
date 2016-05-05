package thx;

#if macro
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Context;
import haxe.macro.TypedExprTools;
import thx.Arrays;
import thx.Ints;
#end

/**
`Nulls` provides extension methods that help to deal with nullable values.

Note that the parenthesis wrap the entire chain of identifiers. That means that a null check will be performed for each identifier in the chain.

Identifiers can also be getters and methods (both are invoked only once and only if the check reaches them). `Python` seems to struggle with some native methods like methods on strings.
**/
class Nulls {
/**
Assigns the value `alt` to `value` if found `null`;
**/
  macro public static function ensure<T>(value : ExprOf<Null<T>>, alt : ExprOf<T>)
    return try macro if(null == $e{value}) $e{value} = $e{alt};

/**
`exists` is synonymous of `notNull`.
**/
  macro public static function exists(value : Expr)
    return macro ($e{Nulls.opt(value)} != null);

/**
Executes `expr` only if `value` is a non-null value. Inside `expr` the `value` can be
referenced using the special var `_`. It is also possible to provide an alternative value `alt` in
case a non null value is desired.

```haxe
myvalue.with(_.myMethod());
```
**/
  macro public static function with<TValue, TOut>(value : ExprOf<TValue>, expr : ExprOf<TOut>, ?alt : ExprOf<TOut>) : ExprOf<TOut>
    return macro (function(_) { return null == _ ? $e{alt} : $e{expr}; })($e{value});
/**
`isNull` checks if a chain of identifier is null at any point.
**/
  macro public static function isNull(value : Expr)
    return macro ($e{Nulls.opt(value)} == null);

/**
It traverses a chain of dot/array identifiers and it returns the last value in the chain or null if any of the identifiers is not set.

```haxe
var o : { a : { b : { c : String }}} = null;
trace((o.a.b.c).opt()); // prints null
var o = { a : { b : { c : 'A' }}};
trace((o.a.b.c).opt()); // prints 'A'
```
**/
  #if !macro macro #end public static function opt(value : Expr) {
    var ids  = [];
    function traverse(e : haxe.macro.Type.TypedExpr) switch e.expr {
      case TArray(a, e):
        traverse(a);
        var index = TypedExprTools.toString(e, true);
        ids.push('[$index]');
      case TConst(TThis):
        ids.push('this');
      case TConst(TInt(index)):
        ids.push('$index');
      case TLocal(o):
        ids.push(o.name);
      case TField(f, v):
        traverse(f);
        switch v {
          case FAnon(id):
            ids.push(id.toString());
          #if (haxe_ver >= "3.2")
          case FInstance(_, _, n):
          #else
          case FInstance(_, n):
          #end
            ids.push(n.toString());
          case _:
            throw 'invalid expression $e';
        }
      case TParenthesis(p):
        traverse(p);
      case TCall(e, el):
        traverse(e);
        var a = el.map(TypedExprTools.toString.bind(_, true)).join(", ");
        ids[ids.length - 1] += '($a)';
      case TBlock(_):
        if(Context.defined("python"))
          Context.error("Nulls.opt doesn't support some method calls on Python", value.pos);
        var s = TypedExprTools.toString(e, true);
        //trace(s);
        ids.push(s);
      case _:
        throw 'invalid expression $e';
    }

    traverse(Context.typeExpr(value));
    var first = ids.shift(),
        buf   = '(function(){\n  var _0 = $first;\n  if(null == _0) return null;';
    var path = "";
    for(i in 0...ids.length) {
      var id = ids[i];
      if(id.substring(0, 1) == '[') {
        path = id;
      } else {
        path = '.$id';
      }
      buf += '\n  var _${i+1}  = _$i$path;\n  if(null == _${i+1}) return null;';
    }
    buf += '\n  return _${ids.length};\n})()';
    // trace(buf);
    return Context.parse(buf , value.pos);
  }

/**
Like `opt` but allows an `alt` value that replaces a `null` occurrance.

```haxe
var s : String = null;
trace(s.or('b')); // prints 'b'
s = 'a';
trace(s.or('b')); // prints 'a'

// or more complex
var o : { a : { b : { c : String }}} = null;
trace((o.a.b.c).or("B")); // prints 'B'
var o = { a : { b : { c : 'A' }}};
trace((o.a.b.c).or("B")); // prints 'A'
```

Notice that the subject `value` must be a constant identifier (eg: fields, local variables, ...).
**/
  macro public static function or<T>(value : ExprOf<Null<T>>, alt : ExprOf<T>)
    return macro { var t = $e{Nulls.opt(value)}; t != null ? t : $e{alt}; };

/**
`notNull` is the negation of `isNull`.
**/
  macro public static function notNull(value : Expr)
    return macro ($e{Nulls.opt(value)} != null);
}
