package thx.macro;

#if (neko || macro)
import haxe.macro.Context;
import haxe.macro.Expr;

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
}
#end