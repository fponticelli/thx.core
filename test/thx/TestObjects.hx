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

  public function testGetPath() {
    var o = {
      key1: {
        key2: 123,
        key3: "abc",
        key4: [
          "one",
          "two"
        ],
        key5: [
          { key6: "test1" },
          { key6: "test2" },
        ]
      }
    };
    Assert.same(123, o.getPath("key1.key2"));
    Assert.same("abc", o.getPath("key1.key3"));
    Assert.same("one", o.getPath("key1.key4.0"));
    Assert.same("two", o.getPath("key1.key4.1"));
    Assert.same([ { key6: "test1" }, { key6: "test2" } ], o.getPath("key1.key5"));
    Assert.same("test1", o.getPath("key1.key5.0.key6"));
    Assert.same("test2", o.getPath("key1.key5.1.key6"));

    Assert.isNull(o.getPath(""));
    Assert.isNull(o.getPath("bad"));
    Assert.isNull(o.getPath("bad.key"));
  }

  public function testSetPath() {
    Assert.same({ key: "val" }, ({}).setPath("key", "val"));
    Assert.same({ key1: "val1", key2: "val2" }, ({}).setPath("key1", "val1").setPath("key2", "val2"));
    Assert.same({ key1: { key2: "val" } }, ({}).setPath("key1.key2", "val"));
    Assert.same({ key1: [ { key2: "val" } ] }, ({}).setPath("key1.0.key2", "val"));
    Assert.same({ key1: [ [ [ null, 123 ] ] ] }, ({}).setPath("key1.0.0.1", 123));
    Assert.same({ key1: [ [ [ null, { key2: "val" } ] ] ] }, ({}).setPath("key1.0.0.1.key2", "val"));

    Assert.same({ key: "val" }, { key: "before" }.setPath("key", "val"));
    Assert.same({ key1: { key2: "val" } }, { key1: { key2: "before" } }.setPath("key1.key2", "val"));
    Assert.same({ key1: { key2: [ 1, 55, 3 ] } }, { key1: { key2: [1, 2, 3] } }.setPath("key1.key2.1", 55));
    Assert.same({ key1: 123, newKey: "val" }, { key1: 123 }.setPath("newKey", "val"));
  }
}
