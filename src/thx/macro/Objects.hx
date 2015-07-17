package thx.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;

using thx.Arrays;

class Objects {

  static function overwriteFieldsInType(fields : Array<Field>, type : Array<Field>) {
    fields.map(function (field) {
      type.extract(function (fvar) return fvar.name == field.name);
      type.push(field);
    });
  }

  #if macro
  static function getTypeFromPath(name : String, pack : Array<String>, ?sub : String) {
    var parts = pack.concat([name]);
    if (null != sub)
      parts.push(sub);
    var qn = parts.join('.');
    return TypeTools.toComplexType(TypeTools.follow(Context.getType(qn)));
  }
  #end

/**
Copies the values from the fields of `from` to `to`. If `to` already contains those fields, then it replace
those values with the return value of the function `replacef`.

If not set, `replacef` always returns the value from the `from` object.
**/
  macro public static function merge(to : ExprOf<{}>, from : ExprOf<{}>, ?replacef : ExprOf<String -> Dynamic -> Dynamic -> Dynamic>) {
    var typeTo = TypeTools.toComplexType(Context.typeof(to));
    var typeFrom = TypeTools.toComplexType(Context.typeof(from));
    var arr = [];

    switch typeTo {
    case TAnonymous(fields):
        arr = arr.concat(fields);
      case TPath({name : name, pack : pack, sub : sub}):
        var type = getTypeFromPath(name, pack, sub);

        switch type {
          case TAnonymous(fields):
            arr = arr.concat(fields);
          case _:
            Context.error('Field `to` cannot be parsed for merge', to.pos);
        }

      case _:
        trace(typeTo);
        Context.error('Field `to` cannot use this expression for merge', to.pos);
    }

    switch typeFrom {
      case TAnonymous(fields):
        overwriteFieldsInType(fields, arr);
      case TPath({name : name, pack : pack, sub : sub}):
        var type = getTypeFromPath(name, pack, sub);
        switch type {
          case TAnonymous(fields):
            overwriteFieldsInType(fields, arr);
          case _:
            Context.error('Field `from` cannot be parsed for merge', from.pos);
        }
      case _:
        trace(typeFrom);
        Context.error('Field `from` cannot use this expression for merge', from.pos);
    }

    var t : ComplexType = TAnonymous(arr);
    return macro (cast thx.Objects.merge($e{to}, $e{from}, $e{replacef}) : $t);
  }
}
