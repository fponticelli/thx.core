package thx;

import utest.Assert;
import thx.Decimal;

class TestDecimal {
  public function new() {}

  public function testAddition() {
    Assert.isTrue(("123.456" : Decimal) + "76.544000" == "200");
    Assert.isTrue(("123.456" : Decimal) + "0.004" == "123.46");
    Assert.isTrue(("123.456" : Decimal) + "-0.456" == "123");
  }

  public function testComparison() {
    Assert.isTrue(("1" : Decimal) > "0.11111");
    Assert.isTrue(("1" : Decimal) > -1);
    Assert.isFalse(("1" : Decimal) > 1);
    Assert.isTrue(("1" : Decimal) >= 1);
    Assert.isTrue(("1" : Decimal) == 1);
    Assert.isTrue(("1.01001" : Decimal) == "1.0100100");
  }

  public function testString() {
    var tests = ["0", "0.00000789", "0.001", "0.123", "1.0", "1", "1.1", "123456789.0123456789", "123456789.012345678900000"],
        dec : Decimal;
    for(test in tests) {
      dec = test;
      Assert.equals(test, dec.toString());

      if(test == "0") continue;

      dec = '-$test';
      Assert.equals('-$test', dec.toString());
    }
  }

  public function testScaleTo() {
    var tests = [
            { src : "0", exp : "0", scale : 0 },
            { src : "0", exp : "0.00000", scale : 5 },
            { src : "0.1", exp : "0.100", scale : 3 },
            { src : "0.0123456", exp : "0.012", scale : 3 },
            { src : "1234567890.1234567890", exp : "1234567890.123", scale : 3 },
            { src : "1234567890.1234567890", exp : "1234567890.1234567890", scale : 10 },
            { src : "1234567890.1234567890", exp : "1234567890.123456789000", scale : 12 }
          ],
        dec : Decimal;
    for(test in tests) {
      dec = test.src;
      Assert.equals(test.exp, dec.scaleTo(test.scale).toString(), 'expected ${test.src} to be ${test.exp} when scaled to ${test.scale} but got ${dec.scaleTo(test.scale).toString()}');

      if(test.src == "0") continue;

      dec = '-${test.src}';
      Assert.equals('-${test.exp}', dec.scaleTo(test.scale).toString(), 'expected -${test.src} to be -${test.exp} when scaled to ${test.scale} but got -${dec.scaleTo(test.scale).toString()}');
    }
  }
}
