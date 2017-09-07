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

  public function testCata() {
    Assert.same(9, Some(10).cata(0, function(v) return v - 1));
    Assert.same(0, None.cata(0, function(v) return v - 1));
  }

  public function testCataf() {
    Assert.same(0, None.cataf(() -> 0, v -> { Assert.fail(); return v - 1; }));
    Assert.same(9, Some(10).cataf(() -> { Assert.fail(); return 0; }, v ->  v - 1));
  }

  public function testFoldLeft() {
    Assert.same(-9, Some(10).foldLeft(1, function(acc, v) return acc - v));
    Assert.same(1, None.foldLeft(1, function(acc, v) return acc - v));
  }

  public function testFoldLeftf() {
    Assert.same(-9, Some(10).foldLeftf(function() return 1, function(acc, v) return acc - v));
    Assert.same(1, None.foldLeftf(function() return 1, function(acc, v) return acc - v));
  }

  public function testGetOrElseF() {
    Assert.same(20, None    .getOrElseF(() -> 20));
    Assert.same(10, Some(10).getOrElseF(() -> { Assert.fail(); return 20; }));
  }

  public function testOrElseF() {
    Assert.same(None,     None    .orElseF(() -> None));
    Assert.same(Some(20), None    .orElseF(() -> Some(20)));
    Assert.same(Some(10), Some(10).orElseF(() -> { Assert.fail(); return None; }));
    Assert.same(Some(10), Some(10).orElseF(() -> { Assert.fail(); return Some(20); }));
  }

  public function testAlt2() {
    Assert.same(Some("a"), Options.alt2(Some("a"), Some("b")));
    Assert.same(Some("a"), Options.alt2(Some("a"), None));
    Assert.same(Some("a"), Options.alt2(None     , Some("a")));
    Assert.same(None,      Options.alt2(None     , None));
  }

  public function testAlt3() {
    Assert.same(Some("a"), Options.alt3(Some("a"), Some("b"), Some("c")));
    Assert.same(Some("a"), Options.alt3(Some("a"), Some("b"), None));
    Assert.same(Some("a"), Options.alt3(Some("a"), None     , Some("c")));
    Assert.same(Some("a"), Options.alt3(Some("a"), None     , None));
    Assert.same(Some("b"), Options.alt3(None     , Some("b"), Some("c")));
    Assert.same(Some("b"), Options.alt3(None     , Some("b"), None));
    Assert.same(Some("c"), Options.alt3(None     , None     , Some("c")));
    Assert.same(None,      Options.alt3(None     , None     , None));
  }

  public function testAlt4() {
    Assert.same(Some("a"), Options.alt4(Some("a"), Some("b"), Some("c"), Some("d")));
    Assert.same(Some("a"), Options.alt4(Some("a"), Some("b"), Some("c"), None));
    Assert.same(Some("a"), Options.alt4(Some("a"), Some("b"), None     , Some("d")));
    Assert.same(Some("a"), Options.alt4(Some("a"), Some("b"), None     , None));
    Assert.same(Some("a"), Options.alt4(Some("a"), None     , Some("c"), Some("d")));
    Assert.same(Some("a"), Options.alt4(Some("a"), None     , Some("c"), None));
    Assert.same(Some("a"), Options.alt4(Some("a"), None     , None     , Some("d")));
    Assert.same(Some("a"), Options.alt4(Some("a"), None     , None     , None));
    Assert.same(Some("b"), Options.alt4(None     , Some("b"), Some("c"), Some("d")));
    Assert.same(Some("b"), Options.alt4(None     , Some("b"), Some("c"), None));
    Assert.same(Some("b"), Options.alt4(None     , Some("b"), None     , Some("d")));
    Assert.same(Some("b"), Options.alt4(None     , Some("b"), None     , None));
    Assert.same(Some("c"), Options.alt4(None     , None     , Some("c"), Some("d")));
    Assert.same(Some("c"), Options.alt4(None     , None     , Some("c"), None));
    Assert.same(Some("d"), Options.alt4(None     , None     , None     , Some("d")));
    Assert.same(None,      Options.alt4(None     , None     , None     , None));
  }

  public function testAlts() {
    Assert.same(None, Options.alts([]));
    Assert.same(None, Options.alts([None]));
    Assert.same(Some("a"), Options.alts([Some("a")]));
    Assert.same(Some("a"), Options.alts([None, Some("a")]));
    Assert.same(Some("a"), Options.alts([Some("a"), None]));
    Assert.same(Some("a"), Options.alts([ Some("a"), Some("b"), Some("c"), Some("d") ]));
    Assert.same(Some("a"), Options.alts([ Some("a"), Some("b"), Some("c"), None      ]));
    Assert.same(Some("a"), Options.alts([ Some("a"), Some("b"), None     , Some("d") ]));
    Assert.same(Some("a"), Options.alts([ Some("a"), Some("b"), None     , None      ]));
    Assert.same(Some("a"), Options.alts([ Some("a"), None     , Some("c"), Some("d") ]));
    Assert.same(Some("a"), Options.alts([ Some("a"), None     , Some("c"), None      ]));
    Assert.same(Some("a"), Options.alts([ Some("a"), None     , None     , Some("d") ]));
    Assert.same(Some("a"), Options.alts([ Some("a"), None     , None     , None      ]));
    Assert.same(Some("b"), Options.alts([ None     , Some("b"), Some("c"), Some("d") ]));
    Assert.same(Some("b"), Options.alts([ None     , Some("b"), Some("c"), None      ]));
    Assert.same(Some("b"), Options.alts([ None     , Some("b"), None     , Some("d") ]));
    Assert.same(Some("b"), Options.alts([ None     , Some("b"), None     , None      ]));
    Assert.same(Some("c"), Options.alts([ None     , None     , Some("c"), Some("d") ]));
    Assert.same(Some("c"), Options.alts([ None     , None     , Some("c"), None      ]));
    Assert.same(Some("d"), Options.alts([ None     , None     , None     , Some("d") ]));
    Assert.same(None,      Options.alts([ None     , None     , None     , None      ]));
  }

  public function testAltsF() {
    Assert.same(None, Options.altsF([]));
    Assert.same(Some(10), Options.altsF([
      () -> None,
      () -> Some(10),
      () -> {
        Assert.fail();
        return Some(20);
      }
    ]));
  }
}
