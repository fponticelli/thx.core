package thx;

import utest.Assert;
import thx.DateTime;

class TestDateTime {
  var offset : Time;
  var date : DateTime;

  public function new() {
    offset = Time.fromHours(-6);
    date = DateTime.create(2015, 7, 26, 21, 40, 30, 0, offset);
  }

  public function testFromToString() {
    var d : String = date;
    Assert.isTrue(date == d);
  }

  public function testFromString() {
    var offset = Time.fromHours(6);
    var date = DateTime.create(2015, 7, 26, 21, 40, 30, 0, offset);

    var d : String = date;
    Assert.isTrue(date == d);
  }

  public function testLocalOffset() {
    var ref   = DateHelper.localOffset(),
        delta = DateTime.localOffset();
    Assert.isTrue(ref == delta, 'expected $ref but got $delta');
  }
}
