package thx;

import utest.Assert;

class TestConvert {
  public function new() {}

  public function testString() {
    Assert.equals("1", Convert.toString(1));
    Assert.equals("1", Convert.toStringOr(null, "1"));
  }

  public function testInt() {
    Assert.equals(1, Convert.toInt("1"));
    Assert.equals(1, Convert.toInt(true));
    Assert.equals(0, Convert.toInt(false));
    Assert.equals(1, Convert.toInt(1.1));

    Assert.equals(1, Convert.toIntOr("z", 1));
  }

  public function testFloat() {
    Assert.equals(1, Convert.toFloat("1"));
    Assert.equals(1, Convert.toFloat(true));
    Assert.equals(0, Convert.toFloat(false));
    Assert.equals(1.1, Convert.toFloat(1.1));

    Assert.equals(1.1, Convert.toFloatOr("z", 1.1));
  }

  public function testBool() {
    Assert.equals(true, Convert.toBool("1"));
    Assert.equals(true, Convert.toBool(true));
    Assert.equals(false, Convert.toBool(false));
    Assert.equals(true, Convert.toBool(1.1));
    Assert.equals(false, Convert.toBool(0));

    Assert.equals(true, Convert.toBoolOr("z", true));
  }

  public function testMap() {
    var objOfArrays = { "foo" : ["bar"], "baz" : ["qux"] },
        objOfNumbers = { "a" : 1, "b" : 2, "c" : 3 };

    Assert.equals("bar", Convert.toMap(objOfArrays, function (val) {
      return Convert.toArray(val, Convert.toString);
    }).get("foo")[0]);

    Assert.equals(2, Convert.toMap(objOfNumbers, Convert.toInt).get("b"));

    Assert.raises(function () Convert.toMap(3, Convert.toString));
    Assert.raises(function () Convert.toMap(objOfArrays, Convert.toString));
  }

  public function testDateTimeUtc() {
    var value : Dynamic = null,
        date = Convert.toDateTimeUtc(value);
    Assert.isNull(value);
  }

  public function testToObject() {
    var value : Dynamic = "text";
    Assert.same({}, Convert.toObjectOr(value, {}));
  }
}
