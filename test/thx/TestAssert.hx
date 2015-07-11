package thx;

import haxe.PosInfos;
import utest.Assert as A;
using thx.Assert;

class TestAssert {
  public function new() {}

  var orig : IAssertBehavior;
  var behavior : CollectBehavior;
  public function setup() {
    orig = Assert.behavior;
    Assert.behavior = behavior = new CollectBehavior();
  }

  public function teardown() {
    Assert.behavior = orig;
  }

  public function testIsBool() {
    Assert.isTrue(true);
    Assert.isTrue(false);
    Assert.isFalse(true);
    Assert.isFalse(false);

    expect(2, 2);
  }

  public function testIsNull() {
    Assert.isNull(null);
    Assert.isNull(0);
    Assert.isNull(0.0);
    Assert.isNull(0.1);
    Assert.isNull(1);
    Assert.isNull("");
    Assert.isNull("a");
    Assert.isNull(Math.NaN);
    Assert.isNull(Math.POSITIVE_INFINITY);
    Assert.isNull(true);
    Assert.isNull(false);
    expect(1, 10);
  }

  public function testNotNull() {
    Assert.notNull(null);
    Assert.notNull(0);
    Assert.notNull(0.0);
    Assert.notNull(0.1);
    Assert.notNull(1);
    Assert.notNull("");
    Assert.notNull("a");
    Assert.notNull(Math.NaN);
    Assert.notNull(Math.POSITIVE_INFINITY);
    Assert.notNull(true);
    Assert.notNull(false);
    expect(10, 1);
  }

  public function testRaisesSuccess() {
    var counter = 0,
        tests = [
          { exception : ("e" : Dynamic), catches : ([String, Dynamic, null] : Array<Dynamic>) },
          { exception : (1 : Dynamic),   catches : ([Int, Dynamic, null] : Array<Dynamic>) },
          { exception : (0.1 : Dynamic), catches : ([Float, Dynamic, null] : Array<Dynamic>) },
          { exception : (new TestAssert() : Dynamic), catches : ([TestAssert, Dynamic, null] : Array<Dynamic>) },
          { exception : ([1] : Dynamic), catches : ([Array, Dynamic, null] : Array<Dynamic>) }
        ];
    for(test in tests) {
      for(catcher in test.catches) {
        counter++;
        Assert.raises(function() throw test.exception, catcher);
      }
    }
    expect(counter, 0);
  }

  public function testRaisesFailure() {
    var counter = 0,
        tests = [
          { exception : ("e" : Dynamic), catches : ([Int, Float, TestAssert] : Array<Dynamic>) },
          { exception : (1 : Dynamic),   catches : ([String, TestAssert] : Array<Dynamic>) },
          { exception : (0.1 : Dynamic), catches : ([String, Int, TestAssert] : Array<Dynamic>) },
          { exception : (new TestAssert() : Dynamic), catches : ([Int, Float, String] : Array<Dynamic>) },
          { exception : ([1] : Dynamic), catches : ([TestAssert, Int, Float] : Array<Dynamic>) }
        ];
    for(test in tests) {
      for(catcher in test.catches) {
        counter++;
        Assert.raises(function() throw test.exception, catcher);
      }
    }
    expect(0, counter);
  }

  public function testIs() {
    var values : Array<Dynamic> = ["e",    1,   0.1,   new TestAssert(), {},      [1]];
    var types  : Array<Dynamic> = [String, Int, Float, TestAssert,       Dynamic, Array];
    var i = 0;
    var expectedsuccess = 12;
    for(value in values)
      for(type in types) {
        i++;
        Assert.is(value, type);
      }
    expect(expectedsuccess, i-expectedsuccess);
  }

  public function testSamePrimitive() {
    Assert.same(null, 1);
    Assert.same(1, 1);
    Assert.same(1, "1");
    Assert.same("a", "a");
    Assert.same(null, "");
    Assert.same(new Date(2000, 0, 1, 0, 0, 0), null);
    Assert.same([1 => "a", 2 => "b"], [1 => "a", 2 => "b"]);
    Assert.same(["a" => 1], ["a" => 1]);
    Assert.same(["a" => 1], [1 => 1]);
    Assert.same([1 => "a"], [1 => "a", 2 => "b"]);
    Assert.same(new Date(2000, 0, 1, 0, 0, 0), new Date(2000, 0, 1, 0, 0, 0));

    expect(5, 6);
  }

  public function testSameType() {
    Assert.same(null, {});
    Assert.same(null, null);
    Assert.same({}, null);
    Assert.same({}, 1);
    Assert.same({}, []);
    Assert.same(null, None);
    Assert.same(None, null);

    expect(1, 6);
  }

  public function testSameArray() {
    Assert.same([], []);
    Assert.same([1], ["1"]);
    Assert.same([1,2,3], [1,2,3]);
    Assert.same([1,2,3], [1,2]);
    Assert.same([1,2],   [1,2,3]);
    Assert.same([1,[1,2]], [1,[1,2]]);
    Assert.same([1,[1,2]], [1,[]], false);
    Assert.same([1,[1,2]], [1,[]], true);

    expect(4, 4);
  }

  public function testSameObject() {
    Assert.same({}, {});
    Assert.same({a:1}, {a:"1"});
    Assert.same({a:1,b:"c"}, {a:1,b:"c"});
    Assert.same({a:1,b:"c"}, {a:1,c:"c"});
    Assert.same({a:1,b:"c"}, {a:1});
    Assert.same({a:1,b:{a:1,c:"c"}}, {a:1,b:{a:1,c:"c"}});
    Assert.same({a:1,b:{a:1,c:"c"}}, {a:1,b:{}}, false);
    Assert.same({a:1,b:{a:1,c:"c"}}, {a:1,b:{}}, true);

    expect(4, 4);
  }

  public var value : String;
  public var sub : TestAssert;
  public function testSameInstance() {
    var c1 = new TestAssert();
    c1.value = "a";
    var c2 = new TestAssert();
    c2.value = "a";
    var c3 = new TestAssert();

    var r1 = new TestAssert();
    r1.sub = c1;
    var r2 = new TestAssert();
    r2.sub = c2;
    var r3 = new TestAssert();
    r3.sub = c3;


    Assert.same(c1, c1);
    Assert.same(c1, c2);
    Assert.same(c1, c3);

    Assert.same(r1, r2);
    Assert.same(r1, r3, false);
    Assert.same(r1, r3, true);

    expect(4, 2);
  }

  public function testSameIterable() {
    var list1 = new List<Dynamic>();
    list1.add("a");
    list1.add(1);
    var s1 = new List();
    s1.add(2);
    list1.add(s1);
    var list2 = new List<Dynamic>();
    list2.add("a");
    list2.add(1);
    list2.add(s1);
    var list3 = new List<Dynamic>();
    list3.add("a");
    list3.add(1);
    list3.add(new List());

    Assert.same(list1, list2);
    Assert.same(list1, list3, false);
    Assert.same(list1, list3, true);

    Assert.same(0...3, 0...3);
    Assert.same(0...3, 0...4);

    expect(3, 2);
  }

  public function testSameMap() {
    var h1 = new haxe.ds.StringMap();
    h1.set('a', 'b');
    h1.set('c', 'd');
    var h2 = new haxe.ds.StringMap();
    h2.set('a', 'b');
    h2.set('c', 'd');
    var h3 = new haxe.ds.StringMap();
    var h4 = new haxe.ds.StringMap();
    h4.set('c', 'd');

    var i1 = new haxe.ds.IntMap();
    i1.set(2, 'b');
    var i2 = new haxe.ds.IntMap();
    i2.set(2, 'b');

    Assert.same(h1, h2);
    Assert.same(h1, h3);
    Assert.same(h1, h4);
    Assert.same(i1, i2);

    expect(2, 2);
  }

  public function testSameEnums() {

    Assert.same(None, None);
    Assert.same(Some("a"), Some("a"));
    Assert.same(Some("a"), Some("b"), true);
    Assert.same(Some("a"), Some("b"), false);
    Assert.same(Some("a"), None);
    Assert.same(Rec(Rec(Some("a"))), Rec(Rec(Some("a"))));
    Assert.same(Rec(Rec(Some("a"))), Rec(None), true);
    Assert.same(Rec(Rec(Some("a"))), Rec(Rec(None)), false);

    expect(4, 4);
  }

  public function testEquals() {
    var values    : Array<Dynamic> = ["e", 1, 0.1, {}];
    var expecteds : Array<Dynamic> = ["e", 1, 0.1, {}];
    var i = 0;
    var expectedsuccess = 3;
    for(expected in expecteds)
      for(value in values) {
        i++;
        Assert.equals(expected, value);
      }
    expect(expectedsuccess, i-expectedsuccess);
  }

  public function testNearEqualsSuccess() {
    var counter = 0,
        tests = [
          { expected : 0.1, tests : [0.1, 0.100000000000000000000000000001, 0.099999999999999999999999999999] },
          { expected : 1, tests : [1, 1.000000000000000000000000000001, 0.999999999999999999999999999999 ] },
          { expected : Math.NaN, tests : [Math.NaN] },
          { expected : Math.NEGATIVE_INFINITY, tests : [Math.NEGATIVE_INFINITY] },
          { expected : Math.POSITIVE_INFINITY, tests : [Math.POSITIVE_INFINITY] },
          { expected : Math.PI, tests : [Math.PI] }
        ];
    for(test in tests) {
      for(value in test.tests) {
        counter++;
        Assert.nearEquals(test.expected, value);
      }
    }
    expect(counter, 0);
  }

  public function testNearEqualsFail() {
    var counter = 0,
        tests = [
          { expected : 0.1, tests : [0.2, 0.10000001, 0.0999998, Math.NaN, Math.POSITIVE_INFINITY, Math.NEGATIVE_INFINITY] },
          //{ expected : 1, tests : [2, 1.1, 0.9, Math.NaN, Math.POSITIVE_INFINITY, Math.NEGATIVE_INFINITY] },
          { expected : Math.NaN, tests : [2, 1.1, 0.9, Math.POSITIVE_INFINITY, Math.NEGATIVE_INFINITY] },
          { expected : Math.NEGATIVE_INFINITY, tests : [2, 1.1, 0.9, Math.NaN, Math.POSITIVE_INFINITY] },
          { expected : Math.POSITIVE_INFINITY, tests : [2, 1.1, 0.9, Math.NaN, Math.NEGATIVE_INFINITY] }
        ];
    for(test in tests) {
      for(value in test.tests) {
        counter++;
        Assert.nearEquals(test.expected, value);
      }
    }
    expect(0, counter);
  }

  public function testPass() {
    Assert.pass();
    expect(1, 0);
  }

  public function testFail() {
    Assert.fail();
    expect(0, 1);
  }

  public function testWarn() {
    Assert.warn("");
    expect(0, 0, 1);
  }

  public function expect(successes : Int, failures : Int, warnings : Int = 0, ?pos : haxe.PosInfos) {
    A.equals(successes, behavior.successes, 'expected ${successes} successes but they are ${behavior.successes}', pos);
    A.equals(failures, behavior.failures, 'expected ${failures} failures but they are ${behavior.failures}', pos);
    A.equals(warnings, behavior.warnings, 'expected ${warnings} warnings but they are ${behavior.warnings}', pos);
  }
}

class CollectBehavior implements IAssertBehavior {
  public var successes(default, null) : Int = 0;
  public var warnings(default, null) : Int = 0;
  public var failures(default, null) : Int = 0;

  public function new() {}

  public function success(pos : PosInfos)
    successes++;

  public function warn(message : String, pos : PosInfos)
    warnings++;

  public function fail(message : String, pos : PosInfos)
    failures++;
}

private enum Sample {
  None;
  Some(s : String);
  Rec(s : Sample);
}
