/**
 * @author Franco Ponticelli
 */

package thx;

import utest.Assert;
import thx.ReadonlyArray;

class TestReadonlyArray {
  public function new() { }

  public function testInsertAt() {
    var a : ReadonlyArray<Int> = [1,2,4],
        b = a.insertAt(0, 0);
    Assert.isTrue(a != b);
    Assert.same([0,1,2,4], b);

    b = a.insertAt(2, 3);
    Assert.same([1,2,3,4], b);

    b = a.insertAt(10, 5);
    Assert.same([1,2,4,5], b);
  }

  public function testReplaceAt() {
    var a : ReadonlyArray<Int> = [1,2,4],
        b = a.replaceAt(0, 0);
    Assert.isTrue(a != b);
    Assert.same([0,2,4], b);

    b = a.replaceAt(2, 3);
    Assert.same([1,2,3], b);

    b = a.replaceAt(10, 5);
    Assert.same([1,2,4,5], b);
  }

  public function testReduce() {
    var a: ReadonlyArray<Int> = [1,2,3];
    Assert.equals(6, a.reduce(function(a, v) return a + v, 0));
    Assert.equals(9, a.reducei(function(a, v, i) return a + v + i, 0));
  }

  public function testPush() {
    var a : ReadonlyArray<Int> = [1, 2, 3];
    var b = a.push(4);
    Assert.same([1, 2, 3], a);
    Assert.same([1, 2, 3, 4], b);
  }

  public function testPop() {
    var a : ReadonlyArray<Int> = [1, 2];

    var result = a.pop();
    Assert.same(2, result._0);
    Assert.same([1], result._1);
    var b = result._1;

    result = b.pop();
    Assert.same(1, result._0);
    Assert.same([], result._1);
    var c = result._1;

    result = c.pop();
    Assert.isNull(result._0);
    Assert.same([], result._1);

    Assert.same([1, 2], a);
  }

  public function testShift() {
    var a : ReadonlyArray<Int> = [1, 2];

    var result = a.shift();
    Assert.same(1, result._0);
    Assert.same([2], result._1);
    var b = result._1;

    result = b.shift();
    Assert.same(2, result._0);
    Assert.same([], result._1);
    var c = result._1;

    result = c.shift();
    Assert.isNull(result._0);
    Assert.same([], result._1);

    Assert.same([1, 2], a);
  }

  public function testUnshift() {
    var a : ReadonlyArray<Int> = [1, 2, 3];
    var b = a.unshift(4);
    Assert.same([1, 2, 3], a);
    Assert.same([4, 1, 2, 3], b);
  }
}
