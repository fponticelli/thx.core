package thx.core;

abstract Url(UrlType) from UrlType to UrlType {
  //static var pattern = ~/^(((([^:\/#\?]+:)?(?:(\/\/)((?:(([^:@\/#\?]+)(?:\:([^:@\/#\?]+))?)@)?(([^:\/#\?\]\[]+|\[[^\/\]@#?]+\])(?:\:([0-9]+))?))?)?)?((\/?(?:[^\/\?#]+\/+)*)([^\?#]*)))?(\?[^#]+)?)(#.*)?/;
  static var pattern = ~/./;
  @:from public static function parse(s : String) : Url {
    // normalize ., .., //
    return null;
  }

  public var host(get, set) : String;
  public var isAbsolute(get, never) : Bool;
  public var isRelative(get, never) : Bool;
  public var hasAuth(get, never) : Bool;
  public var hasHash(get, never) : Bool;
  public var hasPort(get, never) : Bool;
  public var href(get, set) : String;
  public var protocol(get, set) : String;
  // concatenation of pathname and search || querystring
  public var port(get, set) : Int;
  public var path(get, set) : String;
  public var auth(get, set) : String;
  public var hash(get, set) : String;
  public var slashes(get, set) : Bool;

  @:to public function toString()
    return if(isAbsolute) {
      '$protocol:${slashes?"//":""}${hasAuth?auth+"@":""}$host$path${hasHash?"#"+hash:""}';
    } else {
      '$path${hasHash?"#"+hash:""}';
    }

  inline function get_protocol()
    return this.protocol;

  function set_protocol(value : String)
    return this.protocol = null == value ? null : value.toLowerCase();

  inline function get_host()
    return this.hostname + (hasPort ? ':$port' : "");

  inline function set_host(host : String) {
    // TODO
    return host;
  }

  function get_href()
    return toString();

  inline function set_href(value : String) {
    this = (parse(value) : UrlType);
    return value;
  }

  inline function get_hasPort()
    return null;

  inline function set_hasPort(value) {
    return value;
  }

  inline function get_hasHash()
    return null;

  inline function set_hasHash(value) {
    return value;
  }

  inline function get_hasAuth()
    return null;

  inline function set_hasAuth(value) {
    return value;
  }

  inline function get_isRelative()
    return null;

  inline function set_isRelative(value) {
    return value;
  }

  inline function get_isAbsolute()
    return null;

  inline function set_isAbsolute(value) {
    return value;
  }

  inline function get_port()
    return null;

  inline function set_port(value) {
    return value;
  }

  inline function get_path()
    return null;

  inline function set_path(value) {
    return value;
  }

  inline function get_auth()
    return null;

  inline function set_auth(value) {
    return value;
  }

  inline function get_hash()
    return null;

  inline function set_hash(value) {
    return value;
  }

  inline function get_slashes()
    return null;

  inline function set_slashes(value) {
    return value;
  }
}

typedef UrlType = {
  //'http://user:pass@host.com:8080/p/a/t/h?query=string#hash'
  protocol : String,
  slashes: Bool,
  auth: String,
  hostname: String,
  port: Int,
  pathname: String,
  query: QueryString,
  search: String, // for unparsable query string
  hash: String
}
