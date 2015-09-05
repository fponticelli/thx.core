package thx;

import utest.Assert;
import Type;
using thx.Dynamics;

class TestDynamics {
  public function new() { }

  public function testDynamics() {
    Assert.equals(null, Dynamics.clone(null));
    Assert.equals(true, true.clone());
    Assert.equals("hello", "hello".clone());
    Assert.equals(3, 3.clone());
    Assert.equals(3.14, (3.14).clone());
    Assert.equals(ValueType.TBool, ValueType.TBool.clone());
    Assert.isTrue(Type.enumEq(ValueType.TClass(TestDynamics), ValueType.TClass(TestDynamics).clone()));
    var date = Date.now();
    Assert.equals(date, date.clone());
    Assert.same(testDynamics, testDynamics.clone());

    var arr1 = [0,1,2];
    var arr2 = arr1.clone();
    Assert.notEquals(arr1, arr2);
    Assert.same(arr1, arr2);

    var obj1 = { name: "Franco", number: 0 };
    var obj2 = obj1.clone();
    Assert.notEquals(obj1, obj2);
    Assert.same(obj1, obj2);

    var inst1 = new Point(5,6);
    var inst2 = inst1.clone();
    Assert.equals(inst1, inst2);
    var inst3 = inst1.clone(true);
    Assert.notEquals(inst1, inst3);
    Assert.same(inst1.x, inst3.x);
  }
}

class Point {
  public var x:Int;
  public var y:Int;
  public function new(x,y) {
    this.x=x;
    this.y=y;
  }
}
