package thx;

import haxe.macro.Expr;
import haxe.macro.Context;

class Make {
  macro public static function constructor(expr : ExprOf<{}>) {
    switch expr.expr {
      case EObjectDecl(fields):
        var items  = fields.map(extractField),
            args   = items.map(function(item) return '${item.field} : ${item.type}'),
            assign = items.map(function(item) return '${item.field} : ${item.field}'),
            fun    = 'function constructor(${args.join(", ")}) return {\n  ${assign.join(",\n")}\n}';
        return Context.parse(fun, Context.currentPos());
      case _:
        Context.error("Make.constructor only accepts anonymous objects with type names as values", Context.currentPos());
    }
    return macro null;
  }

#if macro
  static function extractField(field) {
    switch field.expr.expr {
      case EConst(CIdent(type)):
        return { field : field.field, type : type };
      case _:
        Context.error("Make.constructor fields can only have values that represent types", Context.currentPos());
        return null;
    }
  }
#end
}
