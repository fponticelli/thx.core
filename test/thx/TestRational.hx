package thx;

import utest.Assert;
import thx.Rational;

class TestRational {
  public function new() {}

  public function testOperations() {
    var x : Rational<Int>,
        y : Rational<Int>;

    // 1/2 + 1/3 = 5/6
    x = Rational.fromInts(1, 2);
    y = Rational.fromInts(1, 3);
    Assert.equals("5/6", (x + y).toString());

    // 8/9 + 1/9 = 1
    x = Rational.fromInts(8, 9);
    y = Rational.fromInts(1, 9);
    Assert.equals("1", (x + y).toString());

    // 1/200000000 + 1/300000000 = 1/120000000
    x = Rational.fromInts(1, 200000000);
    y = Rational.fromInts(1, 300000000);
    Assert.equals("1/120000000", (x + y).toString());

    // 1073741789/20 + 1073741789/30 = 1073741789/12
    x = Rational.fromInts(1073741789, 20);
    y = Rational.fromInts(1073741789, 30);
    Assert.equals("1073741789/12", (x + y).toString());

    //  4/17 * 17/4 = 1
    x = Rational.fromInts(4, 17);
    y = Rational.fromInts(17, 4);
    Assert.equals("1", (x * y).toString());

    // 3037141/3247033 * 3037547/3246599 = 841/961
    x = Rational.fromInts(3037141, 3247033);
    y = Rational.fromInts(3037547, 3246599);
    Assert.equals("841/961", (x * y).toString());
    Assert.floatEquals(0.87513007284079, (x * y).toFloat());

    // 1/6 - -4/-8 = -1/3
    x = Rational.fromInts( 1,  6);
    y = Rational.fromInts(-4, -8);
    Assert.equals("-1/3", (x - y).toString());
  }
}
