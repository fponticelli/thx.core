package thx.core;

import utest.Assert;

class TestSet {
  public function new() { }

  public function testSet() {
    var set : Set<Int> = [1,2,2,2,3];
    Assert.same([1,2,3], (set : Array<Int>));
  }
}
