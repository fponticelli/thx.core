package thx;

import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import haxe.macro.Context;

class Make {
  macro public static function constructor(expr : ExprOf<{}>) {
    var items = switch expr.expr {
      case EObjectDecl(fields):
        fields.map(extractFieldFromLiteral);
      case EConst(CIdent(type)):
        switch Context.getType(type) {
          case TType(t, p):
            switch t.get().type {
              case TAnonymous(anonym):
                anonym.get().fields.map(extractFieldAnonymous);
              case _:
                Context.error("Make.constructor can only take a reference to a typedef that represent an object literal", Context.currentPos()); [];
            }
          case _:
            Context.error("Make.constructor can only take a reference to a typedef that represent an object literal", Context.currentPos()); [];
        }
      case other:
        Context.error("Make.constructor only accepts anonymous objects with type names as values or a reference to a typedef", Context.currentPos()); [];
    }
    var args   = items.map(function(item) return '${item.field} : ${item.type}'),
        assign = items.map(function(item) return '${item.field} : ${item.field}'),
        fun    = 'function constructor(${args.join(", ")}) return {\n  ${assign.join(",\n")}\n}';
    return Context.parse(fun, Context.currentPos());
  }

#if macro
  static function extractFieldFromLiteral(field) {
    switch field.expr.expr {
      case EConst(CIdent(type)):
        return { field : field.field, type : type };
      case _:
        Context.error("Make.constructor fields can only have values that represent types", Context.currentPos());
        return null;
    }
  }

  static function extractFieldAnonymous(field : ClassField) {
    return { field : field.name, type : TypeTools.toString(field.type) };
  }
#end
}
