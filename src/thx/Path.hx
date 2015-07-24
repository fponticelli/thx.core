package thx;

abstract Path(PathType) {
  public static var posixSeparator(default, null) : String = "/";
  public static var win32Separator(default, null) : String = "\\";

  public var sep(get, never) : String;

  @:from public static function fromString(s : String) : Path {
    return new Path(null, [], sep);
  }

  inline function new(root : String, path : Array<String>, sep : String)
    this = {
      root : root,
      path : path,
      sep : sep
    };

  public function isAbsolute()
    return false;

  public function isRelative()
    return false;

  public function isRoot()
    return false;

  public function isPosix()
    return false;

  public function isWin32()
    return false;

  public function base(?end : String) : String
    return null;

  public function ext() : String
    return null;

  public function dir() : String
    return null;

  public function to(destination : Path) : Path
    return null;

  public function toPosix() : Path
    return null;

  public function toWin32(?root : String = "C:") : Path
    return null;

  public function up() : Path
    return null;

  @:op(A+B)
  @:op(A/B) public function join(other : Path) : Path
    return null;

  @:to public function toString()
    return this.root + this.path.join(sep);

  function get_sep() : String
    return this.sep;
}

typedef PathType = {
  root : String,
  path : Array<String>,
  sep : String
}
