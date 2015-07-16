package thx;

import haxe.PosInfos;
import utest.Assert;
using thx.Chars;

class TestChars {
  public function new() { }

  public function testChars() {
    var s = "a☺b☺☺c☺☺☺",
        t : Chars = s,
        e = [97,9786,98,9786,9786,99,9786,9786,9786];
    Assert.same(e, t);
    Assert.equals(s, t.toString());
  }
}
