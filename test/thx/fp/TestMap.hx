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

  public function testSet() {
    var m = Map.singleton("Y", 1).set("X", 2).set("Z", 3);
    Assert.same(Some(2), m.get("X"));
    Assert.same(Some(1), m.get("Y"));
    Assert.same(Some(3), m.get("Z"));
    Assert.equals(3, m.size());
  }
}
