package thx.core.error;

import haxe.PosInfos;

class NullArgument extends thx.core.Error {
  public function new(message : String, ?posInfo : PosInfos)
    super(message, posInfo);

  macro public static function throwIfNull<T>(expr : ExprOf<Null<T>>) {
    var name = switch expr.expr {
      case EMeta({name:':this'},{expr:EConst(CIdent(s))}): s;
      case EConst(CIdent(s)): s;
      case _: haxe.macro.Context.error("argument must be an identifier", expr.pos);
    };

    return macro if(null == $e{expr}) throw new thx.core.error.NullArgument('argument "$name" cannot be null');
  }

  macro public static function throwIfEmpty(expr : haxe.macro.Expr) {
    var name = switch expr.expr {
      case EMeta({name:':this'},{expr:EConst(CIdent(s))}): s;
      case EConst(CIdent(s)): s;
      case _: haxe.macro.Context.error("argument must be an identifier", expr.pos);
    };

    switch haxe.macro.Context.typeof(expr) {
      case TInst(c, _) if(c.toString() == "Array"):
        return macro
          if(null == $e{expr})
            throw new thx.core.error.NullArgument('Array argument "$name" cannot be null')
          else if($e{expr}.length == 0)
            throw new thx.core.error.NullArgument('Array argument "$name" cannot be empty');
      case TInst(c, _) if(c.toString() == "String"):
        return macro
          if(null == $e{expr})
            throw new thx.core.error.NullArgument('String argument "$name" cannot be null')
          else if($e{expr} == "")
            throw new thx.core.error.NullArgument('String argument "$name" cannot be empty');
      case TType(c, _) if(c.toString() == "Iterator"):
        return macro {
          var it = $e{expr};
          if(null == it)
            throw new thx.core.error.NullArgument('Iterator argument "$name" cannot be null')
          else if(!it.hasNext())
            throw new thx.core.error.NullArgument('Iterator argument "$name" cannot be empty');
        }
      case TType(c, _) if(c.toString() == "Iterable"):
        return macro {
          var it = $e{expr};
          if(null == it)
            throw new thx.core.error.NullArgument('Iterable argument "$name" cannot be null')
          else if(!it.iterator().hasNext())
            throw new thx.core.error.NullArgument('Iterable argument "$name" cannot be empty');
        }
      case _:
        return haxe.macro.Context.error("argument type must be a String, an Array, an Iterator or an Iterable", expr.pos);
    }
  }
}