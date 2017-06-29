package thx;

import haxe.ds.Option;

import utest.Assert;

import thx.Either;
using thx.Functions;

class TestFunctions {
  public function new() { }

  public function testAfter() {
    var counter = 0,
        test    = function() Assert.equals(1, ++counter),
        manage  = Functions0.after(test, 3);

    Assert.equals(0, counter);
    manage();
    Assert.equals(0, counter);
    manage();
    Assert.equals(0, counter);
    manage();
    Assert.equals(1, counter);
    manage();
    Assert.equals(1, counter);
  }

  public function testOnce() {
    var counter = 0,
        test    = function() Assert.equals(1, ++counter),
        manage  = Functions0.once(test);

    Assert.equals(0, counter);
    manage();
    Assert.equals(1, counter);
    manage();
    Assert.equals(1, counter);
  }

  public function testMemoize0() {
    var counter = 0;
    var test = function() {
      ++counter;
      return 10;
    };
    var memoized = Functions0.memoize(test);
    Assert.equals(0, counter);
    Assert.equals(10, memoized());
    Assert.equals(1, counter);
    Assert.equals(10, memoized());
    Assert.equals(1, counter);
    Assert.equals(10, memoized());
  }

  public function testMemoize1() {
    var counter = 0,
        test    = function(x) {
          ++counter;
          return x * 10;
        },
        manage  = Functions1.memoize(test);

    Assert.equals(0, counter);
    Assert.equals(10, manage(1));
    Assert.equals(1, counter);
    Assert.equals(10, manage(1));
    Assert.equals(1, counter);
    Assert.equals(20, manage(2));
    Assert.equals(2, counter);
  }

  public function testNegate() {
    Assert.isFalse((function() return true).negate()());
  }

  public function testPassTo() {
    var arr : Array<Int> = [1, 2, 3];
    Assert.same(Some(arr), arr.passTo(thx.Options.ofValue));
    Assert.same(Right(arr), arr.passTo(Right));
    Assert.same(Left(arr), arr.passTo(Left));
    Assert.same([1], 1.passTo(Arrays.fromItem));
  }

  public function testApplyTo() {
    Assert.same(1, thx.Functions.identity.applyTo(1));
    Assert.same(Some(1), Options.ofValue.applyTo(1));
    Assert.same(None, Options.ofValue.applyTo(null));
  }
}
