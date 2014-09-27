package thx.core;

import utest.Assert;
using thx.core.Objects;

class TestObjects {
  public function new() { }

  public function testObjects() {
    var ob = {};
    Assert.isTrue(ob.isEmpty());
    Assert.same([], ob.fields());

    var ob = { a : 'A', b : 'B' };
    Assert.isFalse(ob.isEmpty());
    Assert.same(['a', 'b'], ob.fields());
    Assert.same(['A', 'B'], ob.values());
    Assert.same([{ _0 : 'a', _1 : 'A'}, { _0 : 'b', _1 : 'B'}], ob.tuples());
  }
}
