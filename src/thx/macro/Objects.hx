package thx.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;

using thx.Arrays;

class Objects {
  static function overwriteFieldsInType(fields : Array<Field>, type : Array<Field>)
    fields.each(function (field) {
      type.extract(function (fvar) return fvar.name == field.name);
      type.push(field);
    });

  #if macro
  static function getTypeFromPath(name : String, pack : Array<String>, ?sub : String, params) {
    var parts = pack.concat([name]);
    if (null != sub)
      parts.push(sub);

    if (sub == "Null") {
      switch params[0] {
        case TPType(TPath({name : name, pack : pack, sub : sub, params : params})):
          return getTypeFromPath(name, pack, sub, params);
        case _:
          Context.error('Expected nullable to have TPType', Context.currentPos());
      }
    }
    var qn = parts.join('.');
    return TypeTools.toComplexType(TypeTools.follow(Context.getType(qn)));
  }

  public static function shallowMergeImpl(to : ExprOf<{}>, from : ExprOf<{}>) {
    var typeTo = TypeTools.toComplexType(Context.typeof(to));
    var typeFrom = TypeTools.toComplexType(Context.typeof(from));
    var arr = [];

    switch typeTo {
      case TAnonymous(fields):
        arr = arr.concat(fields);
      case TPath({name : name, pack : pack, sub : sub, params : params}):
        var type = getTypeFromPath(name, pack, sub, params);

        switch type {
          case TAnonymous(fields):
            arr = arr.concat(fields);
          case _:
            Context.error('Field `to` does not refer to an anonymous object', to.pos);
        }

      case _:
        Context.error('Field `to` needs to be an anonymous object', to.pos);
    }

    switch typeFrom {
      case TAnonymous(fields):
        overwriteFieldsInType(fields, arr);
      case TPath({name : name, pack : pack, sub : sub, params : params}):
        var type = getTypeFromPath(name, pack, sub, params);
        switch type {
          case TAnonymous(fields):
            overwriteFieldsInType(fields, arr);
          case _:
            Context.error('Field `from` does not refer to an anonymous object', from.pos);
        }
      case _:
        Context.error('Field `from` needs to be an anonymous object', from.pos);
    }

    var t : ComplexType = TAnonymous(arr);
    return macro (cast thx.Objects.shallowCombine($e{to}, $e{from}) : $t);
  }
  #end

  macro public static function shallowMerge(to : ExprOf<{}>, from : ExprOf<{}>) {
    return shallowMergeImpl(to, from);
  }

  // TODO: macro-time deepMergeImpl/deepMerge (with properly-typed result)
}
