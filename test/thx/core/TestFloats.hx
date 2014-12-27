/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

import utest.Assert;

using thx.core.Floats;

class TestFloats {
  public function new() { }

  public function testNormalize() {
    Assert.floatEquals(0.0, Floats.normalize( 0.0));
    Assert.floatEquals(1.0, Floats.normalize( 1.0));
    Assert.floatEquals(0.5, Floats.normalize( 0.5));
    Assert.floatEquals(0.0, Floats.normalize(-1.0));
    Assert.floatEquals(1.0, Floats.normalize(10.0));
  }

  public function testClamp() {
    Assert.floatEquals(10, Floats.clamp(0, 10, 100));
    Assert.floatEquals(10, Floats.clamp(10, 10, 100));
    Assert.floatEquals(50, Floats.clamp(50, 10, 100));
    Assert.floatEquals(100, Floats.clamp(100, 10, 100));
    Assert.floatEquals(100, Floats.clamp(110, 10, 100));
  }

  public function testClampSym() {
    Assert.floatEquals( -10, Floats.clampSym( -100, 10));
    Assert.floatEquals( 10, Floats.clampSym( 100, 10));
    Assert.floatEquals( 0, Floats.clampSym( 0, 10));
  }

  public function testRound() {
    var value = 123.456;
    Assert.floatEquals(123.5, value.roundTo(1));
    Assert.floatEquals(123.46, value.roundTo(2));
    Assert.floatEquals(123.456, value.roundTo(3));
    Assert.floatEquals(123.456, value.roundTo(4));

    value = 1234567890.123456;
    Assert.floatEquals(1234567890.1, value.roundTo(1));
    Assert.floatEquals(1234567890.12, value.roundTo(2));
    Assert.floatEquals(1234567890.123, value.roundTo(3));
    Assert.floatEquals(1234567890.1235, value.roundTo(4));
  }

  public function testAngleDifference() {
    var tests = [
      { a : 30,  b : 60,  d : 30 },
      { a : 60,  b : 30,  d : -30 },
      { a : 0,   b : 190, d : -170 },
      { a : 190, b : 0,   d : 170 },
      { a : 400, b : 40,  d : 0 },
      { a : 760, b : 40,  d : 0 }
    ];

    for(test in tests) {
      var d = Floats.angleDifference(test.a, test.b);
      Assert.equals(test.d, d, 'expected distance between ${test.a} and ${test.b} to be ${test.d} but it is $d');
    }
  }
}