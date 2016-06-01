package thx.fp;

import haxe.ds.StringMap;

import thx.Either;
import thx.Functions.*;
import thx.fp.Dynamics.*;

import utest.Assert;

class TestDynamics {
  public function new() {}

  public function testParseStringMap() {
    var sample = { t: 1, u: 2, v: 3 };
    var expected: StringMap<Int> = [ "t" => 1, "u" => 2, "v" => 3 ];

    Assert.same(Right(expected), parseStringMap(sample, function(s, v) return parseInt(v), identity));
  }
}
