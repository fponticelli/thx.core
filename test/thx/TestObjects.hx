package thx;

import utest.Assert;
using thx.Objects;
using thx.Strings;

typedef SpecialObject = {
  ?foo : String,
  ?bar : String
};

class TestObjects {
  public function new() { }

  public function testIssue20151201() {
    var o = { oldId: "1", newId: "2" },
        s = Objects.string(o);
    Assert.stringContains('oldId : "1"', s);
    Assert.stringContains('newId : "2"', s);
    Assert.stringContains(', ', s);
    Assert.isTrue(s.startsWith("{"));
    Assert.isTrue(s.endsWith("}"));
  }

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
  public function testAssign() {
    var o = {'name' : 'Franco', age : 19};
    var out : Dynamic = thx.Objects.assign(o, { 'foo': 'bar', 'name' : 'Michael', 'age' : 'Two'});

    Assert.same("Michael", out.name);
    Assert.same("Two", out.age);
    Assert.same("bar", out.foo);

    for (field in Reflect.fields(out)) {
      Assert.same(Reflect.field(out, field), Reflect.field(o, field));
    }
  }

  public function testCombine() {
    var o = {'name' : 'Franco', age : 19};
    var out : Dynamic = thx.Objects.combine(o, { 'foo': 'bar', 'name' : 'Michael', 'age' : 'Two'});

    Assert.same("Michael", out.name);
    Assert.same("Two", out.age);
    Assert.same("bar", out.foo);
    Assert.same("Franco", o.name);
  }

  public function testMergeWithNullable() {
    var a : Null<SpecialObject>,
        options : { sub : Null<SpecialObject> } = { sub : {}};

    a = Objects.merge({
      foo : 'baz',
      bar : 'qux'
    }, options.sub);

    Assert.same('baz', a.foo);
  }

  public function testMergeWithTypedef() {
    var to : SpecialObject = {
          bar : "qux"
        },
        from = {
          foo : "baz",
          extra : "field"
        };

    var merged : SpecialObject = thx.Objects.merge(to, from);

    Assert.same(merged.foo, from.foo);
    Assert.same(merged.bar, to.bar);
    Assert.same(Reflect.field(merged, 'extra'), 'field');
  }

  public function testHasPath() {
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
        ],
        key6: null
      }
    };

    Assert.isTrue(o.hasPath('key1.key2'));
    Assert.isTrue(o.hasPath('key1.key4.1'));
    Assert.isTrue(o.hasPath('key1.key6'));

    Assert.isFalse(o.hasPath('key1.key4.2'));
    Assert.isFalse(o.hasPath('key1.key7'));
  }

  public function testHasPathValue() {
    var o = {
      key1: {
        key2: 123,
        key3: "abc",
        key4: [
          "one",
          "two",
          null
        ],
        key5: [
          { key6: "test1" },
          { key6: "test2" },
        ],
        key6: null
      }
    };

    Assert.isFalse(o.hasPathValue('key1.key6'));
    Assert.isFalse(o.hasPathValue('key1.key4.2'));
    Assert.isFalse(o.hasPathValue('key1.key7'));
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

    Assert.same([1, 2], [].setPath("*", 1).setPath("*", 2));
    Assert.same({ list : [1, 2] }, ({}).setPath("list.*", 1).setPath("list.*", 2));
    Assert.same([[1, 2]], [].setPath("0.*", 1).setPath("0.*", 2));
    Assert.same([[1], [2]], [].setPath("0.*", 1).setPath("*.*", 2));
  }

  public function testRemovePath() {
    var simple = { foo: "bar" };
    var nested = {
      foo: {
        bar: {
          baz: "qux",
          other: "other"
        }
      }
    };
    var arr = {
      foo: [{}, {
        bar: 'baz'
      }]
    };

    Assert.same({}, simple.removePath('foo'));
    Assert.same({}, simple);
    Assert.same(simple, simple.removePath('a.b.c.d'));

    Assert.same({ foo: { bar: { baz: "qux"}}}, nested.removePath('foo.bar.other'));

    Assert.same(arr, arr.removePath('foo.0.bar'));
    Assert.same({ foo: [{}, {}]}, arr.removePath('foo.1.bar'));
  }
}
