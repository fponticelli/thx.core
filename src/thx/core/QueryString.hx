package thx.core;

import thx.core.Tuple;

abstract QueryString(Array<Tuple2<String, String>>) {
  public static var separator = ";";

  public static function parseWithSeparator(separator : String) {

  }

  @:from public static function parse(s : String) : QueryString {
    return null;
  }

  public function withSeparator(sep : String) {

  }

  @:to inline public function toString()
    return withSeparator(separator);
}
