package thx;

import utest.Assert;
using thx.Arrays;
using thx.Functions;

class TestHashSet {
  public function new() { }

  public function testCreate() {
    var s = HashSet.create([new TestItem(1), new TestItem(3), new TestItem(2), new TestItem(3), new TestItem(1)]);
    Assert.same(3, s.length);
    Assert.isTrue(s.exists(new TestItem(1)));
  }

  public function testEmpty() {
    var s1 : HashSet<TestItem> = HashSet.create([new TestItem(1)]);
    var s2 = s1.empty();
    Assert.same(1, s1.length);
    Assert.same(0, s2.length);
  }

  public function testExists() {
    var i1 = new TestItem(1);
    var i2a = new TestItem(2);
    var i2b = new TestItem(2);
    var s = HashSet.create([i1, i2a, i2b]);
    Assert.same(2, s.length);
    Assert.isTrue(s.exists(i1));
    Assert.isTrue(s.exists(new TestItem(1)));
    Assert.isTrue(s.exists(i2a));
    Assert.isTrue(s.exists(i2b));
    Assert.isTrue(s.exists(new TestItem(2)));
  }

  public function testAdd() {
    var s : HashSet<TestItem> = HashSet.create();
    Assert.isTrue(s.add(new TestItem(1)));
    Assert.isTrue(s.add(new TestItem(2)));
    Assert.isFalse(s.add(new TestItem(2)));
    Assert.isTrue(s.add(new TestItem(3)));
    Assert.isFalse(s.add(new TestItem(3)));
    Assert.same(3, s.length);
  }

  public function testPush() {
    var s : HashSet<TestItem> = HashSet.create();
    s.add(new TestItem(1));
    s.add(new TestItem(2));
    s.add(new TestItem(2));
    s.add(new TestItem(3));
    s.add(new TestItem(3));
    Assert.same(3, s.length);
  }

  public function testRemove() {
    var i1 = new TestItem(1);
    var i2 = new TestItem(2);
    var s = HashSet.create([i1, i2]);
    s.remove(i1);
    Assert.same(1, s.length);
    s.remove(new TestItem(2));
    Assert.same(0, s.length);
  }

  public function testCopy() {
    var i1 = new TestItem(1);
    var i2 = new TestItem(2);
    var s1 = HashSet.create([i1, i2]);
    var s2 = s1.copy();
    Assert.same(2, s1.length);
    Assert.same(2, s2.length);
    Assert.isTrue(s1.exists(i1));
    Assert.isTrue(s1.exists(new TestItem(2)));
    Assert.isTrue(s2.exists(i1));
    Assert.isTrue(s2.exists(new TestItem(2)));
    s1.add(new TestItem(3));
    Assert.same(3, s1.length);
    Assert.same(2, s2.length);
  }

  public function testUnion() {
    var s1 = HashSet.create([new TestItem(1), new TestItem(2), new TestItem(3)]);
    var s2 = HashSet.create([new TestItem(2), new TestItem(3), new TestItem(4), new TestItem(5)]);
    var s3 = s1.union(s2);
    Assert.same(3, s1.length);
    Assert.same(4, s2.length);
    Assert.same(5, s3.length);
    Assert.isTrue(s3.exists(new TestItem(1)));
    Assert.isTrue(s3.exists(new TestItem(2)));
    Assert.isTrue(s3.exists(new TestItem(3)));
    Assert.isTrue(s3.exists(new TestItem(4)));
    Assert.isTrue(s3.exists(new TestItem(5)));
  }

  public function testIntersection() {
    var s1 = HashSet.create([new TestItem(1), new TestItem(2), new TestItem(3)]);
    var s2 = HashSet.create([new TestItem(2), new TestItem(3), new TestItem(4), new TestItem(5)]);
    var s3 = s1.intersection(s2);
    Assert.same(3, s1.length);
    Assert.same(4, s2.length);
    Assert.same(2, s3.length);
    Assert.isTrue(s3.exists(new TestItem(2)));
    Assert.isTrue(s3.exists(new TestItem(3)));
  }

  public function testDifference() {
    var s1 = HashSet.create([new TestItem(1), new TestItem(2), new TestItem(3)]);
    var s2 = HashSet.create([new TestItem(2), new TestItem(3), new TestItem(4), new TestItem(5)]);
    var s3 = s1.difference(s2); // items in 1 that are not in 2
    var s4 = s2.difference(s1); // items in 2 that are not in 1
    Assert.same(3, s1.length);
    Assert.same(4, s2.length);
    Assert.same(1, s3.length);
    Assert.same(2, s4.length);
    Assert.isTrue(s3.exists(new TestItem(1)));
    Assert.isTrue(s4.exists(new TestItem(4)));
    Assert.isTrue(s4.exists(new TestItem(5)));
  }

  public function testSymmetricDifference() {
    var s1 = HashSet.create([new TestItem(1), new TestItem(2), new TestItem(3)]);
    var s2 = HashSet.create([new TestItem(2), new TestItem(3), new TestItem(4), new TestItem(5)]);
    var s3 = s1.symmetricDifference(s2);
    var s4 = s2.symmetricDifference(s1);
    Assert.same(3, s1.length);
    Assert.same(4, s2.length);
    Assert.same(3, s3.length);
    Assert.same(3, s4.length);
    Assert.isTrue(s3.exists(new TestItem(1)));
    Assert.isTrue(s3.exists(new TestItem(4)));
    Assert.isTrue(s3.exists(new TestItem(5)));
    Assert.isTrue(s4.exists(new TestItem(1)));
    Assert.isTrue(s4.exists(new TestItem(4)));
    Assert.isTrue(s4.exists(new TestItem(5)));
  }

  public function testToArray() {
    var s = HashSet.create([new TestItem(1), new TestItem(2)]);
    var a = s.toArray();
    Assert.same(2, a.length);
    Assert.same(1, a.find.fn(_.code == 1).code);
    Assert.same(2, a.find.fn(_.code == 2).code);
  }

  public function testToString() {
    var s = HashSet.create([new TestItem(1), new TestItem(2)]);
    Assert.isTrue(~/TestItem \d, TestItem \d}/.match(s.toString()));
  }
}

class TestItem {
  public var code : Int;

  public function new(code) {
    this.code = code;
  }

  public function hashCode() : Int {
    return code;
  }

  public function toString() {
    return 'TestItem $code';
  }
}
