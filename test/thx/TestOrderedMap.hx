package thx;

using thx.OrderedMap;
using thx.Functions;
import thx.Functions.fn;
using thx.Iterators;
using thx.Options;
import utest.Assert;

class TestOrderedMap {
  public function new() {}

  @:access(thx.core.OrderedMapList.new)
  public function testBasics() {
    var ml = OrderedMap.createString();

    Assert.equals(0, ml.length);
    Assert.equals("[]", ml.toString());

    ml.set("z", "Z");
    ml.set("y", "Y");
    ml.set("y", "Y");
    ml.set("x", "X");

    Assert.equals(3, ml.length);
    Assert.equals("[z => Z, y => Y, x => X]", ml.toString());

    Assert.isTrue(ml.remove("y"));
    Assert.isFalse(ml.remove("y"));

    Assert.equals(2, ml.length);
    Assert.equals("[z => Z, x => X]", ml.toString());

    ml.insert(1, "y", "Y");

    Assert.equals(3, ml.length);
    Assert.equals("[z => Z, y => Y, x => X]", ml.toString());

    Assert.equals("y", ml.keyAt(1));
    Assert.equals("Y", ml.at(1));

    Assert.equals(1, ml.keyIndex("y"));
    Assert.equals(1, ml.valueIndex("Y"));

    ml.removeAt(1);

    Assert.equals(2, ml.length);
    Assert.equals("[z => Z, x => X]", ml.toString());

    Assert.same(["Z", "X"], ml.toArray());
    Assert.same(["z", "x"], ml.keys().toArray());
  }

  public function testGetOption() {
    var m = OrderedMap.createString();
    m.set("key1", 1);

    Assert.same(m.getOption("key1").get(), 1);
    Assert.same(m.getOption("key2").toBool(), false);
  }

  public function testToTuples() {
    var m = OrderedMap.createString();
    m.set("foo", 10);
    m.set("bar", 20);
    m.insert(2, "baz", 30);

    var tuples = m.tuples();

    Assert.same("foo", tuples[0].left);
    Assert.same(20, tuples[1].right);
    Assert.same("baz", tuples[2].left);
    Assert.same(30, tuples[2].right);
  }

  public function testAbstract() {
    var ml = OrderedMap.createString();
    ml["k"] = "value";
    Assert.equals("value", ml["k"]);
    Assert.equals("value", ml.at(0));
    Assert.equals("value", ml[0]);

    function acceptMap(m : haxe.Constraints.IMap<String, String>)
        Assert.equals("value", m.get("k"));

    acceptMap(ml);
#if !cs
    Assert.notNull(OrderedMap.createInt());
#end
    Assert.notNull(OrderedMap.createEnum());
    Assert.notNull(OrderedMap.createObject());
  }

  public function testEmpty() {
    var ml = OrderedMap.createString();
    ml["k"] = "value";
    var e = ml.empty();
    Assert.isNull(e["k"]);
  }

  public function testCopyTo() {
    var ml = OrderedMap.createString();
    ml["k"] = "value";
    var e = ml.empty();
    ml.copyTo(e);
    Assert.equals("value", e["k"]);
  }

  public function testClone() {
    var ml = OrderedMap.createString();
    ml["k"] = "value";
    var e = ml.clone();
    Assert.equals("value", e["k"]);
  }

  public function testStringAbstractKey() {
    var map : OrderedMap<TestStringId, String> = OrderedMap.createString();
    map.set(new TestStringId("1"), "a");
    map.set(new TestStringId("2"), "b");
    map.set(new TestStringId("3"), "c");
    map.set(new TestStringId("1"), "d");
    Assert.same(3, map.keys().toArray().length);
    Assert.same([new TestStringId("1"), new TestStringId("2"), new TestStringId("3")], map.keys().toArray());
    Assert.same("d", map.get(new TestStringId("1")));
    Assert.same("b", map.get(new TestStringId("2")));
    Assert.same("c", map.get(new TestStringId("3")));

    var map2 = StringOrderedMap.fromArray([{k:"1", v:"a"}, {k:"2", v:"b"}, {k:"3", v:"c"}, {k:"1", v:"d"}], fn(_.k), fn(_.v));
    Assert.same(map, map2);

    var map3 = StringOrderedMap.fromValueArray(["a", "b", "c", "d"], function(v : String) {
      return if (v == "a") "1";
        else if (v == "b") "2";
        else if (v == "c") "3";
        else "1";
    });
    Assert.same(map, map3);

    var map4 = StringOrderedMap.fromTuples([
      new Tuple("1", "a"),
      new Tuple("2", "b"),
      new Tuple("3", "c"),
      new Tuple("1", "d")
    ]);
    Assert.same(map, map4);
  }

#if !cs
  public function testIntAbstractKey() {
    var map : OrderedMap<TestIntId, String> = OrderedMap.createInt();
    map.set(new TestIntId(1), "a");
    map.set(new TestIntId(2), "b");
    map.set(new TestIntId(3), "c");
    map.set(new TestIntId(1), "d");
    Assert.same(3, map.keys().toArray().length);
    Assert.same([new TestIntId(1), new TestIntId(2), new TestIntId(3)], map.keys().toArray());
    Assert.same("d", map.get(new TestIntId(1)));
    Assert.same("b", map.get(new TestIntId(2)));
    Assert.same("c", map.get(new TestIntId(3)));
  }
#end
}

abstract TestStringId(String) to String {
  public function new(id) this = id;
}

abstract TestIntId(Int) to Int {
  public function new(id) this = id;
}
