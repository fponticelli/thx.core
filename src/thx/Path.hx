package thx;

using thx.Arrays;
using thx.Functions;
using thx.Strings;

abstract Path(PathType) from PathType to PathType {
  public static var nixSeparator(default, null) : String = "/";
  public static var win32Separator(default, null) : String = "\\";

  static var zero = String.fromCharCode(0);
  public static function isValidNix(path : Path) : Bool
    return path.get_path().any.fn(!_.contains("/") && !_.contains(zero));

  static var WIN32_CHARS = ~/[<>:"\/\|?*\0]/g;
  public static function isValidWin32(path : Path) : Bool
    return path.get_path().any.fn(!WIN32_CHARS.match(_));

  public static function normalizeNix(path : Path, ?replacement = "_")
    return path.map.fn(_.replace("/", replacement).replace(zero, ""));

  public static function normalizeWin32(path : Path, ?replacement = "_")
    return path.map.fn(WIN32_CHARS.replace(_, replacement));

  public var root(get, never) : String;
  public var sep(get, never) : String;

  static var WIN32_ROOT = ~/^([a-z]+[:][\\])/i;
  @:from public static function fromString(s : String) : Path {
    if(s.contains(win32Separator)) {
      if(WIN32_ROOT.match(s)) {
        return new Path(
          WIN32_ROOT.matched(1),
          WIN32_ROOT.matchedRight().split(win32Separator),
          win32Separator);
      } else {
        return new Path("", s.split(win32Separator), win32Separator);
      }
    }
    return new Path(
      s.startsWith(nixSeparator) ? nixSeparator : "",
      s.split(nixSeparator),
      nixSeparator);
  }

  function new(root : String, path : Array<String>, sep : String) {
    path = path.compact().filter.fn(_ != ".");
    path = path.reduce(function(acc : Array<String>, s : String) {
      if(s == ".." && acc.length > 0 && acc.last() != "..") {
        return acc.slice(0, -1);
      } else if(s == ".." && root != "") {
        return acc;
      } else {
        return acc.concat([s]);
      }
    }, []);
    this = { root : root, path : path, sep : sep };
  }

  public function asAbsolute(?root = "C:\\")
    return new Path(
      this.sep == nixSeparator ? nixSeparator : root,
      this.path,
      this.sep
    );

  public function asRelative()
    return new Path(
      "",
      this.path,
      this.sep
    );

  public function normalize()
    return isWin32() ? normalizeWin32(this) : normalizeNix(this);

  public function isAbsolute()
    return this.root != "";

  public function isRelative()
    return this.root == "";

  public function isRoot()
    return isAbsolute() && this.path.length == 0;

  public function isNix()
    return sep == nixSeparator;

  public function isWin32()
    return sep == win32Separator;

  public function isValid()
    return isWin32() ? isValidWin32(this) : isValidNix(this);

  public function base(?end : String) : String {
    if(this.path.length == 0)
      return '';
    var name = this.path.last();
    if(null != end && name.endsWith(end))
      return name.substring(0, name.length - end.length);
    return name;
  }

  public function ext() : String {
    if(this.path.length == 0)
      return '';
    return this.path.last().afterLast(".");
  }

  public function dir() : String
    return up().toString();

  public function map(handler : String -> String) : Path
    return new Path(
      this.root,
      this.path.map(handler),
      this.sep
    );

  public function pathTo(destination : Path) : Path {
    return switch [isAbsolute(), destination.isAbsolute()] {
      case [true, true] if(this.root == destination.root):
        var opath = destination.get_path(),
            common = this.path.commonsFromStart(opath);
        return new Path("",
          this.path.slice(0, this.path.length - common.length)
            .map(function(_) return '..')
            .concat(opath.slice(common.length)),
          this.sep);
      case [true, true]   | [false, true]:
        return destination;
      case [false, false] | [true, false]:
        return join(destination);
    }
  }

  public function sibling(path : Path)
    return up().join(path);

  public function toNix() : Path
    return isNix() ? this : {
      root : isAbsolute() ? nixSeparator : "",
      path : this.path.copy(),
      sep  : nixSeparator
    };

  public function toWin32(?root : String = "C:\\") : Path
    return isWin32() ? this : {
      root : isAbsolute() ? root : "",
      path : this.path.copy(),
      sep  : win32Separator
    };

  public function up(?n = 1) : Path
    return isRoot() ? this : {
      root : this.root,
      path : this.path.slice(0, -n),
      sep  : this.sep
    };

  @:op(A/B) public function join(other : Path) : Path {
    if(other.isAbsolute())
      return other;
    return new Path(this.root, this.path.concat(other.get_path()), this.sep);
  }

  @:op(A/B) inline public function joinString(other : String) : Path
    return join(other);

  @:to public function toString()
    return !isAbsolute() && this.path.length == 0 ? '.' : this.root + this.path.join(sep);

  function get_path() : Array<String>
    return this.path;

  function get_root() : String
    return this.root;

  function get_sep() : String
    return this.sep;
}

typedef PathType = {
  root : String,
  path : Array<String>,
  sep : String
}

/*
TODO:

 * withFile
 * sibbling
 * add isValid
 * add normalize (removes/replaces invalid characters)
 * add normalize to posix
win32 invalid char

The following reserved characters:
< (less than)
> (greater than)
: (colon)
" (double quote)
/ (forward slash)
\ (backslash)
| (vertical bar or pipe)
? (question mark)
* (asterisk)

CON, PRN, AUX, NUL, COM1, COM2, COM3, COM4, COM5, COM6, COM7, COM8, COM9, LPT1, LPT2, LPT3, LPT4, LPT5, LPT6, LPT7, LPT8, and LPT9.


linux invalid chars
/ \0

*/
