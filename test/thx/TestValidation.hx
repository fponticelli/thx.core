package thx;

import thx.Either;
import thx.Validation;
import thx.Validation.*;
import thx.Nel;
import thx.Nel.*;

using thx.Eithers;
using thx.Functions;
using thx.Validation.ValidationExtensions;

import utest.Assert;

class TestValidation {
  public function new() {}

  public function or4(b1: Bool, b2: Bool, b3: Bool, b4: Bool): Bool {
    return b1 || b2 || b3 || b4;
  }

  public function add(a: Int, b: Int) { return a + b; }

  public function testAp() {
    var l1: Validation<Int, Bool> = Left(1);
    var rt: Validation<Int, Bool> = Right(true);

    var rbi: Validation<Int, Bool -> Int> = Right(function(b: Bool) { return if (b) 1 else 0; });

    Assert.same(l1, l1.ap(rbi, add));
    Assert.same((Right(1): Validation<Int, Int>), rt.ap(rbi, add));
  }

  public function testVal1() {
    Assert.same(Right({ val: 42 }), val1(function(v) return { val: v }, successNel(42)));
    Assert.same(Left(Single(1)), val1(function(v) return { val: v }, failureNel(1)));
  }

  // val4 is defined in terms of val3, and then ultimately in terms
  // of val2 and ap so this implicitly tests all of those functions
  public function testVal4() {
    var t: Validation<Int, Bool> = Right(true);
    var f: Validation<Int, Bool> = Right(false);
    var err: Validation<Int, Bool> = Left(1);

    Assert.same(t, val4(or4, t, f, f, f, add));
    Assert.same((Left(2): Validation<Int, Bool>), val4(or4, t, f, err, err, add));
  }

  public function testVal4Nel() {
    var t: VNel<Int, Bool> = Right(true);
    var err: VNel<Int, Bool> = Left(Nel.pure(1));

    Assert.same(Left(Nel.cons(1, Nel.pure(1))), val4(or4, t, t, err, err, semigroup()));
  }

  public function testAppendVNel() {
    Assert.same(Right([1, 2, 3, 4]), VNel.successNel([1, 2, 3]).appendVNel(Right(4)));
    Assert.same(Left(Nel.pure("target error")), VNel.failureNel("target error").appendVNel(Right(4)));
    Assert.same(Left(Nel.pure("item error")), VNel.successNel([1, 2, 3]).appendVNel(Left(Nel.pure("item error"))));
    Assert.same(Left(Nel.nel("target error", ["item error"])), VNel.failureNel("target error").appendVNel(Left(Nel.pure("item error"))));
  }

  public function testAppendValidation() {
    Assert.same(Right([1, 2, 3, 4]), VNel.successNel([1, 2, 3]).appendValidation(Right(4)));
    Assert.same(Left(Nel.pure("target error")), VNel.failureNel("target error").appendValidation(Right(4)));
    Assert.same(Left(Nel.pure("item error")), VNel.successNel([1, 2, 3]).appendValidation(Left("item error")));
    Assert.same(Left(Nel.nel("target error", ["item error"])), VNel.failureNel("target error").appendValidation(Left("item error")));
  }

  public function testAppendVNels() {
    Assert.same(Right([1, 2, 3, 4, 5]), VNel.successNel([1, 2, 3]).appendVNels([Right(4), Right(5)]));
    Assert.same(Left(Nel.pure("target error")), VNel.failureNel("target error").appendVNels([Right(4), Right(5)]));
    var errorItems : Array<VNel<String, Int>> = [Left(Nel.pure("item error 1")), Right(4), Left(Nel.pure("item error 2")), Right(5)];
    Assert.same(Left(Nel.nel("item error 1", ["item error 2"])), VNel.successNel([1, 2, 3]).appendVNels(errorItems));
    Assert.same(Left(Nel.nel("target error", ["item error 1", "item error 2"])), VNel.failureNel("target error").appendVNels(errorItems));
  }

  public function testAppendValidations() {
    Assert.same(Right([1, 2, 3, 4, 5]), VNel.successNel([1, 2, 3]).appendValidations([Right(4), Right(5)]));
    Assert.same(Left(Nel.pure("target error")), VNel.failureNel("target error").appendValidations([Right(4), Right(5)]));
    var errorItems : Array<Validation<String, Int>> = [Left("item error 1"), Right(4), Left("item error 2"), Right(5)];
    Assert.same(Left(Nel.nel("item error 1", ["item error 2"])), VNel.successNel([1, 2, 3]).appendValidations(errorItems));
    Assert.same(Left(Nel.nel("target error", ["item error 1", "item error 2"])), VNel.failureNel("target error").appendValidations(errorItems));
  }
}
