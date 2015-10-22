package thx;

using thx.Either;
using thx.Disjunction;
using thx.Functions;

import utest.Assert;

class TestDisjunction {
  public function new() {}

  public function absurd(b: Bool): Disjunction<Int, Bool>
                                   return if (b) Right(!b) else Left(1);

  public function testFlatMap() {
    var l: Disjunction<Int, Bool> = Left(1);
    var rt: Disjunction<Int, Bool> = Right(true);
    var rf: Disjunction<Int, Bool> = Right(false);
    Assert.same(l, l.flatMap(absurd));
    Assert.same(rf, rt.flatMap(absurd));
    Assert.same(l, rt.flatMap(absurd).flatMap(absurd));
    Assert.same(rt.flatMap(absurd).flatMap(absurd), rt.flatMap(function(b) { return absurd(b).flatMap(absurd); }));
  }

  public function testLeftMap() {
    var l: Disjunction<Int, Bool> = Left(1);
    var rt: Disjunction<Int, Bool> = Right(true);
    var l2: Disjunction<Int, Bool> = Left(2);
    Assert.same(l2, l.leftMap(function(i) { return i + 1; }));
    Assert.same(rt, rt.leftMap(function(i) { return i + 1; }));
  }
}

