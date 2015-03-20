package thx.core;

import thx.core.Tuple;
using thx.core.Strings;
using thx.core.Iterators;

abstract QueryString(Map<String, QueryStringValue>) from Map<String, QueryStringValue> to Map<String, QueryStringValue>{
  public static var separator = "&";
  public static var assignment = "=";
  public static var encodeURIComponent = StringTools.urlEncode;
  public static var decodeURIComponent = StringTools.urlDecode;

  public static function parseWithSymbols(s : String, separator : String, assignment : String, ?decodeURIComponent : String -> String) : QueryString {
    if(null == decodeURIComponent)
      decodeURIComponent = QueryString.decodeURIComponent;
    if(s.startsWith("?") || s.startsWith("#"))
      s = s.substring(1);
    s = s.ltrim();
    var map = new Map();

    return map;
  }

  @:from public static function fromObject(o : {}) : QueryString {
    var map = new Map();

    return map;
  }

  @:from public static function parse(s : String) : QueryString
    return parseWithSymbols(s, separator, assignment, decodeURIComponent);

  @:to public function object() : {} {
    var o = {};
    this.keys().map(function(key) {
        var v : Array<String> = this.get(key);
        if(v.length == 0)
          Reflect.setField(o, key, null);
        else if(v.length == 1)
          Reflect.setField(o, key, v[0]);
        else
        Reflect.setField(o, key, v);
      });
    return o;
  }

  inline public function exist(name : String) : Bool
    return this.exists(name);

  inline public function remove(name : String)
    return this.remove(name);

  public function removeValue(name : String, value : String) {
    if(!this.exists(name))
      return false;
    return (this.get(name) : Array<String>).remove(value);
  }

  inline public function get(name : String) : QueryStringValue
    return this.get(name);

  public function set(name : String, value : String) : QueryString {
    var arr : Array<String> = this.get(name);
    if(null == arr) {
      arr = [value];
    } else {
      arr.push(value);
    }
    return this;
  }

  inline public function setMany(name : String, values : Array<String>)
    return this.set(name, values);

  public function toStringWithSymbols(separator : String, assignment : String, ?encodeURIComponent : String -> String) {
    if(null == encodeURIComponent)
      encodeURIComponent = QueryString.encodeURIComponent;
    return this.keys().pluck(encodeURIComponent(_)+assignment+encodeURIComponent(this.get(_))).join(separator);
  }

  @:to inline public function toString()
    return toStringWithSymbols(separator, assignment, encodeURIComponent);
}

abstract QueryStringValue(Array<String>) from Array<String> to Array<String> {
  @:to function toString() : String
    return this.join(",");
}
