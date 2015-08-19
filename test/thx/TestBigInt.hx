package thx;

import utest.Assert;
import thx.BigInt;

class TestBigInt {
  public function new() {}

  public function testInts() {
    var tests = [
          1, 2, 4, 8, 16, 32, 64, 128, 256,
          512, 1024, 2048, 4096, 10000, 100000,
          1000000, 10000000
        ];
    for(test in tests) {
      var out : BigInt = test;
      Assert.equals(test, out.toInt(), 'expected $test but got ${out.toInt()}');

      var out : BigInt = -test;
      Assert.equals(-test, out.toInt(), 'expected ${-test} but got ${out.toInt()}');
    }
  }

  public function testFloats() {
    var tests = [0.0, 1.0, 5.0, 1.234e63, 5.432e80, 0.00001, 1.2345e-50];

    for(test in tests) {
      var out : BigInt = test;
      Assert.floatEquals(test, out.toFloat(), 'expected $test but got ${out.toFloat()}');

      var out : BigInt = -test;
      Assert.floatEquals(-test, out.toFloat(), 'expected ${-test} but got ${out.toFloat()}');
    }
  }
}
