package thx.fp;

import thx.fp.TreeBag.*;
import thx.Functions.*;

import utest.Assert;

class TestTreeBag {
  public function new() {}

  static var t0 : TreeBag<Int> = empty();
  static var t1 : TreeBag<Int> = cons(1, cons(2, t0));
  static var t2 : TreeBag<Int> = cons(2, cons(3, t0));

  public function plusOneBag(i: Int): TreeBag<Int> {
    return cons(i + 1, t0);
  }

  public function plusTwoBags(i: Int): TreeBag<Int> {
    return t1.map(function (i0: Int) { return i + i0; });
  }

  public function testMap() {
    Assert.same(t0, t0.map(identity));
    Assert.same(t2, t1.map(function (i: Int) { return i + 1; }));
  }

  public function testToArray() {
    Assert.same([1, 2], t1.toArray());
  }

  public function testFlatMap() {
    Assert.same(t2.toArray(), t1.flatMap(plusOneBag).toArray());
    Assert.same(cons(2, cons(3, t0)) + (cons(3, cons(4, t0)) + t0), t1.flatMap(plusTwoBags));
  }
}
