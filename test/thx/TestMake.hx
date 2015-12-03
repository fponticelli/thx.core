package thx;

import utest.Assert;

class TestMake {
  public function new() {}

  public function testConstructorLiteral() {
    var f = Make.constructor({ a : String, b : Int, c : Float, d : String });
    Assert.same({
      a : "A",
      b : 1,
      c : 0.2,
      d : "D"
    }, f("A", 1, 0.2, "D"));
  }

  public function testConstructorFromTypedef() {
    var f = Make.constructor(ConstructorType);
    Assert.same({
      a : "A",
      b : 1,
      c : 0.2,
      d : "D"
    }, f("A", 1, 0.2, "D"));
  }
}

typedef ConstructorType = {
  a : String,
  b : Int,
  c : Float,
  d : String
}
