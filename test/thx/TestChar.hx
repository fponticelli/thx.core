package thx;

import haxe.PosInfos;
import utest.Assert;
using thx.Char;

class TestChar {
  public function new() { }

  public function testChar() {
    var char : Char = 120;

    Assert.equals(120, char);
    Assert.equals("x", char.toString());

    char = "y";

    Assert.equals(121, char);
    Assert.equals("y", char.toString());

    Assert.equals(89, char.toUpperCase());
    Assert.equals("Y", char.toUpperCase().toString());

    char = char.next();

    Assert.equals(122, char);
    Assert.equals("z", char.toString());

    Assert.equals(121, char.prev());
  }

  public function testControl() {
    Assert.isTrue((7 : Char).isControl());
    Assert.isFalse(("x" : Char).isControl());
  }
}
