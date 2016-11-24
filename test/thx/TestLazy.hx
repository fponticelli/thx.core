package thx;

import utest.Assert;

class TestLazy {
  public function new() {}

  public function testLazy() {
    Assert.equals("a", alt("a", "b"));
    Assert.equals("b", alt(null, "b"));
    Assert.equals("b", alt(null, function() return "b"));

    var fs: Lazy<String> = "b";
    Assert.equals("b", fs());
    Assert.equals("b", fs.value);

    var fs = Lazy.ofValue("c");
    Assert.equals("c", fs.value);
  }

  public function testMap() {
    Assert.equals(3, Lazy.ofValue("abc").map(function(v) return v.length).value);
  }

  public function testOps() {
    var vi: Lazy<Int> = 1;
    var vf: Lazy<Float> = 1.5;
    Assert.equals(-1, (-vi).value);
    Assert.equals(-1.5, (-vf).value);
  }

  public function testToValue() {
    var v: String = Lazy.ofValue("a");
    Assert.equals("a", v);
  }

  public function testToString() {
    var v = Lazy.ofValue("a");
    Assert.equals("Lazy[a]", v.toString());
  }

  public static function alt(value: Null<String>, f: Lazy<String>) {
    return if(null != value) value else f();
  }
}
