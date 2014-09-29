package thx.core;

import utest.Assert;

class TestSet {
  public function new() { }

  public function testSet() {
    var set : Set<Int> = [1,2,2,2,3];
    Assert.same([1,2,3], (set : Array<Int>));
  }

  public function testUnion() {
    var s1 : Set<Int> = [1,2,3],
        s2 : Set<Int> = [2,2,4];
    Assert.same([1,2,3,4], (s1 + s2 : Array<Int>));
  }

  public function testDifference() {
    var s1 : Set<Int> = [1,2,3],
        s2 : Set<Int> = [2,2,4];
    Assert.same([1,3], (s1 - s2 : Array<Int>));
  }
}
