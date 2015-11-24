package thx.fp;

import thx.Tuple;
import thx.fp.Writer.*;
import thx.Strings;
import thx.fp.Functions.const;

import utest.Assert;

class TestWriter {
  public function new() {}

  public function testMap() {
    var s = pure(1, Strings.monoid).map(function(v) return v + 1);
    Assert.same(new Tuple("", 2), s.run());
  }

  public function testFlatMap() {
    var s: Writer<String, Int> = tell("a", Strings.monoid).map(const(1));

    var f: Int -> Writer<String, Int> = function(i: Int) {
      return s.log("b").map(function(v) return i + v);
    }

    Assert.same(new Tuple("aab", 2), s.flatMap(f).run());
  }
}
