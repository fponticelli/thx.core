package thx;

import utest.Assert;
import thx.Either;
using thx.Eithers;
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

  public function testShallowCombine() {
    var o = {'name' : 'Franco', age : 19};
    var out : Dynamic = thx.Objects.shallowCombine(o, { 'foo': 'bar', 'name' : 'Michael', 'age' : 'Two'});

    Assert.same("Michael", out.name);
    Assert.same("Two", out.age);
    Assert.same("bar", out.foo);
    Assert.same("Franco", o.name);
  }

  public function testShallowMergeWithNullable() {
    var a : Null<SpecialObject>,
        options : { sub : Null<SpecialObject> } = { sub : {}};

    a = Objects.shallowMerge({
      foo : 'baz',
      bar : 'qux'
    }, options.sub);

    Assert.same('baz', a.foo);
  }

  public function testShallowMergeWithTypedef() {
    var to : SpecialObject = {
          bar : "qux"
        },
        from = {
          foo : "baz",
          extra : "field"
        };

    var merged : SpecialObject = thx.Objects.shallowMerge(to, from);

    Assert.same(merged.foo, from.foo);
    Assert.same(merged.bar, to.bar);
    Assert.same(Reflect.field(merged, 'extra'), 'field');
  }

  public function testDeepMerge() {
    var first = {
      a: {
        a1: 123,
        a2: [1, 2, 3],
      },
      b: {
        b1: 456,
        b2: [4, 5, 6]
      },
      "d0.0": {
        x: 123,
        y: 456
      }
    };
    var second = {
      a: {
        a3: "aaa"
      },
      b: {
        b1: 999,
        b2: [10, 20, 30],
        b3: {
          b4: "bbb"
        }
      },
      c: {
        c1: 789,
        c2: [789]
      },
      "d0.0": {
        x: 123,
        y: 789
      }
    };
    var expected = {
      a: {
        a1: 123,
        a2: [1, 2, 3],
        a3: "aaa"
      },
      b: {
        b1: 999,
        b2: [10, 20, 30],
        b3: {
          b4: "bbb"
        }
      },
      c: {
        c1: 789,
        c2: [789]
      },
      "d0.0": {
        x: 123,
        y: 789
      }
    };
    var actual = thx.Objects.deepCombine(first, second);
    Assert.same(expected, actual);
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
    Assert.isTrue(o.hasPath('key1.key4[1]'));
    Assert.isTrue(o.hasPath('key1.key5[0].key6'));
    Assert.isTrue(o.hasPath('key1.key5[1].key6'));
    Assert.isTrue(o.hasPath('key1.key6'));

    Assert.isFalse(o.hasPath('key1.key4.2'));
    Assert.isFalse(o.hasPath('key1.key4[2]'));
    Assert.isFalse(o.hasPath('key1.key5[2]'));
    Assert.isFalse(o.hasPath('key1.key5[2].key6'));
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

    Assert.isTrue(o.hasPathValue('key1'));
    Assert.isTrue(o.hasPathValue('key1.key2'));
    Assert.isTrue(o.hasPathValue('key1.key3'));
    Assert.isTrue(o.hasPathValue('key1.key4.0'));
    Assert.isTrue(o.hasPathValue('key1.key4.1'));
    Assert.isTrue(o.hasPathValue('key1.key4[0]'));
    Assert.isTrue(o.hasPathValue('key1.key4[1]'));
    Assert.isTrue(o.hasPathValue('key1.key5'));
    Assert.isTrue(o.hasPathValue('key1.key5.0.key6'));
    Assert.isTrue(o.hasPathValue('key1.key5.1.key6'));
    Assert.isTrue(o.hasPathValue('key1.key5[0].key6'));
    Assert.isTrue(o.hasPathValue('key1.key5[1].key6'));

    Assert.isFalse(o.hasPathValue('key1.key6'));
    Assert.isFalse(o.hasPathValue('key1.key4.2'));
    Assert.isFalse(o.hasPathValue('key1.key4[2]'));
    Assert.isFalse(o.hasPathValue('key1.key4.3'));
    Assert.isFalse(o.hasPathValue('key1.key4[3]'));
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
    Assert.same("one", o.getPath("key1.key4[0]"));
    Assert.same("two", o.getPath("key1.key4[1]"));
    Assert.same([ { key6: "test1" }, { key6: "test2" } ], o.getPath("key1.key5"));
    Assert.same("test1", o.getPath("key1.key5.0.key6"));
    Assert.same("test2", o.getPath("key1.key5.1.key6"));
    Assert.same("test1", o.getPath("key1.key5[0].key6"));
    Assert.same("test2", o.getPath("key1.key5[1].key6"));

    Assert.isNull(o.getPath(""));
    Assert.isNull(o.getPath("bad"));
    Assert.isNull(o.getPath("bad.key"));
    Assert.isNull(o.getPath("key1.key5.2.key6")); // bad index in key5 array
    Assert.isNull(o.getPath("key1.key5.1.key6.0"));
    Assert.isNull(o.getPath("key1.key5.1.key6[0]"));
  }

  public function testParsePath() {
    var o = {
      key1: {
        key2: 123,
        key3: "abc",
        key4: [true, false]
      }
    };
    Assert.same(Right(123), o.parsePath("key1.key2", thx.fp.Dynamics.parseInt));
    Assert.same(Right("abc"), o.parsePath("key1.key3", thx.fp.Dynamics.parseString));
    Assert.same(Right(true), o.parsePath("key1.key4.0", thx.fp.Dynamics.parseBool));
    Assert.same(Right(true), o.parsePath("key1.key4[0]", thx.fp.Dynamics.parseBool));
    Assert.isTrue(o.parsePath("key5.key6", thx.fp.Dynamics.parseString).either.isLeft());
    Assert.isTrue(o.parsePath("key1.key3", thx.fp.Dynamics.parseInt).either.isLeft());
  }

  public function testSetPath() {
    Assert.same({ key: "val" }, ({}).setPath("key", "val"));
    Assert.same({ key1: "val1", key2: "val2" }, ({}).setPath("key1", "val1").setPath("key2", "val2"));
    Assert.same({ key1: { key2: "val" } }, ({}).setPath("key1.key2", "val"));
    Assert.same({ key1: [ { key2: "val" } ] }, ({}).setPath("key1.0.key2", "val"));
    Assert.same({ key1: [ { key2: "val" } ] }, ({}).setPath("key1[0].key2", "val"));
    Assert.same({ key1: [ [ [ null, 123 ] ] ] }, ({}).setPath("key1.0.0.1", 123));
    Assert.same({ key1: [ [ [ null, 123 ] ] ] }, ({}).setPath("key1[0][0][1]", 123));
    Assert.same({ key1: [ [ [ null, { key2: "val" } ] ] ] }, ({}).setPath("key1.0.0.1.key2", "val"));
    Assert.same({ key1: [ [ [ null, { key2: "val" } ] ] ] }, ({}).setPath("key1[0][0][1].key2", "val"));

    Assert.same({ key: "val" }, { key: "before" }.setPath("key", "val"));
    Assert.same({ key1: { key2: "val" } }, { key1: { key2: "before" } }.setPath("key1.key2", "val"));
    Assert.same({ key1: { key2: [ 1, 55, 3 ] } }, { key1: { key2: [1, 2, 3] } }.setPath("key1.key2.1", 55));
    Assert.same({ key1: { key2: [ 1, 55, 3 ] } }, { key1: { key2: [1, 2, 3] } }.setPath("key1.key2[1]", 55));
    Assert.same({ key1: 123, newKey: "val" }, { key1: 123 }.setPath("newKey", "val"));

    Assert.same([1, 2], [].setPath("*", 1).setPath("*", 2));
    Assert.same({ list : [1, 2] }, ({}).setPath("list.*", 1).setPath("list.*", 2));
    Assert.same([[1, 2]], [].setPath("0.*", 1).setPath("0.*", 2));
    Assert.same([[1], [2]], [].setPath("0.*", 1).setPath("*.*", 2));
  }

  public function testDeflateInflate() {
    var tests: Array<Dynamic> = [
      { a: { b: [1,2,3], c: { d: false } }},
      { visit: { customCompany: { companyId: { none: {}}}}},
      { arr: []}
    ];

    for(test in tests) {
      var d = Objects.deflate(test, false);
      Assert.same(test, Objects.inflate(d));

      var d = Objects.deflate(test, true);
      Assert.same(test, Objects.inflate(d));
    }
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

  public function testWith() {
    var o1 = { name: "John", age: 11 },
        o2 = o1.with(name, "Jane"),
        o3 = Objects.with(o2, age, 13),
        o4: SampleWithObject = o1,
        o5 = o4.with(age, 15);
    Assert.equals("John", o1.name);
    Assert.equals(11, o1.age);
    Assert.isTrue(o1 != o2 && o2 != o3);
    Assert.equals("Jane", o2.name);
    Assert.equals(11, o2.age);
    Assert.equals(13, o3.age);
    Assert.equals(15, o5.age);
  }
}

typedef SampleWithObject = {
  name : String,
  age : Int
}
