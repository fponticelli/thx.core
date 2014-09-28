/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

import utest.Assert;
using thx.core.Defaults;
import thx.core.Defaults.*;

class TestDefaults {
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
    Assert.equals('B', Defaults.or(s, 'B'));
    s = 'A';
    Assert.equals('A', Defaults.or(s, 'B'));

    Assert.equals('A', Defaults.or(withValue, 'B'));
    Assert.equals('A', withValue.or('B'));

    Assert.equals('B', Defaults.or(withoutValue, 'B'));
    Assert.equals('B', withoutValue.or('B'));

    var o = { a : "A", b : null };

    Assert.equals('A', Defaults.or(o.a, 'B'));
    Assert.equals('A', o.a.or('B'));

    Assert.equals('B', Defaults.or(o.b, 'B'));
    Assert.equals('B', o.b.or('B'));

    Assert.equals('A', Defaults.or(getter, 'B'));
    Assert.equals('A', getter.or('B'));

    Assert.equals('B', Defaults.or(setter, 'B'));
    Assert.equals('B', setter.or('B'));

    setter = 'A';
    Assert.equals('A', Defaults.or(setter, 'B'));
    Assert.equals('A', setter.or('B'));
  }

  public function testOpt() {
    var o : { a : { b : { c : String }}} = null;
    Assert.isNull((o.a.b.c).opt());
    Assert.isNull(Defaults.opt(o.a.b.c));
    Assert.isNull(Defaults.opt(o.a.b.c));
    Assert.isNull((o.a.b.c).opt());
    Assert.equals('B', (o.a.b.c).opt().or('B'));

    o = { a : { b : { c : 'A' } } };
    Assert.equals('A', (o.a.b.c).opt());
    Assert.equals('A', (o.a.b.c).opt().or('B'));

    Assert.same({ c : 'A'}, (o.a.b).opt());
    Assert.same({ c : 'A'}, (o.a.b).opt().or({ c : 'B'}));

    o = { a : { b : null } };
    Assert.isNull((o.a.b.c).opt());
    Assert.equals('B', (o.a.b.c).opt().or('B'));

    Assert.isNull((o.a.b).opt());
    Assert.same({ c : 'B'}, (o.a.b).opt().or({ c : 'B'}));

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
}