package thx;

import utest.Assert;
using thx.QueryString;

class TestQueryString {
  public function new() { }

  public function testBasics() {
    Assert.same(
      { foo : "bar" },
      QueryString.parse("?foo=bar").toObject()
    );

    Assert.same(
      { foo : "bar" },
      QueryString.parse("#foo=bar").toObject()
    );

    Assert.same(
      { foo : "bar" },
      QueryString.parse("foo=bar").toObject()
    );

    Assert.same(
      { foo : null },
      QueryString.parse("foo").toObject()
    );

    Assert.equals(
      "foo",
      QueryString.parse("foo").toString()
    );

    Assert.same(
      { foo : null, key : null },
      QueryString.parse("foo&key").toObject()
    );

    Assert.same(
      { foo : "bar", key : null },
      QueryString.parse("foo=bar&key").toObject()
    );

    Assert.same(
      {  },
      QueryString.parse("?").toObject()
    );

    Assert.same(
      {  },
      QueryString.parse("#").toObject()
    );

    Assert.same(
      {  },
      QueryString.parse(" ").toObject()
    );

    Assert.same(
      { foo : ["bar", "baz"] },
      QueryString.parse("foo=bar&foo=baz").toObject()
    );

    Assert.same(
      { "foo faz" : "bar baz  " },
      QueryString.parse("foo+faz=bar+baz++").toObject()
    );

    Assert.equals(
      "foo=bar",
      ({foo: 'bar'} : QueryString).toString()
    );

    var qs : QueryString = {foo: 'bar', bar: 'baz'};
    Assert.same(["bar"], qs.get("foo"));
    Assert.same(["baz"], qs.get("bar"));

    var qs = ({'foo bar': 'baz faz'} : QueryString).toString();
    Assert.isTrue(
      "foo%20bar=baz%20faz" == qs ||
      "foo+bar=baz+faz" == qs
    );

    var qs = ({abc: 'abc', foo: ['bar', 'baz']} : QueryString).toString();
    Assert.isTrue(
      "abc=abc&foo=bar&foo=baz" == qs ||
      "foo=bar&abc=abc&foo=baz" == qs ||
      "foo=bar&foo=baz&abc=abc" == qs ||
      "abc=abc&foo=baz&foo=bar" == qs ||
      "foo=bar&abc=abc&foo=baz" == qs ||
      "foo=bar&foo=baz&abc=abc" == qs
    );

    var qs = ("a=b&c=d" : QueryString).toString();
    Assert.isTrue(
      "a=b&c=d" == qs ||
      "c=d&a=b" == qs
    );
  }
}
