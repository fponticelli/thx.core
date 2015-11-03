package thx.fp;

import utest.Assert;
using thx.fp.List;
import thx.Functions.*;

class TestList {
  public function new() {}

  public function testFoldLeft() {
    var list : List<Int> = Cons(1, Cons(2, Cons(3, Nil)));
    Assert.equals(6, list.foldLeft(0, fn(_0 + _1)));
  }

  public function testToArray() {
    var list : List<Int> = Cons(1, Cons(2, Cons(3, Nil)));
    Assert.same([1,2,3], list.toArray());
  }

  public function testIntersperse() {
    var list : List<Int> = Cons(1, Cons(2, Cons(3, Nil))),
        interspersed = list.intersperse(7),
        arr = interspersed.toArray();
    Assert.same([1,7,2,7,3], arr);
  }

  public function testFromArray() {
    var arr = [1,2,3,4],
        list : List<Int> = arr;
    Assert.same(arr, list.toArray());
  }

  public function testToString() {
    var list : List<Int> = Cons(1, Cons(2, Cons(3, Nil)));
    Assert.same("[1,2,3]", list.toString());
  }
}
