package thx.fp;

import haxe.ds.Option;
import utest.Assert;
using thx.fp.Map;
import thx.Functions.*;
import thx.Strings.*;

class TestMap {
  public function new() {}

  public function testEmpty() {
    var m : Map<String, Int> = Map.empty();
    Assert.same(None, m.get("some"));
    Assert.equals(0, m.size());
  }


  public function testSizes() {
    Assert.equals(3, Map.singleton("B", 1).set("A", 1).set("C", 1).size());
    Assert.equals(3, Map.singleton("A", 1).set("B", 1).set("C", 1).size());
    Assert.equals(3, Map.singleton("C", 1).set("B", 1).set("A", 1).size());
    Assert.equals(3, Map.singleton("B", 1).set("C", 1).set("A", 1).size());
    Assert.equals(3, Map.singleton("C", 1).set("A", 1).set("B", 1).size());
    Assert.equals(3, Map.singleton("A", 1).set("C", 1).set("B", 1).size());

    Assert.equals(1, Map.singleton("A", 1).set("A", 1).set("A", 1).size());
  }

  public function testSet() {
    var m = Map.singleton("Y", 1).set("X", 2).set("Z", 3);
    Assert.same(Some(2), m.get("X"));
    Assert.same(Some(1), m.get("Y"));
    Assert.same(Some(3), m.get("Z"));
    Assert.equals(3, m.size());
  }
}
