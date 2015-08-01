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

/**
It returns all the directories that contain (or might contain) modules for the
specified `pack`. The search is made by default in `Context.getClassPath`, but
can be restricted to a certain list of `paths`.
*/
  public static function getPackageDirectories(pack : String, ?paths : Array<String>) : Array<String> {
    var cps = null == paths ? Context.getClassPath() : paths,
        path : Path = pack.split(".").join("/"),
        results : Array<String> = [];
    for(cp in cps) {
      var fp = ((cp : Path) / path).toString();
      if(sys.FileSystem.exists(fp) && sys.FileSystem.isDirectory(fp))
        results.push(fp);
    }
    return results;
  }

/**
Given a `pack`age path, it returns all the modules contained in there.
The returned values have a fully qualified identifier for the module (it
includes the package and the module name).

The search is made by default in `Context.getClassPath`, but
can be restricted to a certain list of `paths`.
*/
  public static function getPackageModules(pack : String, ?paths : Array<String>) : Array<String> {
    var dirs = getPackageDirectories(pack, paths),
        results = [];
    for(dir in dirs) {
      var r = sys.FileSystem.readDirectory(dir);
      for(file in r) {
        if(file.endsWith(".hx")) {
          results.push(pack + "." + file.substring(0, file.length-3));
        }
      }
    }
    return results;
  }
}
#end
