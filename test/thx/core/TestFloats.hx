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

  public function testCompare() {
    Assert.equals(-1, (1.0).compare(2.0));
    Assert.equals(-1, (1.0).compare(3.0));
    Assert.equals(-1, (-1.0).compare(3.0));
    Assert.equals(-1, (-2.0).compare(-1.0));
    Assert.equals(-1, (-Math.PI).compare(Math.PI));

    Assert.equals(0, (1.0).compare(1.0));
    Assert.equals(0, (2.0).compare(2.0));
    Assert.equals(0, (-2.0).compare(-2.0));
    Assert.equals(0, (Math.PI).compare(Math.PI));

    Assert.equals(1, (1.0).compare(-1.0));
    Assert.equals(1, (2.0).compare(1.0));
    Assert.equals(1, (-3.0).compare(-56.0));
    Assert.equals(1, (Math.PI).compare(-Math.PI));
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

  public function testInterpolateAngle() {
    var tests = [
      { a : 30,  b : 330, s : 0,   l : 180, cw : 180, ccw : 0   },
      { a : 330, b : 30,  s : 0,   l : 180, cw : 0,   ccw : 180 },

      { a : 30,  b : 120, s : 75,  l : 255, cw : 75,  ccw : 255 },
      { a : 120, b : 30,  s : 75,  l : 255, cw : 255, ccw : 75  },

      { a : 0,   b : 180, s : 90,  l : 270, cw : 90,  ccw : 270 },
      { a : 180, b : 0,   s : 270, l : 90,  cw : 270, ccw : 90  },

      { a : 10,  b : 200, s : 285, l : 105, cw : 105, ccw : 285 },
      { a : 200, b : 10,  s : 285, l : 105, cw : 285, ccw : 105 },

      { a : 170, b : 340, s : 255, l : 75,  cw : 255, ccw : 75  },
      { a : 340, b : 170, s : 255, l : 75,  cw : 75,  ccw : 255 },

      { a : 190, b : 350, s : 270, l : 90,  cw : 270, ccw : 90  },
      { a : 350, b : 190, s : 270, l : 90,  cw : 90,  ccw : 270 },

      { a : 160, b : 350, s : 75,  l : 255, cw : 255, ccw : 75  },
      { a : 350, b : 160, s : 75,  l : 255, cw : 75,  ccw : 255 },
    ];

    for(test in tests) {
      var r = Floats.interpolateAngle(0.5, test.a, test.b);
      Assert.equals(test.s, r, 'circular interpolation (shortest) at 50% between ${test.a} and ${test.b} should be ${test.s} but it is ${r}');

      r = Floats.interpolateAngleWidest(0.5, test.a, test.b);
      Assert.equals(test.l, r, 'circular interpolation (longest) at 50% between ${test.a} and ${test.b} should be ${test.l} but it is ${r}');

      r = Floats.interpolateAngleCW(0.5, test.a, test.b);
      Assert.equals(test.cw, r, 'circular interpolation CW at 50% between ${test.a} and ${test.b} should be ${test.cw} but it is ${r}');

      r = Floats.interpolateAngleCCW(0.5, test.a, test.b);
      Assert.equals(test.ccw, r, 'circular interpolation CCW at 50% between ${test.a} and ${test.b} should be ${test.ccw} but it is ${r}');
    }
  }
}
