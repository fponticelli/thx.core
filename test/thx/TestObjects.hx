package thx;

import utest.Assert;
using thx.Objects;

class TestObjects {
  public function new() { }

  public function testObjects() {
    var ob = {};
    Assert.isTrue(ob.isEmpty());
    Assert.same([], ob.fields());

    var ob = { a : 'A', b : 'B' };
    Assert.isFalse(ob.isEmpty());

    var fields = ob.fields();
    Assert.isTrue(fields.remove('a'));
    Assert.isTrue(fields.remove('b'));
    Assert.equals(0, fields.length);

    var values = ob.values();
    Assert.isTrue(values.remove('A'));
    Assert.isTrue(values.remove('B'));
    Assert.equals(0, values.length);

    var tuples = ob.tuples();

    tuples.sort(function(a, b) return Strings.compare(a._0, b._0));
    Assert.same([{ _0 : 'a', _1 : 'A'}, { _0 : 'b', _1 : 'B'}], tuples);
  }
}
