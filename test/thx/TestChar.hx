package thx;

import haxe.PosInfos;
import utest.Assert;
using thx.Char;

class TestChar {
  public function new() { }

  public function testChar() {
    var char : Char = 120;

    Assert.equals(char, 120);
    Assert.equals(char.toString(), "x");

    char = "y";

    Assert.equals(char, 121);
    Assert.equals(char.toString(), "y");
  }
}
