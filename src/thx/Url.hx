package thx;

import thx.Error;
using thx.Strings;

/**
It's a type that represents a URL.
*/
abstract Url(UrlType) from UrlType to UrlType {
  static var pattern = ~/^((((?:([^:\/#\?]+):)?(?:(\/\/)?((?:(([^:@\/#\?]+)(?:[:]([^:@\/#\?]+))?)@)?(([^:\/#\?\]\[]+|\[[^\/\]@#?]+\])(?:[:]([0-9]+))?))?)?)?((\/?(?:[^\/\?#]+\/+)*)([^\?#]*)))?(?:\?([^#]+))?)(?:#(.*))?/;
/**
Generates a URL instance from a `String`. It throws an exception if the string
cannot be parsed to a valid URL.

The URL can be either relative or absolute.
*/
  @:from public static function fromString(s : String) : Url
    return parse(s, true);

  public static function parse(s : String, parseQueryString : Bool) : Url {
    if(!pattern.match(s)) throw new Error('unable to parse "$s" to Url');
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

  public var auth(get, set) : String;
  public var hash(get, set) : String;
  public var hasAuth(get, never) : Bool;
  public var hasHash(get, never) : Bool;
  public var hasPort(get, never) : Bool;
  public var hasProtocol(get, never) : Bool;
  public var hasQueryString(get, never) : Bool;
  public var hasSearch(get, never) : Bool;
  public var host(get, set) : String;
  public var hostName(get, set) : String;
  public var href(get, set) : String;
  public var isAbsolute(get, never) : Bool;
  public var isRelative(get, never) : Bool;
  public var path(get, set) : String;
  public var pathName(get, set) : String;
  public var port(get, set) : Null<Int>;
  public var protocol(get, set) : String;
  public var queryString(get, set) : QueryString;
  public var search(get, set) : String;
  public var slashes(get, set) : Bool;

/**
Matches all the URL parts with anthat URL and returns true if they are all
equals.
*/
  @:op(A==B)
  public static function equals(self : Url, that : Url) : Bool
    return self.equalsTo(that);

  public function equalsTo(that : Url) : Bool
    return
      this.protocol == that.protocol &&
      this.slashes == that.slashes &&
      this.auth == that.auth &&
      this.hostName == that.hostName &&
      this.port == that.port &&
      this.pathName == that.pathName &&
      this.queryString.equals(that.queryString) &&
      this.search == that.search &&
      this.hash == that.hash;

  @:op(A/B)
  public function concatString(that : String) : Url {
    var copy = clone();
    if(pathName.isEmpty()) {
      if(!that.startsWith("/"))
        that = "/" + that;
      copy.pathName = that;
    } else {
      if(that.startsWith("/"))
        that = that.substring(1);
      if(pathName.endsWith("/"))
        copy.pathName = copy.pathName + that;
      else
        copy.pathName = copy.pathName + "/" + that;
    }
    return copy;
  }

  @:to public function toString()
    return if(isAbsolute)
      '${hasProtocol ? protocol + ":" : ""}${slashes?"//":""}${hasAuth?auth+"@":""}$host$path${hasHash?"#"+hash:""}';
    else
      '$path${hasHash?"#"+hash:""}';

  public function clone() : Url {
    return {
      protocol: protocol,
      slashes: slashes,
      auth: auth,
      hostName: hostName,
      port: port,
      pathName: pathName,
      queryString: queryString.clone(),
      search: search,
      hash: hash
    };
  }

  public function ensureQueryString() {
    if(this.queryString != null)
      return this.queryString;
    else
      return queryString = new Map();
  }

  inline function get_auth()
    return this.auth;

  inline function set_auth(value : String)
    return this.auth = value;

  inline function get_hasAuth()
    return this.auth != null;

  inline function get_hasHash()
    return this.hash != null;

  inline function get_hasPort()
    return this.port != null;

  inline function get_hasProtocol()
    return this.protocol != null;

  inline function get_hasQueryString()
    return this.queryString != null && !this.queryString.isEmpty();

  inline function get_hasSearch()
    return this.search != null || hasQueryString;

  inline function get_host()
    return this.hostName + (hasPort ? ':$port' : "");

  inline function set_host(host : String) {
    var p = host.indexOf(":");
    if(p < 0) {
      this.hostName = host;
      this.port = null;
    } else {
      this.hostName = host.substring(0, p);
      this.port = Std.parseInt(host.substring(p + 1));
    }
    return host;
  }

  inline function get_hostName()
    return this.hostName;

  inline function set_hostName(hostName : String)
    return this.hostName = hostName;

  function get_href()
    return toString();

  inline function set_href(value : String) {
    this = (parse(value, true) : UrlType);
    return value;
  }

  inline function get_isAbsolute()
    return this.hostName != null;

  inline function get_isRelative()
    return this.hostName == null;

  inline function get_path()
    return this.pathName + (hasSearch ? '?$search' : "");

  inline function set_path(value : String) {
    var p = value.indexOf("?");
    if(p < 0) {
      this.pathName = value;
      this.search = null;
      this.queryString = null;
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

  inline function get_port()
    return this.port;

  inline function set_port(value)
    return this.port = value;
  inline function get_protocol()
    return this.protocol;

  function set_protocol(value : String)
    return this.protocol = null == value ? null : value.toLowerCase();

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
    if(null != value)
      this.search = null;
    return this.queryString = value;
  }

  function get_search() : String
    return null != this.search && "" != this.search ? this.search : this.queryString;

  function set_search(value : String) {
    var qs = try QueryString.parse(value) catch(e : Dynamic) null;
    if(qs == null || qs.isEmptyOrMono()) {
      this.search = value;
      this.queryString = null;
    } else {
      this.queryString = qs;
      this.search = null;
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
  port: Null<Int>,
  pathName: String,
  queryString: QueryString,
  search: String, // for unparsable query string
  hash: String
}
