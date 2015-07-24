package thx;

abstract Path(PathType) from PathType to PathType {
  public static var posixSeparator(default, null) : String = "/";
  public static var win32Separator(default, null) : String = "\\";

  public var root(get, never) : String;
  public var sep(get, never) : String;

  @:from public static function fromString(s : String) : Path {
    return new Path("", [], posixSeparator);
  }

  inline function new(root : String, path : Array<String>, sep : String)
    this = {
      root : root,
      path : path,
      sep : sep
    };

  public function isAbsolute()
    return this.root != "";

  public function isRelative()
    return this.root == "";

  public function isRoot()
    return isAbsolute() && this.path.length == 0;

  public function isPosix()
    return false;

  public function isWin32()
    return false;

  public function base(?end : String) : String
    return ""; // TODO

  public function ext() : String
    return ""; // TODO

  public function dir() : String
    return ""; // TODO

  public function to(destination : Path) : Path
    return this; // TODO

  public function toPosix() : Path
    return isPosix() ? this : {
      root : isRoot() ? "/" : "",
      path : this.path.copy(),
      sep  : posixSeparator
    };

  public function toWin32(?root : String = "C:") : Path
    return isWin32() ? this : {
      root : isRoot() ? root : "",
      path : this.path.copy(),
      sep  : win32Separator
    };

  public function up() : Path
    return isRoot() ? this : {
      root : this.root,
      path : this.path.slice(0, -1),
      sep  : this.sep
    };

  @:op(A/B) public function join(other : Path) : Path
    return this;

  @:op(A/B) public function joinString(other : String) : Path
    return this;

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
