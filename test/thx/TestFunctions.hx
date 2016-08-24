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

  public function testMemoize() {
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

  public function testLift() {
    var arr : Array<Int> = [1, 2, 3];
    Assert.same(Some(arr), arr.lift(thx.Options.ofValue));
    Assert.same(Right(arr), arr.lift(Right));
    Assert.same(Left(arr), arr.lift(Left));
    Assert.same([1], 1.lift(Arrays.fromItem));
  }
}
