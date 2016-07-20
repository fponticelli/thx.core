package thx;

import haxe.ds.Option;
import thx.Nel;
using thx.Options;
import thx.Tuple;
import utest.Assert;

class TestNel {
  public function new() {}

  public function testAppend(){
    var nel : Nel<Int> = Single(1);
    nel = nel.append(Single(2));
    Assert.same(ConsNel(1, Single(2)), nel);
    nel = nel.append(ConsNel(3, ConsNel(4, Single(5))));
    Assert.same(ConsNel(1, ConsNel(2, ConsNel(3, ConsNel(4, Single(5))))), nel);
  }

  public function testHead() {
    Assert.same(1, (Single(1): Nel<Int>).head());
    Assert.same(1, (ConsNel(1, Single(2)): Nel<Int>).head());
    Assert.same(1, (ConsNel(1, ConsNel(2, Single(3))): Nel<Int>).head());
  }

  public function testTail() {
    Assert.same([], (Single(1) : Nel<Int>).tail());
    Assert.same([2], (ConsNel(1, Single(2)) : Nel<Int>).tail());
    Assert.same([2, 3], (ConsNel(1, ConsNel(2, Single(3))) : Nel<Int>).tail());
  }

  public function testInit() {
    Assert.same([], (Single(1) : Nel<Int>).init());
    Assert.same([1], (ConsNel(1, Single(2)) : Nel<Int>).init());
    Assert.same([1, 2], (ConsNel(1, ConsNel(2, Single(3))) : Nel<Int>).init());
  }

  public function last() {
    Assert.same(1, (Single(1) : Nel<Int>).last());
    Assert.same(2, (ConsNel(1, Single(2)) : Nel<Int>).last());
    Assert.same(3, (ConsNel(1, ConsNel(2, Single(3))) : Nel<Int>).last());
  }

  public function testPush() {
    var nel : Nel<Int> = Single(1);
    nel = nel.push(2);
    Assert.same(ConsNel(1, Single(2)), nel);
    nel = nel.push(3);
    Assert.same(ConsNel(1, ConsNel(2, Single(3))), nel);
  }

  public function testPop() {
    Assert.same(new Tuple(1, []), (Single(1) : Nel<Int>).pop());
    Assert.same(new Tuple(2, [1]), (ConsNel(1, Single(2)) : Nel<Int>).pop());
    Assert.same(new Tuple(3, [1, 2]), (ConsNel(1, ConsNel(2, Single(3))) : Nel<Int>).pop());
  }

  public function testUnshift() {
    var nel : Nel<Int> = Single(1);
    nel = nel.unshift(2);
    Assert.same(ConsNel(2, Single(1)), nel);
    nel = nel.unshift(3);
    Assert.same(ConsNel(3, ConsNel(2, Single(1))), nel);
  }

  public function testShift() {
    Assert.same(new Tuple(1, []), (Single(1) : Nel<Int>).shift());
    Assert.same(new Tuple(1, [2]), (ConsNel(1, Single(2)) : Nel<Int>).shift());
    Assert.same(new Tuple(1, [2, 3]), (ConsNel(1, ConsNel(2, Single(3))) : Nel<Int>).shift());
  }

  public function testToArray() {
    Assert.same([1], Nel.pure(1).toArray());
    Assert.same([1, 2, 3, 4, 5], (ConsNel(1, ConsNel(2, ConsNel(3, ConsNel(4, Single(5))))) : Nel<Int>).toArray());
  }
}
