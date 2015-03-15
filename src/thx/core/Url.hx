package thx.core;

@:forward(slashes)
abstract Url(UrlType) from UrlType to UrlType {
  @:from public static function parse(s : String) : Url {
    // normalize ., .., //
  }

  public var host(get, set) : String;
  public var isAbsolute(get, null) : Bool;
  public var isRelative(get, null) : Bool;
  public var href(get, set) : String;
  public var protocol(get, set) : String;
  // concatenation of pathname and search
  public var path(get, set) : String;

  @:to public function toString() {

  }

  function get_href()
    return toString();

  function set_href(value : String)
    return this = parse(value);

  inline function get_protocol()
    return this.protocol;

  function set_protocol(value : String)
    return this.protocol = null == value ? null : value.toLowerCase();

  // resolve?
  // relative?
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
