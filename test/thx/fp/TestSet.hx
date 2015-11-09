package thx.fp;

import utest.Assert;
using thx.fp.Sets;
using thx.Arrays;

class TestSet {
  public function new() {}

  public function testEmpty() {
    var set : Set<String> = Set.empty();
    Assert.isFalse(set.exists("some"));
    Assert.equals(0, set.size());
  }

  public function testSizes() {
    Assert.equals(3, Set.singleton("B").set("A").set("C").size());
    Assert.equals(3, Set.singleton("A").set("B").set("C").size());
    Assert.equals(3, Set.singleton("C").set("B").set("A").size());
    Assert.equals(3, Set.singleton("B").set("C").set("A").size());
    Assert.equals(3, Set.singleton("C").set("A").set("B").size());
    Assert.equals(3, Set.singleton("A").set("C").set("B").size());

    Assert.equals(1, Set.singleton("A").set("A").set("A").size());
  }

  public function testSet() {
    var m = Set.singleton("Y").set("X").set("Y").set("Z").set("Z");
    Assert.isTrue(m.exists("X"));
    Assert.isTrue(m.exists("Y"));
    Assert.isTrue(m.exists("Z"));
    Assert.isFalse(m.exists("W"));
    Assert.equals(3, m.size());
  }

  public function testMapList() {
    var m = Set.singleton("Y").set("X").set("Z"),
        l = m.mapList(function(v) return v.toLowerCase());

    Assert.same(["x", "y", "z"], l.toArray().order(Strings.compare));
  }

  public function testFoldLeft() {
    var set = Set.singleton(1).set(2).set(3);
    Assert.same([1,2,3], set.foldLeft([], function(acc, v) {
      acc.push(v);
      return acc;
    }).order(Ints.compare));
  }

  public function testToList() {
    var m = Set.singleton("Y").set("X").set("Z"),
        l = m.toList();

    Assert.same(["X", "Y", "Z"], l.toArray().order(Strings.compare));
  }
}
