package thx;

import utest.Assert;
import thx.BigInt;

// TODO add tests for greater(Equal)/less(Equal)
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

  public function testStrings() {
    var tests = ["0", "3", "20", "12345678901234567890", "999999999999999999"];

    for(test in tests) {
      var out : BigInt = test;
      Assert.equals(test, out.toString(), 'expected $test but got ${out.toString()}');

      if(test == "0")
        continue;

      var out : BigInt = '-$test';
      Assert.equals('-$test', out.toString(), 'expected -$test but got ${out.toString()}');
    }
  }

  public function testEquals() {
    Assert.isTrue((0 : BigInt) == (0 : BigInt));
    Assert.isTrue((1 : BigInt) == (1 : BigInt));
    Assert.isTrue(("12345678901234567890" : BigInt) == ("12345678901234567890" : BigInt));
    Assert.isTrue((-1 : BigInt) == (-1 : BigInt));
    Assert.isTrue(("-12345678901234567890" : BigInt) == ("-12345678901234567890" : BigInt));

    Assert.isFalse((0 : BigInt) != (0 : BigInt));
    Assert.isFalse((1 : BigInt) != (1 : BigInt));
    Assert.isFalse(("12345678901234567890" : BigInt) != ("12345678901234567890" : BigInt));
    Assert.isFalse((-1 : BigInt) != (-1 : BigInt));
    Assert.isFalse(("-12345678901234567890" : BigInt) != ("-12345678901234567890" : BigInt));

    Assert.isTrue((0 : BigInt) != (1 : BigInt));
    Assert.isTrue((1 : BigInt) != (2 : BigInt));
    Assert.isTrue(("12345678901234567890" : BigInt) != ("12345678901234567891" : BigInt));
    Assert.isTrue((-1 : BigInt) != (-2 : BigInt));
    Assert.isTrue(("-12345678901234567890" : BigInt) != ("-12345678901234567891" : BigInt));

    Assert.isFalse((0 : BigInt) == (1 : BigInt));
    Assert.isFalse((1 : BigInt) == (2 : BigInt));
    Assert.isFalse(("12345678901234567890" : BigInt) == ("12345678901234567891" : BigInt));
    Assert.isFalse((-1 : BigInt) == (-2 : BigInt));
    Assert.isFalse(("-12345678901234567890" : BigInt) == ("-12345678901234567891" : BigInt));
  }

  public function testDivision() {
    Assert.raises(function() {
      (1 : BigInt) / (0 : BigInt);
    }, Error);
    Assert.raises(function() {
      (0 : BigInt) / (0 : BigInt);
    }, Error);

    var tests = [
      { num : (10 : BigInt), div : (2 : BigInt), res : (5 : BigInt) },
      { num : ("1000000000000000000" : BigInt), div : (50 : BigInt), res : ("20000000000000000" : BigInt) },
    ];
    for(test in tests) {
      Assert.isTrue(test.num / test.div == test.res, 'expected ${test.num} / ${test.div} == ${test.res} and it was ${test.num / test.div}');
    }
  }

  public function testAddition() {
    var m : BigInt;
    var n : BigInt;
    var o : BigInt;
    var s : BigInt;

    // identity
    m = 123; n = 0;
    Assert.isTrue(m+n == m);
    Assert.isTrue(n+m == m);

    Assert.isTrue(m-n == m);
    Assert.isTrue(n-m == -m);

    // commutativity
    m = 123; n = 343; s = 466;
    Assert.isTrue(m+n == s);
    Assert.isTrue(n+m == s);

    Assert.isTrue(s-n == m);
    Assert.isTrue(n-s == -m);

    // associativity
    m = -234356; n = 355321; o = 234;
    Assert.isTrue((m+n)+o == m+(n+o));

    Assert.isTrue((m-n)+o == m-(n+o));

    m = 1; n = -9999; s = -9998;
    Assert.isTrue(m+n == s);

    Assert.isTrue(s-n == m);

    // lots of big sums
    m = 0x7fffffff;
    n = m;
    s = "4294967294";
    Assert.isTrue(m+n == s, 'expected $m+$n==$s');

    m = "11111111111111111111110111111111111111111111111111";
    n = m;
    s = "22222222222222222222220222222222222222222222222222";
    Assert.isTrue(m+n == s);

    Assert.isTrue(m-n == 0);
    Assert.isTrue(s-n == m);

    m = "99499494949383948405";
    n = "-472435789789045237084578078029457809342597808204538970";
    s = "-472435789789045237084578078029457709843102858820590565";
    Assert.isTrue(m+n == s);
    Assert.isTrue(s-n == m);

    m = "-1";
    n = "100000000000000000000000000000000000000000000";
    s = "99999999999999999999999999999999999999999999";
    Assert.isTrue(m+n == s);
    Assert.isTrue(s-n == m);
  }

  public function testNegation() {
    var m : BigInt;
    var n : BigInt;

    // -0 == 0
    n = 0;
    Assert.isTrue(-n == n);

    n = 1;
    Assert.isTrue(-n == -1);
    Assert.isTrue(-(-n) == n);

    n = -1234;
    Assert.isTrue(-n == 1234);
    Assert.isTrue(-(-n) == n);

    m = "192395858359234934684359234";
    n = "-192395858359234934684359234";
    Assert.isTrue(-m == n);
    Assert.isTrue(m == -n);
  }

  public function testMultiplication() {
    var a : BigInt;
    var b : BigInt;
    var m : BigInt;

    a = 12347; b = 0;
    Assert.isTrue(a*b == b);
    Assert.isTrue(b*a == b);

    a = -99999; b = 1;
    Assert.isTrue(a*b == a);
    Assert.isTrue(b*a == a);

    a = 1235; b = 44; m = 54340;
    Assert.isTrue(a*b == m);
    Assert.isTrue(b*a == m);

    a = -11; b = -9; m = 99;
    Assert.isTrue(a*b == m);

    a = 55; b = 200395; m = 11021725;
    Assert.isTrue(a*b == m);

    a = "111111111111111111111111111111111111111";
    b = "-333333333333333333333";
    m = "-37037037037037037036999999999999999999962962962962962962963";
    Assert.isTrue(a*b == m);
  }
}
