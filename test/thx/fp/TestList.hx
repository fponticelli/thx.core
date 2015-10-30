package thx.fp;

import utest.Assert;
import thx.fp.List;
import thx.Functions.*;

class TestList {
  public function new() {}

  public function testFoldLeft() {
    var list : List<Int> = Cons(1, Cons(2, Cons(3, Empty)));
    Assert.equals(6, list.foldLeft(0, fn(_0 + _1)));
  }

  public function testToArray() {
    var list : List<Int> = Cons(1, Cons(2, Cons(3, Empty)));
    Assert.same([1,2,3], list.toArray());
  }

  public function testFromArray() {
    var arr = [1,2,3,4],
        list : List<Int> = arr;
    Assert.same(arr, list.toArray());
  }
}
