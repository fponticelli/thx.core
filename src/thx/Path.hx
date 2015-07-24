package thx;

using thx.Arrays;
using thx.Functions;
using thx.Strings;

abstract Path(PathType) from PathType to PathType {
  public static var nixSeparator(default, null) : String = "/";
  public static var win32Separator(default, null) : String = "\\";

  public var root(get, never) : String;
  public var sep(get, never) : String;

  static var WIN32_ROOT = ~/^([a-z]+[:])/i;
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
      } else {
        return acc.concat([s]);
      }
    }, []);
    this = { root : root, path : path, sep : sep };
  }

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

  public function to(destination : Path) : Path
    return this; // TODO

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

  @:op(A/B) public function join(other : Path) : Path
    return this;

  @:op(A/B) public function joinString(other : String) : Path
    return join(other);

  @:to public function toString()
    return !isAbsolute() && this.path.length == 0 ? '.' : this.root + this.path.join(sep);

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

 * add isValid
 * add normalize (removes/replaces invalid characters)
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
