package thx.core;

abstract Url(UrlType) from UrlType to UrlType {
  static var pattern = ~/^((((?:([^:\/#\?]+):)?(?:(\/\/)?((?:(([^:@\/#\?]+)(?:[:]([^:@\/#\?]+))?)@)?(([^:\/#\?\]\[]+|\[[^\/\]@#?]+\])(?:[:]([0-9]+))?))?)?)?((\/?(?:[^\/\?#]+\/+)*)([^\?#]*)))?(?:\?([^#]+))?)(?:#(.*))?/;
  @:from public static function parse(s : String) : Url {
    if(null == s) return null;
    if(!pattern.match(s)) throw 'unable to parse "$s" to Url';
    var port = pattern.matched(12),
        o : Url = {
          protocol : pattern.matched(4),
          slashes: pattern.matched(5) == "//",
          auth: pattern.matched(7),
          hostName: pattern.matched(11),
          port: null == port ? null : Std.parseInt(port),
          pathName: pattern.matched(13),
          queryString: null,
          search: null,
          hash: pattern.matched(17)
        };
    o.search = pattern.matched(16);
    return o;
  }

  public var host(get, set) : String;
  public var hostName(get, set) : String;
  public var isAbsolute(get, never) : Bool;
  public var isRelative(get, never) : Bool;
  public var hasAuth(get, never) : Bool;
  public var hasHash(get, never) : Bool;
  public var hasSearch(get, never) : Bool;
  public var hasQueryString(get, never) : Bool;
  public var hasPort(get, never) : Bool;
  public var href(get, set) : String;
  public var protocol(get, set) : String;
  public var port(get, set) : Int;
  // concatenation of pathName and search || querystring
  public var path(get, set) : String;
  public var pathName(get, set) : String;
  public var auth(get, set) : String;
  public var hash(get, set) : String;
  public var slashes(get, set) : Bool;
  public var queryString(get, set) : QueryString;
  public var search(get, set) : String;

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
    return this.hostName + (hasPort ? ':$port' : "");

  inline function set_host(host : String) {
    // TODO
    return host;
  }

inline function get_hostName()
  return this.hostName;

inline function set_hostName(hostName : String)
  return this.hostName = hostName;

  function get_href()
    return toString();

  inline function set_href(value : String) {
    this = (parse(value) : UrlType);
    return value;
  }

  inline function get_hasPort()
    return this.port != null;

  inline function get_hasHash()
    return this.hash != null;

  inline function get_hasAuth()
    return this.auth != null;

  inline function get_hasQueryString()
    return this.queryString != null;

  inline function get_hasSearch()
    return this.search != null || hasQueryString;

  inline function get_isRelative()
  return this.protocol == null;

  inline function get_isAbsolute()
    return this.protocol != null;

  inline function get_port()
    return this.port;

  inline function set_port(value)
    return this.port = value;

  inline function get_path()
    return this.pathName + (hasSearch ? '?$search' : "");

  inline function set_path(value : String) {
    var p = value.indexOf("?");
    if(p < 0) {
      this.pathName = value;
    } else {
      this.pathName = value.substring(0, p);
      search = value.substring(p + 1);
    }
    return value;
  }

  inline function get_pathName()
    return this.pathName;

  inline function set_pathName(value : String)
    return this.pathName = value;

  inline function get_auth()
    return this.auth;

  inline function set_auth(value : String)
    return this.auth = value;

  inline function get_hash()
    return this.hash;

  inline function set_hash(value : String)
    return this.hash = value;

  inline function get_slashes()
    return this.slashes;

  inline function set_slashes(value : Bool)
    return this.slashes = value;

  inline function get_queryString()
    return this.queryString;

  inline function set_queryString(value : QueryString) {
    if(null != value && null != search)
      this.search = null;
    return this.queryString = value;
  }

  inline function get_search()
    return this.search;

  function set_search(value : String) {
    var qs = try QueryString.parse(search) catch(e : Dynamic) null;
    if(qs == null) {
      this.search = value;
    } else {
      queryString = qs;
    }
    return value;
  }
}

typedef UrlType = {
  //'http://user:pass@host.com:8080/p/a/t/h?query=string#hash'
  protocol : String,
  slashes: Bool,
  auth: String,
  hostName: String,
  port: Int,
  pathName: String,
  queryString: QueryString,
  search: String, // for unparsable query string
  hash: String
}
