package thx;

import utest.Assert;
using thx.Arrays;

class TestSet {
  public function new() { }

  public function testCreate() {
    var set = Set.createInt();
    Assert.equals(0, set.length);
    set.add(1);
    set.add(1);
    Assert.equals(1, set.length);
  }

  public function testSet() {
    var set = Set.createInt([1,2,2,2,3]);
    Assert.same([1,2,3], (set : Array<Int>).order(Ints.compare));
  }

  public function testUnion() {
    var s1 = Set.createInt([1,2,3]),
        s2 = Set.createInt([2,2,4]);
    Assert.same([1,2,3,4], (s1 + s2 : Array<Int>).order(Ints.compare));
  }

  public function testDifference() {
    var s1 = Set.createInt([1,2,3]),
        s2 = Set.createInt([2,2,4]);
    Assert.same([1,3], (s1 - s2 : Array<Int>).order(Ints.compare));
  }

  // public function testBooleans() {
  //   var s = Set.createInt([1,2,3])
  //             .union(Set.createInt([2,3,4]))
  //             .difference(Set.createInt([2,3]));
  //   Assert.same([1,4], s.order(Ints.compare));
  // }
}
