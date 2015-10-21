package thx.rational;

import thx.rational.RationalInt;
import utest.Assert;

class TestRationalInt {
  public function new() {}

  public function testOperations() {
    var x : RationalImpl<Int>,
        y : RationalImpl<Int>,
        z : RationalImpl<Int>;

    // 1/2 + 1/3 = 5/6
    x = RationalInt.create(1, 2);
    y = RationalInt.create(1, 3);
    z = x.add(y);
    Assert.equals("5/6", z.toString());

    // 8/9 + 1/9 = 1
    x = RationalInt.create(8, 9);
    y = RationalInt.create(1, 9);
    z = x.add(y);
    Assert.equals("1", z.toString());

    // 1/200000000 + 1/300000000 = 1/120000000
    x = RationalInt.create(1, 200000000);
    y = RationalInt.create(1, 300000000);
    z = x.add(y);
    Assert.equals("1/120000000", z.toString());

    // 1073741789/20 + 1073741789/30 = 1073741789/12
    x = RationalInt.create(1073741789, 20);
    y = RationalInt.create(1073741789, 30);
    z = x.add(y);
    Assert.equals("1073741789/12", z.toString());

    //  4/17 * 17/4 = 1
    x = RationalInt.create(4, 17);
    y = RationalInt.create(17, 4);
    z = x.multiply(y);
    Assert.equals("1", z.toString());

    // 3037141/3247033 * 3037547/3246599 = 841/961
    x = RationalInt.create(3037141, 3247033);
    y = RationalInt.create(3037547, 3246599);
    z = x.multiply(y);
    Assert.equals("841/961", z.toString());
    Assert.floatEquals(0.87513007284079, z.toFloat());

    // 1/6 - -4/-8 = -1/3
    x = RationalInt.create( 1,  6);
    y = RationalInt.create(-4, -8);
    z = x.subtract(y);
    Assert.equals("-1/3", z.toString());
  }
}
