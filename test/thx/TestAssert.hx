package thx;

import haxe.PosInfos;
import utest.Assert as A;
using thx.Assert;

class TestAssert {
  public function new() {}

  public function testBasics() {
    A.raises(function() {
      Assert.isTrue(false);
    }, thx.error.AssertError);

    Assert.isTrue(true);
    A.pass();
  }
}
