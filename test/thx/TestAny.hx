package thx;

#if (haxe_ver >= 3.4)
import Any as HaxeAny;
#end

import utest.Assert;

class TestAny {
  public function new() {}

  public function testUnsafeCast() {
    var a = Any.ofValue(123);
    var b = Any.ofValue(100);
    var aInt : Int = a.unsafeCast();
    var bInt : Int = b.unsafeCast();
    Assert.same(223, aInt + bInt);
  }

  public function testOfValue() {
    var a = Any.ofValue(3);
    var b = Any.ofValue("hi");
    Assert.same(3, a);
    Assert.same("hi", b);
  }

#if (haxe_ver >= 3.4)
  public function testFromHaxeAny() {
    var haxeAny : HaxeAny = 123;
    var any = Any.fromHaxeAny(123);
    var int : Int = any.unsafeCast();
    Assert.same(123, int);
  }

  public function testToHaxeAny() {
    var any : Any = Any.ofValue(123);
    var haxeAny : HaxeAny = any.toHaxeAny();
    var int : Int = haxeAny;
    Assert.same(123, int);
  }
#end
}
