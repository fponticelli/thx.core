package thx;

import utest.Assert;

class TestMake {
  public function new() {}

  public function testConstructorLiteral() {
    var f = Make.constructor({ c : String, b : Int, a : Float, d : String });
    Assert.same({
      c : "A",
      b : 1,
      a : 0.2,
      d : "D"
    }, f("A", 1, 0.2, "D"));
  }

  public function testConstructorFromTypedef() {
    var f = Make.constructor(ConstructorType);
    Assert.same({
      c : "A",
      b : 1,
      a : 0.2,
      d : "D"
    }, f("A", 1, 0.2, "D"));
  }
}

@:sequence(c, b, a, d)
// typedef ConstructorType = {
//   var c : String;
//   var b : Int;
//   @:optional var a : Float;
//   var d : String;
// }


typedef ConstructorType = {
  c : String,
  b : Int,
  ?a : Float,
  d : String
}
