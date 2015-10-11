package thx;

using thx.Arrays;
using thx.Strings;

/**
`Path` represents a pointer to a directory or file in a filesystem.

It supports both win32 and (U)nix style of path and tries to guess
the correct type when parsing a string. If the guessing is not possible
it assumes the Nix style by default.

Path can be conveted from/to styles using `toWin32` and `toNix`.

Path are immutable objects and can combined using the `/` operator.

Ex.
```haxe
var p : Path = "/usr/local",
    dir = "haxe";
trace(p / dir); // prints "/usr/local/haxe"
```
*/
abstract Path(Array<String>) {
  inline public static var nixSeparator : String = "/";
  inline public static var win32Separator : String = "\\";

  public static function isValidNix(path : Path) : Bool
    return path.path.any(function(_) return !_.contains("/"));

  public static function isValidWin32(path : Path) : Bool
    return path.path.any(function(_) return !(~/[<>:\/\|?*"]/g).match(_));

  public static function normalizeNix(path : Path, ?replacement = "_")
    return path.map(function(_) return _.replace("/", replacement));

  public static function normalizeWin32(path : Path, ?replacement = "_")
    return path.map(function(_) return (~/[<>:"\/\|?*]/g).replace(_, replacement));

/**
Creates an instance of `Path` from a string.
*/
  @:from
  public static function fromString(s : String) : Path {
    if(s.contains(win32Separator)) {
      var re = ~/^([a-z]+[:][\\])/i;
      if(re.match(s)) {
        return create(
          re.matched(1),
          re.matchedRight().split(win32Separator),
          win32Separator);
      } else {
        return create("", s.split(win32Separator), win32Separator);
      }
    } else {
      return create(
        s.startsWith(nixSeparator) ? nixSeparator : "",
        s.split(nixSeparator),
        nixSeparator);
    }
  }

  public var path(get, never) : Array<String>;
  public var root(get, never) : String;
  public var sep(get, never) : String;

  #if java inline #end //WHY????
  public static function resolve(path : Array<String>, isAbsolute : Bool) {
    // removes .
    path = path.compact().filter(function(s) return s != ".");
    // simplify ..
    return path.reduce(function(acc : Array<String>, s : String) {
      if(s == ".." && acc.length > 0 && acc.last() != "..") {
        return acc.slice(0, acc.length-1);
      } else if(s == ".." && isAbsolute) {
        return acc;
      } else {
        return acc.concat([s]);
      }
    }, []);
  }

  inline public static function create(root : String, path : Array<String>, sep : String) : Path
    return new Path([sep, root].concat(resolve(path, root != "")));

  inline public static function raw(parts : Array<String>)
    return new Path(parts);

  inline function new(parts : Array<String>) : Void
    this = parts;

  public function asAbsolute(?root = "C:\\")
    return create(
      sep == nixSeparator ? nixSeparator : root,
      path,
      sep
    );

  inline public function asRelative()
    return create("", path, sep);

  public function normalize()
    return isWin32() ? normalizeWin32(get_self()) : normalizeNix(get_self());

  inline public function isAbsolute()
    return root != "";

  inline public function isRelative()
    return root == "";

  public function isRoot()
    return isAbsolute() && path.length == 0;

  inline public function isNix()
    return sep == nixSeparator;

  inline public function isWin32()
    return sep == win32Separator;

  public function isValid()
    return isWin32() ? isValidWin32(get_self()) : isValidNix(get_self());

  public function noext() : String {
    var e = ext();
    if(e == "")
      return base();
    else
      return base('.$e');
  }

  public function base(?end : String) : String {
    if(path.length == 0)
      return '';
    var name = path.last();
    if(null != end && name.endsWith(end))
      return name.substring(0, name.length - end.length);
    return name;
  }

  public function ext() : String {
    if(path.length == 0)
      return '';
    return path.last().afterLast(".");
  }

  public function dir() : String
    return up().toString();

  public function map(handler : String -> String) : Path
    return create(
      root,
      path.map(handler),
      sep
    );

  public function hierarchy() : Array<Path> {
    var base = [];
    return path.reduce(function(acc : Array<Path>, cur : String) {
      base.push(cur);
      acc.push(create(root, base.copy(), sep));
      return acc;
    }, []);
  }

  public function iterator() : Iterator<Path>
    return hierarchy().iterator();

  public function pathTo(destination : Path) : Path {
    return switch [isAbsolute(), destination.isAbsolute()] {
      case [true, true] if(root == destination.root):
        var opath = destination.path,
            common = path.commonsFromStart(opath);
        return create("",
          path.slice(0, path.length - common.length)
            .map(function(_) return '..')
            .concat(opath.slice(common.length)),
          sep);
      case [true, true]   | [false, true]:
        return destination;
      case [false, false] | [true, false]:
        return join(destination);
    }
  }

  public function sibling(path : Path)
    return up().join(path);

  public function toNix() : Path
    return isNix() ?
      get_self() :
      new Path([nixSeparator, isAbsolute() ? nixSeparator : ""].concat(path));

  public function toWin32(?root : String = "C:\\") : Path
    return isWin32() ?
      get_self() :
      new Path([win32Separator, isAbsolute() ? root : ""].concat(path));

  public function up(?n = 1) : Path
    return isRoot() ?
      get_self() :
      new Path([sep, root].concat(this.slice(2, this.length-n)));

  public function withExt(newextension : String) {
    var oext = ext();
    if(oext.length > 0)
      oext = '.$oext';
    if(newextension.substring(0, 1) == ".")
      newextension = newextension.substring(1);
    return sibling('${base(oext)}.$newextension');
  }

  @:op(A/B) public function join(other : Path) : Path {
    if(other.isAbsolute())
      return other;
    return create(root, path.concat(other.path), sep);
  }

  @:to public function toString()
    return !isAbsolute() && path.length == 0 ? '.' : root + path.join(sep);

  inline function get_path() : Array<String>
    return this.slice(2);

  inline function get_root() : String
    return this[1];

  inline function get_sep() : String
    return this[0];

  inline function get_self() : Path
    return cast this;
}
