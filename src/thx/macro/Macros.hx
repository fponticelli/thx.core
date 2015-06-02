package thx.macro;

#if (neko || macro)
import haxe.macro.Context;
import haxe.macro.Expr;
using StringTools;
using haxe.macro.ExprTools;
/**
Helper methods to use inside macro context.
**/
class Macros {
/**
Given a fully qualified path to a type, it returns the path to the file module
containing that type.

If the type is not found, an exception is thrown.
**/
  public static function getModulePath(type : String) : String
    return switch Context.getType(type) {
      case TInst(t, _): Context.getPosInfos(t.get().pos).file;
      case _: throw 'invalid type $type';
    };

/**
Given a fully qualified path to a type, it returns the path to the directory
containing the module that contains that type.

If the type is not found, an exception is thrown.
**/
  public static function getModuleDirectory(type : String) : String
    return getModulePath(type).split("/").slice(0, -1).join("/");

/**
Given a relative file path, it returns the absolute path to that file if it is encountered
within any of the available class path.

It returns null if the file is not found in the class paths.
**/
  public static function getFileInClassPath(file : String) : String {
    for(path in Context.getClassPath()) {
      var fullpath = path+file;
      if(sys.FileSystem.exists(fullpath) && !sys.FileSystem.isDirectory(fullpath))
        return fullpath;
    }
    return null;
  }
/**
Given an expression expr, a String symbol and an expression withExpr, it returns a new expression
with the substituion of symbol with witnExpr expression.
**/
  public static function replaceSymbol(expr:Expr,symbol:String,withExpr:Expr):Expr {
    return switch expr {
      case macro $i{name} if (name.startsWith(symbol)):
        return withExpr;
      default: return expr.map(function(expr) {
        return replaceSymbol(expr,symbol,withExpr);
      });
    }
  }

}
#end
