package thx;

import haxe.ds.Option;
import thx.Tuple;
import utest.Assert;
using thx.Options;

class TestOptions {
  public function new() {}

  public function testCombine() {
    Assert.same(Some(Tuple2.of("a", "b")), Options.combine2(Some("a"), Some("b")));
    Assert.same(None, Options.combine2(Some("a"), None));
    Assert.same(None, Options.combine2(None, Some("b")));
    Assert.same(None, Options.combine2(None, None));
  }

  public function testSpread() {
    var result = Options
      .combine2(Some("a"), Some("b"))
      .spread2(function(a, b) {
        return a + b;
      });
    Assert.same(Some("ab"), result);
  }
}
