package thx;

using thx.OrderedMap;
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

    Assert.notNull(OrderedMap.createInt());
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
}
