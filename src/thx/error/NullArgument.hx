package thx.error;

import haxe.PosInfos;

/**
`NullArgument` is used to detect if arguments of methods are `null` or empty values.

It should not be used with its contructor but using the static extensions:

```haxe
public function capitalize(text : String) {
  NullArgument.throwIfNull(text);
  // ...
}
```
*/
class NullArgument extends thx.Error {
  public function new(message : String, ?posInfo : PosInfos)
    super(message, posInfo);

/**
Throws an exception of type `NullArgument` if the passed identifier (usually
a function argument name) is `null`.
*/
  macro public static function throwIfNull<T>(expr : ExprOf<Null<T>>) {
    var name = switch expr.expr {
      case EMeta({name:':this'},{expr:EConst(CIdent(s))}): s;
      case EConst(CIdent(s)): s;
      case _: haxe.macro.Context.error("argument must be an identifier", expr.pos);
    };

    return macro if(null == $e{expr}) throw new thx.error.NullArgument('argument "$name" cannot be null');
  }

/**
Like `throwIfNull` but also throws an exception if the passed argument is empty.

The concept of emptiness applies to String, Array, Iterator and Iterable.
*/

  macro public static function throwIfEmpty(expr : haxe.macro.Expr) {
    var n = switch expr.expr {
      case EMeta({name:':this'},{expr:EConst(CIdent(s))}): s;
      case EConst(CIdent(s)): s;
      case _: haxe.macro.Context.error("argument must be an identifier", expr.pos);
    };

    switch haxe.macro.Context.typeof(expr) {
      case TInst(_.toString() => "Array", _):
        return macro
          if(null == $e{expr})
            throw new thx.error.NullArgument('Array argument "$n" cannot be null')
          else if($e{expr}.length == 0)
            throw new thx.error.NullArgument('Array argument "$n" cannot be empty');
      case TInst(_.toString() => "String", _):
        return macro
          if(null == $e{expr})
            throw new thx.error.NullArgument('String argument "$n" cannot be null')
          else if($e{expr} == "")
            throw new thx.error.NullArgument('String argument "$n" cannot be empty');
      case TType(_.toString() => "Iterator", _):
        return macro {
          var it = $e{expr};
          if(null == it)
            throw new thx.error.NullArgument('Iterator argument "$n" cannot be null')
          else if(!it.hasNext())
            throw new thx.error.NullArgument('Iterator argument "$n" cannot be empty');
        }
      case TType(_.toString() => "Iterable", _):
        return macro {
          var it = $e{expr};
          if(null == it)
            throw new thx.error.NullArgument('Iterable argument "$n" cannot be null')
          else if(!it.iterator().hasNext())
            throw new thx.error.NullArgument('Iterable argument "$n" cannot be empty');
        }
      case _:
        return haxe.macro.Context.error("argument type must be a String, an Array, an Iterator or an Iterable", expr.pos);
    }
  }
}