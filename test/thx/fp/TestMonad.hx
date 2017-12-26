package thx.fp;

import haxe.ds.Option;

import utest.Assert;

import thx.Either;
using thx.Eithers;
using thx.Options;
import thx.fp.Monad.Do;

class TestMonad {
  public function new() {}

  public function testDo_MacroParsing() : Void {
    var x : Int = 0;
    var result : Either<String, Int> = Do(
      a <= Right(1),
      (b : Int) <= Right(a + 2),
      var c = b + 3,
      var d : Int = c + 4,
      _ <= { x = 100; Right(5); }, // side effect
      Right(a + b + c + d)
    );
    Assert.same(Right(20), result);
    Assert.same(100, x);
  }

  public function testDo_Option_Success() : Void {
    var result = Do(
      a <= Some(10),
      b <= Some(2 * a),
      Some(a + b)
    );
    Assert.same(Some(30), result);
  }

  public function testDo_Option_Fail1() : Void {
    var result = Do(
      a <= None,
      b <= { Assert.fail(); Some(2 * a); },
      { Assert.fail(); Some(a + b); }
    );
    Assert.same(None, result);
  }

  public function testDo_Option_Fail2() : Void {
    var result = Do(
      a <= Some(10),
      b <= None,
      { Assert.fail(); Some(a + b); }
    );
    Assert.same(None, result);
  }

  public function testDo_Option_Fail3() : Void {
    var result = Do(
      a <= None,
      b <= { Assert.fail(); None; },
      { Assert.fail(); Some(a + b); }
    );
    Assert.same(None, result);
  }

  public function testDo_Either_Success() : Void {
    var result = Do(
      a <= Right(10),
      b <= Right(2 * a),
      Right(a + b)
    );
    Assert.same(Right(30), result);
  }

  public function testDo_Either_Fail1() : Void {
    var result = Do(
      a <= Right(10),
      b <= Left("fail b"),
      { Assert.fail(); Right(a + b); }
    );
    Assert.same(Left("fail b"), result);
  }

  public function testDo_Either_Fail2() : Void {
    var result = Do(
      a <= Left("fail a"),
      b <= { Assert.fail(); Right(2 * a); },
      { Assert.fail(); Right(a + b); }
    );
    Assert.same(Left("fail a"), result);
  }

  public function testDo_Either_Fail3() : Void {
    var result = Do(
      a <= Left("fail a"),
      b <= { Assert.fail(); Left("fail b"); },
      { Assert.fail(); Right(a + b); }
    );
    Assert.same(Left("fail a"), result);
  }
}
