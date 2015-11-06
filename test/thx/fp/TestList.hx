package thx.fp;

import utest.Assert;
using thx.fp.List;
import thx.Functions.*;

class TestList {
  public function new() {}

  public function testFoldLeft() {
    var list : List<Int> = Cons(1, Cons(2, Cons(3, Nil)));
    Assert.equals(6, list.foldLeft(0, fn(_0 + _1)));

    Assert.same([1,2,3], list.foldLeft([], function(acc, v) {
      acc.push(v);
      return acc;
    }));
  }

  public function testToArray() {
    var list : List<Int> = Cons(1, Cons(2, Cons(3, Nil)));
    Assert.same([1,2,3], list.toArray());
  }

  public function testIntersperse() {
    var list : List<Int> = Cons(1, Cons(2, Cons(3, Nil))),
        interspersed = list.intersperse(0),
        arr = interspersed.toArray();
    Assert.same([1,0,2,0,3], arr);
  }

  public function testFromArray() {
    var arr = [1,2,3,4];
    Assert.same(arr, (arr : List<Int>).toArray());
  }

  public function testConcat() {
    var l1 : List<Int> = Cons(1, Cons(2, Nil)),
        l2 : List<Int> = Cons(3, Cons(4, Nil)),
        l = l1.concat(l2);
    trace(l.toString());
    Assert.same([1,2,3,4], l.toArray());
  }

  public function testToString() {
    var list : List<Int> = Cons(1, Cons(2, Cons(3, Nil)));
    Assert.same("[1,2,3]", list.toString());

    var list : List<String> = Cons("1", Cons("2", Cons("3", Nil)));
    Assert.same("[1,2,3]", list.toString());
  }

  public function testMap() {
    var list : List<Int> = Cons(1, Cons(2, Cons(3, Nil)));
    Assert.same([2,4,6], list.map(function(v) return v * 2).toArray());
  }

  public function testFlatMap() {
    var list : List<Int> = Cons(1, Cons(2, Cons(3, Nil)));
    function map(v : Int) {
      if(v == 0)
        return List.empty();
      else
        return List.bin(v, map(v-1));
    }
    var slist = list.flatMap(map);
    trace(slist.toString());
    trace(slist.toArray());
    Assert.same([1,2,1,3,2,1], slist.toArray());
  }
}
