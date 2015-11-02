package thx.fp;

import haxe.ds.Option;
import utest.Assert;
import thx.fp.Map;
import thx.Functions.*;
import thx.Strings.*;

class TestMap {
  public function new() {}

  public function testEmpty() {
    var m = Map.empty();
    Assert.same(None, m.get("some", compare));
    Assert.equals(0, m.size());
  }
}
