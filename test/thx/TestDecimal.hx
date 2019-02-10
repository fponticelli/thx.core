package thx;

import utest.Assert;
import thx.Decimal;

class TestDecimal {
  public function new() {}

  var divisionSize : Int;

  public function setup() {
    this.divisionSize = Decimal.divisionScale;
    Decimal.divisionScale = 16;
  }

  public function teardown() {
    Decimal.divisionScale = this.divisionSize;
  }

  // public function testToBigInt() {
  //   var v : Decimal = "10234.0001040000";
  //   Assert.isTrue(v.toBigInt() == "10234", 'expected 10234 but got ${v.toBigInt()}');
  // }

  // public function testTrim() {
  //   var v : Decimal = "10234.0001040000";
  //   Assert.isTrue(v.scale == 10);
  //   Assert.isTrue(v.trim().scale == 6);
  //   Assert.isTrue(v.trim(8).scale == 8, 'expected ${v.trim(8)} to have a scale 8 but it is ${v.trim(8).scale}');
  //   Assert.isTrue(v.trim(2).scale == 6, 'expected ${v.trim(2)} to have a scale 6 but it is ${v.trim(2).scale}');
  //   v = "10234.00000000";
  //   Assert.isTrue(v.trim().scale == 0);
  //   Assert.isTrue(v.trim(2).scale == 2, 'expected ${v.trim(2)}.scale == 2 but is ${v.trim(2).scale}');
  //   v = "1.20000000";
  //   Assert.isTrue(v.trim().scale == 1, 'expected ${v.trim()}.scale == 1 but got ${v.trim().scale}');
  // }

  // public function testStringExp() {
  //   Assert.isTrue(("1.12345e-10" : Decimal) == "0.000000000112345", 'expected ${("0.000000000112345" : Decimal)} but got ${("1.12345e-10" : Decimal)}');
  //   Assert.isTrue(("1.12345e+10" : Decimal) == "11234500000", 'expected ${("11234500000" : Decimal)} but got ${("1.12345e+10" : Decimal)}');
  //   Assert.isTrue(("-1.12345e-10" : Decimal) == "-0.000000000112345", 'expected ${("-0.000000000112345" : Decimal)} but got ${("-1.12345e-10" : Decimal)}');
  //   Assert.isTrue(("-1.12345e+10" : Decimal) == "-11234500000", 'expected ${("-11234500000" : Decimal)} but got ${("-1.12345e+10" : Decimal)}');
  //   Assert.isTrue(("0E7" : Decimal) == "0", 'expected ${("0" : Decimal)} but got ${("0E7" : Decimal)}');
  //   Assert.isTrue((1.234e-50 : Decimal) == '1.234000e-050', 'expected ${(1.234e-50 : Decimal)} == ${("1.234000e-050" : Decimal)}');
  // }

  // public function testModulo() {
  //   Assert.isTrue((10 : Decimal) % 3 == 1);
  //   Assert.isTrue((10.2 : Decimal) % 3 == 1.2);
  //   Assert.isTrue(("12345678900000000" : Decimal) %  "0.0000000012345678" == "0.0000000009832122");
  //   Assert.isTrue((16.80 : Decimal) % 4.10 == "0.4");
  //   Assert.isTrue((10 : Decimal) % 3 == 1);
  //   Assert.isTrue((10.2 : Decimal) % 3 == 1.2);

  //   Assert.isTrue( (10 : Decimal) % -3 ==  1);
  //   Assert.isTrue((-10 : Decimal) % -3 == -1);
  //   Assert.isTrue((-10 : Decimal) %  3 == -1);

  //   Assert.isTrue( (0 : Decimal) % 3 == "0.0");

  //   Assert.raises(function() (1 : Decimal) % 0);
  // }

  // public function testDivision() {
  //   Assert.isTrue(("12345678900000000" : Decimal) /  "0.0000000012345678" == "10000000729000059778004901.79640194730495967900669367854888");
  //   Assert.isTrue(("12345678901234567890.12346789" : Decimal) / "987654321.987654321" == "12499999874.843750115314464248433558", 'expected ${("12345678901234567890.12346789" : Decimal)} / ${("987654321.987654321" : Decimal)} == ${("12499999874.843750115314464248433558" : Decimal)} but got ${("12345678901234567890.12346789" : Decimal) / ("987654321.987654321" : Decimal)}');
  //   Assert.isTrue(("12345678901234567890.12346789" : Decimal) / "-987654321.987654321" == "-12499999874.843750115314464248433558");
  //   Assert.isTrue(("-12345678901234567890.12346789" : Decimal) / "-987654321.987654321" == "12499999874.843750115314464248433558");
  //   Assert.isTrue(("-12345678901234567890.12346789" : Decimal) / "987654321.987654321" == "-12499999874.843750115314464248433558");
  //   Assert.isTrue(("-12345678901234567890.12346789" : Decimal) / 1 == "-12345678901234567890.12346789");
  //   Assert.isTrue(("-12345678901234567890.12346789" : Decimal) / ("-12345678901234567890.12346789" : Decimal) == 1);
  //   Assert.isTrue((10 : Decimal) / 2 == 5);
  //   Assert.isTrue((10 : Decimal) / 3 == "3.3333333333333333");
  //   Assert.isTrue( (1 : Decimal) / 2 == 0.5);
  //   Assert.isTrue( (1 : Decimal) / 3 == "0.3333333333333333");

  //   Assert.isTrue( (0 : Decimal) / 3 == "0.0");

  //   Assert.raises(function() (1 : Decimal) / 0);
  // }

  // public function testMultiply() {
  //   Assert.isTrue(("12345678900000000" : Decimal) *  "0.0000000012345678" == "15241577.63907942");
  // }

  // public function testInts() {
  //   Assert.isTrue((123 : Decimal) == ("123" : Decimal));
  //   Assert.isTrue((-123 : Decimal) == ("-123" : Decimal));
  //   Assert.isTrue((1234567890 : Decimal) == ("1234567890" : Decimal));
  // }

  // public function testFloats() {
  //   Assert.isTrue((123.456 : Decimal) == ("123.456" : Decimal));
  //   Assert.isTrue((-123.456 : Decimal) == ("-123.456" : Decimal));
  //   Assert.isTrue((0.123456789 : Decimal) == ("0.123456789" : Decimal));
  // }

  // public function testEquality() {
  //   Assert.isTrue(("123.456" : Decimal) == ("123.4560000" : Decimal));
  // }

  // public function testAddition() {
  //   Assert.isTrue(("123.456" : Decimal) + "76.544000" == "200");
  //   Assert.isTrue(("123.456" : Decimal) + "0.004" == "123.46");
  //   Assert.isTrue(("123.456" : Decimal) + "-0.456" == "123");
  // }

  // public function testSubtraction() {
  //   Assert.isTrue(("123.456" : Decimal) - "76.544000" == "46.912000");
  //   Assert.isTrue(("123.456" : Decimal) - "0.004" == "123.452");
  //   Assert.isTrue(("123.456" : Decimal) - "-0.456" == "123.912");
  //   Assert.isTrue(("1514906978" : Decimal) - "1514906971.959475" == "6.040525");
  // }

  // public function testComparison() {
  //   Assert.isTrue(("1" : Decimal) > "0.11111");
  //   Assert.isTrue(("1" : Decimal) > -1);
  //   Assert.isFalse(("1" : Decimal) > 1);
  //   Assert.isTrue(("1" : Decimal) >= 1);
  //   Assert.isTrue(("1" : Decimal) == 1);
  //   Assert.isTrue(("1.01001" : Decimal) == "1.0100100");
  //   Assert.isTrue(("0" : Decimal) == "0");
  //   Assert.isTrue(("0.000" : Decimal) == 0);
  //   Assert.isTrue(("-1.12345e+10" : Decimal) >= "-11234500000");
  //   Assert.isTrue(("-1.12345e+10" : Decimal) <= "-11234500000");
  //   Assert.isTrue(("1.12345e+10" : Decimal) >= "11234500000");
  //   Assert.isTrue(("1.12345e+10" : Decimal) <= "11234500000");
  // }

  // public function testString() {
  //   var tests = ["0", "0.00000789", "0.001", "0.123", "1.0", "1", "1.1", "123456789.0123456789", "123456789.012345678900000"],
  //       dec : Decimal;
  //   for(test in tests) {
  //     dec = test;
  //     Assert.equals(test, dec.toString());

  //     if(test == "0") continue;

  //     dec = '-$test';
  //     Assert.equals('-$test', dec.toString());
  //   }
  // }

  // function assertDecimalEquals(test : Decimal, expected : Decimal, ?pos : haxe.PosInfos) {
  //   Assert.isTrue(test == expected, 'expected $expected but got $test', pos);
  // }

  // public function testRound() {
  //   assertDecimalEquals((0 : Decimal).round(), 0);
  //   assertDecimalEquals((0 : Decimal).ceil(), 0);
  //   assertDecimalEquals((0 : Decimal).floor(), 0);

  //   assertDecimalEquals((1 : Decimal).round(), 1);
  //   assertDecimalEquals((-1 : Decimal).round(), -1);
  //   assertDecimalEquals((1 : Decimal).ceil(), 1);
  //   assertDecimalEquals((-1 : Decimal).ceil(), -1);
  //   assertDecimalEquals((1 : Decimal).floor(), 1);
  //   assertDecimalEquals((-1 : Decimal).floor(), -1);

  //   assertDecimalEquals(("1234567890.1234567890" : Decimal).roundTo(0), "1234567890");
  //   assertDecimalEquals(("1234567890.1234567890" : Decimal).roundTo(3), "1234567890.123");
  //   assertDecimalEquals(("1234567890.1234567890" : Decimal).roundTo(5), "1234567890.12346");
  //   assertDecimalEquals(("1234567890.1234567890" : Decimal).roundTo(6), "1234567890.123457");

  //   assertDecimalEquals(("-1234567890.1234567890" : Decimal).roundTo(0), "-1234567890");
  //   assertDecimalEquals(("-1234567890.1234567890" : Decimal).roundTo(3), "-1234567890.123");
  //   assertDecimalEquals(("-1234567890.1234567890" : Decimal).roundTo(5), "-1234567890.12345");
  //   assertDecimalEquals(("-1234567890.1234567890" : Decimal).roundTo(6), "-1234567890.123456");

  //   assertDecimalEquals(("1234567890.1234567890" : Decimal).ceilTo(0), "1234567891");
  //   assertDecimalEquals(("1234567890.1234567890" : Decimal).ceilTo(3), "1234567890.124");
  //   assertDecimalEquals(("1234567890.1234567890" : Decimal).ceilTo(5), "1234567890.12346");
  //   assertDecimalEquals(("1234567890.1234567890" : Decimal).ceilTo(6), "1234567890.123457");

  //   assertDecimalEquals(("-1234567890.1234567890" : Decimal).ceilTo(0), "-1234567890");
  //   assertDecimalEquals(("-1234567890.1234567890" : Decimal).ceilTo(3), "-1234567890.123");
  //   assertDecimalEquals(("-1234567890.1234567890" : Decimal).ceilTo(5), "-1234567890.12345");
  //   assertDecimalEquals(("-1234567890.1234567890" : Decimal).ceilTo(6), "-1234567890.123456");

  //   assertDecimalEquals(("1234567890.1234567890" : Decimal).floorTo(0), "1234567890");
  //   assertDecimalEquals(("1234567890.1234567890" : Decimal).floorTo(3), "1234567890.123");
  //   assertDecimalEquals(("1234567890.1234567890" : Decimal).floorTo(5), "1234567890.12345");
  //   assertDecimalEquals(("1234567890.1234567890" : Decimal).floorTo(6), "1234567890.123456");

  //   assertDecimalEquals(("-1234567890.1234567890" : Decimal).floorTo(0), "-1234567890");
  //   assertDecimalEquals(("-1234567890.1234567890" : Decimal).floorTo(3), "-1234567890.123");
  //   assertDecimalEquals(("-1234567890.1234567890" : Decimal).floorTo(5), "-1234567890.12345");
  //   assertDecimalEquals(("-1234567890.1234567890" : Decimal).floorTo(6), "-1234567890.123456");
  // }

  // public function testScaleTo() {
  //   var tests = [
  //           { src : "0", exp : "0", scale : 0 },
  //           { src : "0", exp : "0.00000", scale : 5 },
  //           { src : "0.1", exp : "0.100", scale : 3 },
  //           { src : "0.0123456", exp : "0.012", scale : 3 },
  //           { src : "1234567890.1234567890", exp : "1234567890.123", scale : 3 },
  //           { src : "1234567890.1234567890", exp : "1234567890.1234567890", scale : 10 },
  //           { src : "1234567890.1234567890", exp : "1234567890.123456789000", scale : 12 }
  //         ],
  //       dec : Decimal;
  //   for(test in tests) {
  //     dec = test.src;
  //     Assert.equals(test.exp, dec.scaleTo(test.scale).toString(), 'expected ${test.src} to be ${test.exp} when scaled to ${test.scale} but got ${dec.scaleTo(test.scale).toString()}');

  //     if(test.src == "0") continue;

  //     dec = '-${test.src}';
  //     Assert.equals('-${test.exp}', dec.scaleTo(test.scale).toString(), 'expected -${test.src} to be -${test.exp} when scaled to ${test.scale} but got -${dec.scaleTo(test.scale).toString()}');
  //   }
  // }

  // public function testNegativePow() {
  //   Assert.isTrue((10 : Decimal).pow(-2) == 0.01);
  // }
}
