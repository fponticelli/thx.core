package thx.core;

import thx.core.Tuple;
using thx.core.Strings;

abstract QueryString(Map<String, QueryStringValue>) from Map<String, QueryStringValue> to Map<String, QueryStringValue>{
  public static var separator = "&";
  public static var assignment = "=";
  public static var encodeURIComponent = StringTools.urlEncode;
  public static var decodeURIComponent = StringTools.urlDecode;

  public static function parseWithSymbols(s : String, separator : String, assignment : String, ?decodeURIComponent : String -> String) {
    if(null == decodeURIComponent)
      decodeURIComponent = QueryString.decodeURIComponent;
    if(s.startsWith("?") || s.startsWith("#"))
      s = s.substring(1);

    return null;
  }

  @:from public static function fromObject(o : {}) : QueryString {
    return null;
  }

  @:from public static function parse(s : String) : QueryString {
    return parseWithSymbols(s, separator, assignment, decodeURIComponent);
  }

  @:to public function object() : {} {
    return null;
  }

  @:to public function map() : Map<String, QueryStringValue> {
    return null;
  }

  inline public function exist(name : String) {
    return null;
  }

  inline public function remove(name : String) {
    return null;
  }

  inline public function get(name : String) {
    return null;
  }

  public function set(name : String, value : String) {
    return null;
  }

  inline public function setMany(name : String, values : Array<String>) {
    return null;
  }

  public function toStringWithSymbols(separator : String, assignment : String, ?encodeURIComponent : String -> String) {
    if(null == encodeURIComponent)
      encodeURIComponent = QueryString.encodeURIComponent;
    return null;
  }

  @:to inline public function toString()
    return toStringWithSymbols(separator, assignment, encodeURIComponent);
}

abstract QueryStringValue(Array<String>) from Array<String> to Array<String> {
  @:to function toString() : String
    return this.join(",");
}
