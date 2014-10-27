package thx.core;

import utest.Assert;
using thx.core.Nulls;
import thx.core.Nulls.*;

class TestNulls {
  public var withValue = "A";
  public var withoutValue : String;
  public var getter(get, null) : String;
  public var setter(get, set) : String;
  function get_getter() return 'A';

  var v : String;
  function get_setter() return v;
  function set_setter(v : String) return this.v = v;

  public var nested : { a : { b : String }};
  public var empty : { a : { b : String }};

  public function new() { }

  public function setup() {
    this.v = null;
    this.nested = { a : { b : 'A' } };
    this.empty = null;
  }

  public function testOr() {
    var s : String = null;
    Assert.equals('B', s.or('B'));
    s = 'A';
    Assert.equals('A', s.or('B'));

    var s : String = null;
    Assert.equals('B', Nulls.or(s, 'B'));
    s = 'A';
    Assert.equals('A', Nulls.or(s, 'B'));

    Assert.equals('A', Nulls.or(withValue, 'B'));
    Assert.equals('A', withValue.or('B'));

    Assert.equals('B', Nulls.or(withoutValue, 'B'));
    Assert.equals('B', withoutValue.or('B'));

    var o : { a : String, b : String } = { a : "A", b : null };

    Assert.equals('A', Nulls.or(o.a, 'B'));
    Assert.equals('A', (o.a).or('B'));

    Assert.equals('B', Nulls.or(o.b, 'B'));
    Assert.equals('B', (o.b).or('B'));

    Assert.equals('A', Nulls.or(getter, 'B'));
    Assert.equals('A', getter.or('B'));

    Assert.equals('B', Nulls.or(setter, 'B'));
    Assert.equals('B', setter.or('B'));

    setter = 'A';
    Assert.equals('A', Nulls.or(setter, 'B'));
    Assert.equals('A', setter.or('B'));
  }

  public function testOpt() {
    var o : { a : { b : { c : String }}} = null;

    Assert.isNull((o.a.b.c).opt());
    Assert.isNull(Nulls.opt(o.a.b.c));
    Assert.isNull(Nulls.opt(o.a.b.c));
    Assert.isNull((o.a.b.c).opt());

    Assert.equals('B', (o.a.b.c).or('B'));

    o = { a : { b : { c : 'A' } } };
    Assert.equals('A', (o.a.b.c).opt());
    Assert.equals('A', (o.a.b.c).or('B'));

    Assert.same({ c : 'A'}, (o.a.b).opt());
    Assert.same({ c : 'A'}, (o.a.b).or({ c : 'B'}));

    o = { a : { b : null } };
    Assert.isNull((o.a.b.c).opt());
    Assert.equals('B', (o.a.b.c).or('B'));

    Assert.isNull((o.a.b).opt());
    Assert.same({ c : 'B'}, (o.a.b).or({ c : 'B'}));

    Assert.equals('A', (this.nested.a.b).opt());
    Assert.equals('A', (nested.a.b).opt());

    Assert.isNull((this.empty.a.b).opt());
    Assert.isNull((empty.a.b).opt());

    var arr : { a : Array<{ b : String }> } = null;
    Assert.isNull((arr.a[0].b).opt());
    arr = { a : [{ b : 'A' }] };
    Assert.isNull((arr.a[1].b).opt());
    Assert.equals('A', (arr.a[0].b).opt());

    var arr : Array<Array<Array<Null<Int>>>> = null;
    Assert.isNull((arr[0]).opt());
    Assert.isNull((arr[0][1]).opt());
    Assert.isNull((arr[0][1][3]).opt());

    arr = [[[1,2,3],[4,5,6]]];
    Assert.equals(1, (arr[0][0][0]).opt());
    Assert.equals(6, (arr[0][1][2]).opt());
  }

  var m : {
    f : String -> { change : Void -> String }
  };

  var m2 : {
    f : String -> String
  };

  public function testOrMethod() {
    Assert.equals('x', (this.m.f('Y').change()).or('x'));
    var first = true;
    m = {
      f : function(s) {
        if(first) {
          first = false;
          return {
            change : function() return s.toLowerCase()
          }
        } else {
          // check for side effects on potentially multiple calls
          return throw 'method called multiple times';
        }
      }
    };
    Assert.equals('y', (this.m.f('Y').change()).or('x'));

    Assert.equals('x', (this.m2.f('Y').toLowerCase()).or('x'));
  }

  public function testIsNull() {
    Assert.isTrue((empty).isNull());
    Assert.isTrue((empty.a).isNull());
    Assert.isTrue((empty.a.b).isNull());
  }

  public function testNotNull() {
    Assert.isTrue((nested).notNull());
    Assert.isTrue((nested.a).notNull());
    Assert.isTrue((nested.a.b).notNull());
  }
}