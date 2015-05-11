/**
 * ...
 * @author Franco Ponticelli
 */

package thx;

import utest.Assert;
using thx.Arrays;
using thx.Floats;

class TestArrays {
  public function new() { }

  public function testCrossMulti() {
    var r = [[1,2],[3,4],[5,6]].crossMulti();
    Assert.same([[1,3,5],[2,3,5],[1,4,5],[2,4,5],[1,3,6],[2,3,6],[1,4,6],[2,4,6]], r);
  }

  public function testMapField() {
    var arr  = [{a:1},{a:2},{a:3}],
        test = Arrays.pluck(arr, _.a);
    Assert.same([1,2,3], test);
  }

  public function testMapFieldOnFunction() {
    var test = Arrays.pluck([
          new Sample(2),
          new Sample(3),
          new Sample(4)
        ], _.multiply(2));
    Assert.same([4,6,8], test);
  }

  public function testUsingMapField() {
    var arr  = [{a:1},{a:2},{a:3}],
        test = arr.pluck(_.a);
    Assert.same([1,2,3], test);
  }

  public function testUsingMapFieldiOnFunction() {
    Assert.same(
        [0,3,8],
        [
          new Sample(2),
          new Sample(3),
          new Sample(4)
        ].plucki(_.multiply(i))
      );
  }

  public function testFilterPluck() {
    Assert.same([1,3,5], [1,2,3,4,5,6].filterPluck(_ % 2 != 0));
  }

  public function testFind() {
    Assert.equals(3, [1,3,5,7,9].find(function(item) return item % 3 == 0));
  }

  public function testFindLast() {
    Assert.equals(9, [1,3,5,7,9].findLast(function(item) return item % 3 == 0));
  }

  public function testPluck() {
    Assert.same([2,4,8], [1,2,4].pluck(_ * 2));
  }

  public function testMinFloats() {
    Assert.floatEquals(0.5, [1.5, 0.5, 1.0].min());
  }

  public function testMinInts() {
    Assert.equals(1, [2, 5, 1].min());
  }

  public function testMaxFloats() {
    Assert.floatEquals(1.5, [1.5, 0.5, 1.0].max());
  }

  public function testMaxInts() {
    Assert.equals(5, [2, 5, 1].max());
  }

  public function testAverageFloats() {
    Assert.floatEquals(1.0, [2.5, 0.5, 0.0].average());
  }

  public function testAverageInts() {
    Assert.equals(3.0, [2, 6, 1].average());
  }

  public function testMinString() {
    Assert.equals('A', ['B', 'C', 'A'].min());
  }

  public function testMaxStrings() {
    Assert.equals('C', ['B', 'C', 'A'].max());
  }

  public function testCompactFloats() {
    Assert.same([1.5, 0.5, 1.0], [Math.NaN, 1.5, null, 0.5, 1.0].compact());
  }

  public function testCompactStrings() {
    Assert.same(['B', 'C', 'A'], ['B', '', 'C', null, 'A', ''].compact());
  }

  public function testCompactInt() {
    Assert.same([1, 0, 2], [null, 1, null, 0, 2].compact());
  }

  public function testOrder() {
    var arr = [2,3,1];
    Assert.same([1,2,3], arr.order(function(_0, _1) return _0 - _1));
    Assert.same([2,3,1], arr);
  }

  public function testOrderPluck() {
    var arr = [2,3,1];
    Assert.same([1,2,3], arr.orderPluck(_0 - _1));
    Assert.same([2,3,1], arr);
  }

  public function testOrderPluckObjectOfInt() {
    var obj1 = { key: 1 };
    var obj2 = { key: 2 };
    var obj3 = { key: 3 };
    var arr = [obj2, obj3, obj1];
    Assert.same([obj1, obj2, obj3], arr.orderPluck(_0.key - _1.key));
    Assert.same([obj2, obj3, obj1], arr);
  }

  public function testOrderPluckObjectOfFloat() {
    var obj1 = { key: 1.0 };
    var obj2 = { key: 2.0 };
    var obj3 = { key: 3.0 };
    var arr = [obj2, obj3, obj1];
    Assert.same([obj1, obj2, obj3], arr.orderPluck(_0.key.compare(_1.key)));
    Assert.same([obj2, obj3, obj1], arr);
  }

  public function testSortPluck() {
    var arr = [2,3,1];
    arr.sortPluck(_0 - _1);
    Assert.same([1,2,3], arr);
  }

  public function testCount() {
    var arr = [2,3,2,1,4,2,3],
        map = arr.count();
    Assert.equals(3, map.get(2));
    Assert.equals(2, map.get(3));
    Assert.equals(1, map.get(1));
    Assert.equals(1, map.get(4));
  }

  public function testGroupBy() {
    var arr = [2.1,3.5,2.0,1.4,2.7,3.0],
        map = arr.groupBy(function(f) return Math.floor(f));
    Assert.same([2.1, 2.0, 2.7], map.get(2));
    Assert.same([3.5, 3.0], map.get(3));
    Assert.same([1.4], map.get(1));
  }

  public function testGroupByArray() {
    var arr = [[0,1],[0,2],[1,1]],
        map = arr.groupBy(function(f) return f[0]);
    Assert.same([
        0 => [[0,1], [0,2]],
        1 => [[1,1]]
      ], map);
  }

  public function testGroupByInstance() {
    var arr = [new Sample(1),new Sample(1),new Sample(2)],
        map = arr.groupBy(function(f) return f.v);
    Assert.same([
        1 => [new Sample(1), new Sample(1)],
        2 => [new Sample(2)]
      ], map);
  }

  public function testGroupByAnonymous() {
    var panels = [{ level : 1 }, { level : 2 }];
    var results = panels.groupByAppend(function(el) : Int return el.level, new Map());
    Assert.same([
      1 => [{ level : 1 }],
      2 => [{ level : 2 }],
    ], results);
  }

  public function testMapRight() {
    Assert.same([6,4,2], [1,2,3].mapRight(function(v) return v * 2));
  }

  public function testPluckRight() {
    Assert.same([6,4,2], [1,2,3].pluckRight(_ * 2));
  }

  public function testReduceRight() {
    Assert.same('CBA', ['a','b','c'].reduceRight(function(acc, v) return acc + v.toUpperCase(), ''));
  }

  public function testRotate() {
    Assert.same(
      [["a0", "a1", "a2"], ["b0", "b1", "b2"]],
      Arrays.rotate(
        [["a0", "b0"], ["a1", "b1"], ["a2", "b2"]]
      ));
  }

  public function testDistinct() {
    Assert.same([1, 2, 3, 4, 5, 6, 7, 8], [1, 2, 2, 3, 4, 5, 5, 6, 7, 8, 8].distinct());
    Assert.same([8, 1, 2, 7, 3, 4, 5, 6], [8, 8, 1, 2, 7, 2, 3, 4, 5, 1, 5, 6, 7, 8, 2, 8].distinct());
    Assert.same(["one", "two", "three"], ["one", "two", "one", "two", "three", "one", "two"].distinct());
    Assert.same([false, true], [false, false, true, false, true, true].distinct());

    var array = [{ key: "one" }, { key: "two" }, { key: "one" }, { key: "three" }, { key: "two" }];
    var result = array.distinct(function(a, b) {
      return a.key == b.key;
    });
    Assert.same([{ key: "one" }, { key: "two" }, { key: "three" }], result);
  }

  public function testSplit() {
    var arr = [1,2,3,4,5,6,7,8,9,0];
    Assert.same([[1,2,3,4,5,6,7,8,9,0]], arr.split(1));
    Assert.same([[1,2,3,4,5],[6,7,8,9,0]], arr.split(2));
    Assert.same([[1,2,3,4],[5,6,7,8],[9,0]], arr.split(3));
    Assert.same([[1,2,3],[4,5,6],[7,8,9],[0]], arr.split(4));
    Assert.same([[1],[2],[3],[4],[5],[6],[7],[8],[9],[0]], arr.split(10));
    Assert.same([[1],[2],[3],[4],[5],[6],[7],[8],[9],[0]], arr.split(20));
  }

  public function testSplitBy() {
    var arr = [1,2,3,4,5,6,7,8,9,0];
    Assert.same([[1],[2],[3],[4],[5],[6],[7],[8],[9],[0]], arr.splitBy(1));
    Assert.same([[1,2],[3,4],[5,6],[7,8],[9,0]], arr.splitBy(2));
    Assert.same([[1,2,3],[4,5,6],[7,8,9],[0]], arr.splitBy(3));
    Assert.same([[1,2,3,4],[5,6,7,8],[9,0]], arr.splitBy(4));
    Assert.same([[1,2,3,4,5,6,7,8,9,0]], arr.splitBy(10));
    Assert.same([[1,2,3,4,5,6,7,8,9,0]], arr.splitBy(20));
  }
}

private class Sample {
  public var v : Int;
  public function new(v : Int)
    this.v = v;
  public function multiply(by : Int)
    return v * by;
}
