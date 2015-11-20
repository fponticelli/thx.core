package thx.fp;

import thx.Tuple;
import thx.fp.State.*;

import utest.Assert;

class TestState {
  public function new() {}

  public function testMap() {
    var s: State<String, Int> = pure(1).map(function(v) return v + 1);
    Assert.same(new Tuple("a", 2), s("a"));
  }

  public function testFlatMap() {
    var s: State<String, Int> = pure(1);

    var f: Int -> State<String, Int> = function(i: Int) {
      return s.modify(function(v) return v + "b").map(function(v) return v + i);
    }

    Assert.same(new Tuple("ab", 2), (s.flatMap(f))("a"));
  }
}
