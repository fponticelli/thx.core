package thx;

import utest.Assert;

class TestOrderedSet {
  public function new() { }

  public function testCreate() {
    var set = OrderedSet.create();
    Assert.equals(0, set.length);
    set.add(1);
    set.add(1);
    Assert.equals(1, set.length);
  }

  public function testOrderedSet() {
    var set : OrderedSet<Int> = [1,2,2,2,3];
    Assert.same([1,2,3], (set : Array<Int>));
  }

  public function testUnion() {
    var s1 : OrderedSet<Int> = [1,2,3],
        s2 : OrderedSet<Int> = [2,2,4];
    Assert.same([1,2,3,4], (s1 + s2 : Array<Int>));
  }

  public function testDifference() {
    var s1 : OrderedSet<Int> = [1,2,3],
        s2 : OrderedSet<Int> = [2,2,4];
    Assert.same([1,3], (s1 - s2 : Array<Int>));
  }

  public function testBooleans() {
    var s = ([1,2,3] : OrderedSet<Int>).union([2,3,4]).difference([2,3]);
    Assert.same([1,4], s);
  }
}
