package thx;

import utest.Assert;
import thx.DateTime;

class TestDateTime {
  public function new() {}

  public function testLocalOffset() {
    var ref   = DateHelper.localOffset(),
        delta = DateTime.localOffset();
    Assert.isTrue(ref == delta, 'expected $ref but got $delta');
  }
}
