package thx;

import utest.Assert;
using thx.Arrays;
using thx.Maps;

class TestMaps {
  public function new() { }

  public function testTuples() {
    var map = [
      "key1" => 1,
      "key2" => 2
    ];

    var tuples = map.tuples();
    tuples.sort(function(a, b) return Strings.compare(a._0, b._0));

    Assert.equals(2, tuples.length);
    Assert.equals(tuples[0]._0, "key1");
    Assert.equals(tuples[0]._1, 1);
    Assert.equals(tuples[1]._0, "key2");
    Assert.equals(tuples[1]._1, 2);
  }

  public function testValues() {
    var map = [
      "key1" => 1,
      "key2" => 2,
      "key3" => 3
    ];
    var values = map.values().order(Ints.compare);
    Assert.same([1, 2, 3], values);
  }
}
