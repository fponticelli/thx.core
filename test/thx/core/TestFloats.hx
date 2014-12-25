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
}