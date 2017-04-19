package thx;

using thx.Functions;
using thx.Maybe;
import thx.Tuple;
import utest.Assert;

class TestMaybe {
  public function new() {}

  public function testBasic() {
    var m = Maybe.of(1),
        n = Maybe.none();

    Assert.isFalse(m.isNull());
    Assert.isTrue(n.isNull());
    Assert.isFalse(m.isNone());
    Assert.isTrue(n.isNone());
    Assert.isTrue(m.hasValue());
    Assert.isFalse(n.hasValue());
    Assert.notNull(m.get());
    Assert.isNull(n.get());

    Assert.isTrue(Maybe.of(1) == Maybe.of(1));
    Assert.isTrue(Maybe.of(1) != Maybe.of(2));
    Assert.isTrue(Maybe.of(1) != Maybe.none());
    Assert.isTrue(Maybe.none() != Maybe.of(1));
    Assert.isTrue(Maybe.none() == Maybe.none());

    Assert.isTrue(Maybe.of(1).map.fn(_ * 2) == Maybe.of(2));

    Assert.isTrue(Maybe.of(1).filter.fn(_ % 2 == 0).isNone());
    Assert.isTrue(Maybe.of(2).filter.fn(_ % 2 == 0).hasValue());
  }

  public function testCombine() {
    Assert.same(Maybe.of(Tuple2.of("a", "b")), Maybe.combine2(Maybe.of("a"), Maybe.of("b")));
    Assert.same(Maybe.none(), Maybe.combine2(Maybe.of("a"), Maybe.none()));
    Assert.same(Maybe.none(), Maybe.combine2(Maybe.none(), Maybe.of("b")));
    Assert.same(Maybe.none(), Maybe.combine2(Maybe.none(), Maybe.none()));
  }

  public function testSpread() {
    var result = Maybe
      .combine2(Maybe.of("a"), Maybe.of("b"))
      .spread2(function(a, b) {
        return a + b;
      });
    Assert.same(Maybe.of("ab"), result);
  }

  public function testCata() {
    Assert.same(9, Maybe.of(10).cata(0, function(v) return v - 1));
    Assert.same(0, Maybe.none().cata(0, function(v) return v - 1));
  }

  public function testCataf() {
    Assert.same(9, Maybe.of(10).cataf(function() return 0, function(v) return v - 1));
    Assert.same(0, Maybe.none().cataf(function() return 0, function(v) return v - 1));
  }

  public function testFoldLeft() {
    Assert.same(-9, Maybe.of(10).foldLeft(1, function(acc, v) return acc - v));
    Assert.same(1, Maybe.none().foldLeft(1, function(acc, v) return acc - v));
  }

  public function testFoldLeftf() {
    Assert.same(-9, Maybe.of(10).foldLeftf(function() return 1, function(acc, v) return acc - v));
    Assert.same(1, Maybe.none().foldLeftf(function() return 1, function(acc, v) return acc - v));
  }
}
