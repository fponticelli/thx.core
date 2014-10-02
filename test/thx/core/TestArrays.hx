/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

import utest.Assert;
using thx.core.Arrays;

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

  public function testMapRight() {
    Assert.same([6,4,2], [1,2,3].mapRight(function(v) return v * 2));
  }

  public function testPluckRight() {
    Assert.same([6,4,2], [1,2,3].pluckRight(_ * 2));
  }

  public function testReduceRight() {
    Assert.same('CBA', ['a','b','c'].reduceRight(function(acc, v) return acc + v.toUpperCase(), ''));
  }
}

private class Sample {
  var v : Int;
  public function new(v : Int)
    this.v = v;
  public function multiply(by : Int)
    return v * by;
}