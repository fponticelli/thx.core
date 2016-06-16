package thx;

import utest.Assert;

class TestAny {
  public function new() {}

  public function testAny() {
    var a : Any = 123;
    var b : Any = 100;
    var aInt : Int = a;
    var bInt : Int = b;
    Assert.same(223, aInt + bInt);

    var aString = thx.Convert.toString(a);
    Assert.same("123", aString);
  }
}
