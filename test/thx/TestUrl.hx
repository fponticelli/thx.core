package thx;

import utest.Assert;
using thx.Url;

class TestUrl {
  public function new() { }

	public function testBasics() {
		var url : Url = "http://user:password@www.example.com:8888/some/path/name.ext?a=b&c=d#hashtag/is/here";
		Assert.equals("http", url.protocol);
		Assert.equals("user:password", url.auth);
		Assert.equals("www.example.com:8888", url.host);
		Assert.equals("www.example.com", url.hostName);

		Assert.isTrue(
      "/some/path/name.ext?a=b&c=d" == url.path ||
      "/some/path/name.ext?c=d&a=b" == url.path
    );
		Assert.equals("/some/path/name.ext", url.pathName);
		Assert.equals("hashtag/is/here", url.hash);
	}

  public function testToString() {
    var urls : Array<String> = [
      "http://user:password@www.example.com:8888/some/path/name.ext?a=b#hashtag/is/here",
      "http://example.com",
      "irc://irc.example.com/channel",
      "www.example.com/foo",
      "news:rec.gardens.roses",
      "ldap://[2001:db8::7]/c=GB?objectClass?one",
      "mailto:John.Doe@example.com",
      "telnet://192.0.2.16:80/",
      "ldap://ldap.example.com/dc=example,dc=com",
      "ldap://ldap.example.com/cn=Barbara%20Jensen,dc=example,dc=com?cn,mail,telephoneNumber"
    ];
    for(url in urls)
      Assert.equals(url, Url.parse(url, false).toString());
  }

  public function testAbsolute() {
    var url : Url = "http://example.com";
    Assert.isTrue(url.isAbsolute);
    Assert.isFalse(url.isRelative);

    url = "example.com";
    Assert.isTrue(url.isAbsolute);
    Assert.isFalse(url.isRelative);

    url = "/some/path";
    Assert.isFalse(url.isAbsolute);
    Assert.isTrue(url.isRelative);
  }
}
