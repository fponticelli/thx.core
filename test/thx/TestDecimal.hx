package thx;

import thx.Decimal;

class TestDecimal {
  public function new() {}

  public function testString() {
    var tests = ["0", "1.0", "1", "1.1", "123456789.0123456789", "123456789.012345678900000"],
        dec : Decimal;
    for(test in tests) {
      dec = test;
      Assert.equals(test, dec.toString());

      dec = '-$test';
      Assert.equals('-$test', dec.toString());
    }
  }

  public function testAdditions() {

  }
}
