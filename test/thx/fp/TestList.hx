package thx.fp;

import utest.Assert;
import thx.fp.List;
using thx.fp.Lists;
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
        interspersed = list.intersperse(0);
    Assert.same(Cons(1, Cons(0, Cons(2, Cons(0, Cons(3, Nil))))), interspersed);
  }

  public function testFromArray() {
    var arr = [1,2,3,4];
    Assert.same(arr, (arr : List<Int>).toArray());
  }

  public function testConcat() {
    var l1 : List<Int> = Cons(1, Cons(2, Nil)),
        l2 : List<Int> = Cons(3, Cons(4, Nil)),
        l = l1.concat(l2);
    Assert.same(Cons(1, Cons(2, Cons(3, Cons(4, Nil)))), l);
  }

  public function testToString() {
    var list : List<Int> = Cons(1, Cons(2, Cons(3, Nil)));
    Assert.same("[1,2,3]", list.toString());

    var list : List<String> = Cons("1", Cons("2", Cons("3", Nil)));
    Assert.same("[1,2,3]", list.toString());
  }

  public function testMap() {
    var list : List<Int> = Cons(1, Cons(2, Cons(3, Nil)));
    Assert.same(Cons(2, Cons(4, Cons(6, Nil))), list.map(function(v) return v * 2));
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
    Assert.same(Cons(1, Cons(2, Cons(1, Cons(3, Cons(2, Cons(1, Nil)))))), slist);
  }

  // This transitively tests zipAp and zip2Ap..zip5Ap
  public function testZip5Ap() {
    var sx = List.fromArray(["a", "b", "c"]);
    var ix = List.fromArray([1, 2]);
    var tx = List.fromArray(["x", "y", "z"]);
    var jx = List.fromArray([3, 4]);
    var bx = List.fromArray([true, false, true]);

    Assert.same(List.fromArray(["a1x3true", "b2y4false"]), List.zip5Ap(function(s: String, i: Int, t: String, j: Int, b: Bool) return '$s$i$t$j$b', sx, ix, tx, jx, bx));
  }
}
