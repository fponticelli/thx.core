package thx.core;

abstract Url(UrlType) {
  @:from public static function parse(s : String) : Url {
    // normalize ., .., //
  }

  public var isAbsolute;
  public var isRelative;

  @:to public function toString() {

  }

  // resolve?
  // relative?
}

typedef UrlType = {
'http://user:pass@host.com:8080/p/a/t/h?query=string#hash'

href: The full URL that was originally parsed. Both the protocol and host are lowercased.

Example: 'http://user:pass@host.com:8080/p/a/t/h?query=string#hash'

protocol: The request protocol, lowercased.

Example: 'http:'

slashes: The protocol requires slashes after the colon

Example: true or false

host: The full lowercased host portion of the URL, including port information.

Example: 'host.com:8080'

auth: The authentication information portion of a URL.

Example: 'user:pass'

hostname: Just the lowercased hostname portion of the host.

Example: 'host.com'

port: The port number portion of the host.

Example: '8080'

pathname: The path section of the URL, that comes after the host and before the query, including the initial slash if present.

Example: '/p/a/t/h'

search: The 'query string' portion of the URL, including the leading question mark.

Example: '?query=string'

path: Concatenation of pathname and search.

Example: '/p/a/t/h?query=string'

query: Either the 'params' portion of the query string, or a querystring-parsed object.

Example: 'query=string' or {'query':'string'}

hash: The 'fragment' portion of the URL including the pound-sign.

Example: '#hash'
}