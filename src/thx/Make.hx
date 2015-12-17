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
        thx.Arrays.mapi(fields, function(v, i) return extractFieldFromLiteral(v, i));
      case EConst(CIdent(type)):
        switch Context.getType(type) {
          case TType(t, p):
            var type = t.get(),
                meta = type.meta;
            switch type.type {
              case TAnonymous(anonym):
                var seqMeta = meta.extract(":sequence");
                var sequence = thx.Arrays.flatten(
                      seqMeta.map(function(meta) return meta.params.map(ExprTools.toString))
                    );
                anonym.get().fields.map(extractFieldAnonymous.bind(_, sequence));
              case _:
                Context.error("Make.constructor can only take a reference to a typedef that represent an object literal", Context.currentPos()); [];
            }
          case _:
            Context.error("Make.constructor can only take a reference to a typedef that represent an object literal", Context.currentPos()); [];
        }
      case other:
        Context.error("Make.constructor only accepts anonymous objects with type names as values or a reference to a typedef", Context.currentPos()); [];
    }
    items.sort(function(a, b) return thx.Floats.compare(a.weight, b.weight));
    var args   = items.map(function(item) return (item.optional ? "?" : "") + '${item.field} : ${item.type}'),
        assign = items.filter(function(item) return !item.optional).map(function(item) return '${item.field} : ${item.field}'),
        types  = items.map(function(item) return (item.optional ? "@:optional " : "") + 'var ${item.field} : ${item.type};'),
        type   = "{ " + types.join(" ") + " }",
        fun    = 'function constructor(${args.join(", ")}) {\n  var obj : $type = {\n    ${assign.join(",\n    ")}\n  };';
    fun += items.filter(function(item) return item.optional).map(function(item) return '\n  if(null != ${item.field}) obj.${item.field} = ${item.field};').join("");
    fun += "\n  return obj;\n}";
    return Context.parse(fun, Context.currentPos());
  }

#if macro
  static function extractFieldFromLiteral(field, weight : Float) {
    switch field.expr.expr {
      case EConst(CIdent(type)):
        return { field : field.field, type : type, weight : weight, optional : false };
      case _:
        Context.error("Make.constructor fields can only have values that represent types", Context.currentPos());
        return null;
    }
  }

  static function extractFieldAnonymous(field : ClassField, sequence : Array<String>) {
    var pos : Float = sequence.indexOf(field.name);
    var weights = thx.Arrays.flatten(field.meta.extract(":weight").map(function(meta) { return meta.params; })).map(ExprTools.toString);
    if(weights.length > 0)
      pos = Std.parseFloat(weights[0]);
    return { field : field.name, type : TypeTools.toString(field.type), weight : pos, optional : field.meta.has(":optional") };
  }
#end
}
