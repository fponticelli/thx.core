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
    Assert.same(9, Some(10).cataf(function() return 0, function(v) return v - 1));
    Assert.same(0, None.cataf(function() return 0, function(v) return v - 1));
  }

  public function testFoldLeft() {
    Assert.same(-9, Some(10).foldLeft(1, function(acc, v) return acc - v));
    Assert.same(1, None.foldLeft(1, function(acc, v) return acc - v));
  }

  public function testFoldLeftf() {
    Assert.same(-9, Some(10).foldLeftf(function() return 1, function(acc, v) return acc - v));
    Assert.same(1, None.foldLeftf(function() return 1, function(acc, v) return acc - v));
  }
}
