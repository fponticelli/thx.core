package thx.core;

import utest.Assert;
using thx.core.Url;

class TestUrl {
  public function new() { }

	public function testBasics() {
		var url : Url = "http://user:password@www.example.com:8888/some/path/name.ext?a=b&amp;c=d#hashtag/is/here";
		Assert.equals("http", url.protocol);
		Assert.equals("user:password", url.auth);
		Assert.equals("www.example.com:8888", url.host);
		Assert.equals("www.example.com", url.hostName);
		Assert.equals("/some/path/name.ext?a=b&amp;c=d", url.path);
		Assert.equals("/some/path/name.ext", url.pathName);
		Assert.equals("hashtag/is/here", url.hash);
	}
}
