package thx.core;

abstract QueryString(Map<String>) {
  public static var separator = ";";

  @:from public static function parse(s : String) : QueryString {

  }

  public function withSeparator(sep : String) {

  }

  @:to inline public function toString()
    return withSeparator(separator);
}