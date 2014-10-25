package thx.core;

#if macro
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Context;
import haxe.macro.TypedExprTools;
import thx.core.Arrays;
import thx.core.Ints;
#end

/**
`Defaults` provides methods that help to deal with nullable values.
**/
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
    var ids  = [],
        salt = ExprTools.toString(alt);
    function traverse(e : haxe.macro.Type.TypedExpr) switch e.expr {
      case TArray(a, e):
        traverse(a);
        traverse(e);
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
          case FInstance(_, n):
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
      case _:
        throw 'invalid expression $e';
    }

    traverse(Context.typeExpr(value));
    var first = ids.shift(),
        temps = ['_0 = $first'].concat(Arrays.mapi(ids, function(_, i) return '_${i+1}')).join(', '),
        buf   = '{\n  function _() return $salt;\n  var ${temps};\n  if(null == _0) _();\n',
        path;
    for(i in 0...ids.length) {
      var id = ids[i];
      if(Ints.canParse(id)) {
        path = '[$id]';
      } else {
        path = '.$id';
      }
      buf += '  else if(null == (_${i+1} = _$i$path)) _();\n';
    }
    buf += '  else _${ids.length};\n}';
    return Context.parse(buf , value.pos);
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
  #if !macro macro #end public static function opt(value : Expr) {
    var ids  = [];
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
      case TCall(e, el):
        traverse(e.expr);
        var a = el.map(TypedExprTools.toString.bind(_, true)).join(", ");
        ids[ids.length - 1] += '($a)';
      case _:
        throw 'invalid expression $e';
    }

    traverse(Context.typeExpr(value).expr);
    var first = ids.shift(),
        temps = ['_0 = $first'].concat(Arrays.mapi(ids, function(_, i) return '_${i+1}')).join(', '),
        buf   = '{\n  var ${temps};\n  null == _0 ? null :',
        path;
    for(i in 0...ids.length) {
      var id = ids[i];
      if(Ints.canParse(id)) {
        path = '[$id]';
      } else {
        path = '.$id';
      }
      buf += '\n    (null == (_${i+1} = _$i$path) ? null :';
    }
    buf += ' _${ids.length}' + Strings.repeat(')', ids.length) + ';\n}';
    return Context.parse(buf , value.pos);
  }

  macro public static function isNull(value : Expr) {
    var e = Defaults.opt(value);
    return macro ($e{e} == null);
  }

  macro public static function notNull(value : Expr) {
    var e = Defaults.opt(value);
    return macro ($e{e} != null);
  }
}