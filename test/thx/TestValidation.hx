package thx;

import thx.Either;
import thx.Validation;
import thx.Validation.*;
import thx.Nel;
import thx.Nel.*;

using thx.Eithers;
using thx.Functions;

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
}


