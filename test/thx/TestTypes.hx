package thx;

import utest.Assert;
import thx.Types;

class TestTypes {
  public function new() {}

  public function testIsObject() {
    Assert.isFalse(Types.isObject("test"));
  }
}
