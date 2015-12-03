package thx;

import utest.Assert;

class TestMake {
  public function new() {}

  public function testConstructor() {
    var f = Make.constructor({ a : String, b : Int, c : Float, d : String });
    Assert.same({
      a : "A",
      b : 1,
      c : 0.2,
      d : "D"
    }, f("A", 1, 0.2, "D"));
  }
}
