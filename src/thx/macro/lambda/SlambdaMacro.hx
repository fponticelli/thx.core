package thx.macro.lambda;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
using haxe.macro.ExprTools;
using thx.Strings;
using thx.Ints;

/**
Lambda expressions. Standalone version: https://github.com/ciscoheat/slambda
**/
class SlambdaMacro {

  public static function f(fn : Expr, restArgs : Array<Expr>) {
    // If called through a static extension, fn contains the special "@:this this" expression:
    // http://haxe.org/manual/macro-limitations-static-extension.html
    var isExtension = fn.expr.match(EMeta({ name: ":this", params: _, pos: _}, {expr: EConst(CIdent("this")), pos: _}));

    if (isExtension) return {expr: ECall(fn, restArgs.map(createLambdaExpression.bind(true))), pos: fn.pos};

    // If not an extension, return only fn. Rest arguments won't make sense here.
    return restArgs.length == 0
      ? createLambdaExpression(false, fn)
      : untyped haxe.macro.Context.error('Rest arguments can only be used in static extensions.', restArgs[restArgs.length - 1].pos);
  }

  static var underscoreParam = ~/^_\d+$/;
  static function createLambdaExpression(isExtension : Bool, e : Expr) : Expr {

    // If no arrow syntax, detect underscore parameters.
    switch e.expr {
      case EBinop(OpArrow, _, _):
      case _:
        var counter = 0,
            useUnderscore = false,
            hasUnderscoreZero = false;
        function findParams(e2 : Expr) {
          switch e2.expr {
            // Detect in single-quoted strings
            case EConst(CString(s)) if(e2.toString().startsWith("'")):
              var s = haxe.macro.Format.format(e2);
              s.iter(findParams);
            case EConst(CIdent(v)) if ("_" == v):
              if(hasUnderscoreZero) Context.error('You need to use "_" or "_0" not both', e2.pos);
              useUnderscore = true;
              counter = counter.max(1);
            case EConst(CIdent(v)) if ("_0" == v):
              if(useUnderscore) Context.error('You need to use "_" or "_0" not both', e2.pos);
              hasUnderscoreZero = true;
              counter = counter.max(1);
            case EConst(CIdent(v)) if (underscoreParam.match(v)):
              counter = counter.max(Std.parseInt(v.substring(1))+1);
            case _:
              e2.iter(findParams);
          }
        }
        findParams(e);

        // If underscore parameters found, create an arrow syntax of the expression.
        // Sorted so the parameters are in the correct order in the function definition.
        var paramArray = [for(i in 0...counter) {
            expr : EConst(CIdent(i == 0 && useUnderscore ? "_" : '_$i')),
            pos : e.pos
          }];
        if(paramArray.length > 0) {
          var pos = e.pos;
          e = macro $a{paramArray} => $e;
          e.pos = pos;
        }
    }

    return switch e.expr {
      case EBinop(OpArrow, e1, e2):
        // Extract lambda arguments [a,b] => ...
        var lambdaArgs = switch e1.expr {
          case EConst(CIdent(v)): [v];
          case EArrayDecl(values) if(values.length > 0): [for (v in values) v.toString()];
          case _: untyped Context.error("Invalid lambda argument, use x => ... or [x,y] => ...", e1.pos);
        }
        var exp = macro return $e2;
        exp.pos = e.pos;
        {
          expr: EFunction(null, {
            ret: null,
            params: [],
            expr: exp,
            args: [for(arg in lambdaArgs) { name: arg, type: null, opt: true }]
          }),
          pos: e.pos
        };

      // If not an extension, it should return a non-lambda expression as a Void -> T function
      // to stay consistent with fn("x") <-> function() return "x".
      case _: isExtension ? e : macro function() return $e;
    }
  }
}
