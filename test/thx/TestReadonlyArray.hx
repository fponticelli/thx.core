/**
 * @author Franco Ponticelli
 */

package thx;

import utest.Assert;
import thx.ReadonlyArray;

class TestReadonlyArray {
  public function new() { }

  public function testInsertAt() {
    var a : ReadonlyArray<Int> = [1,2,4],
        b = a.insertAt(0, 0);
    Assert.isTrue(a != b);
    Assert.same([0,1,2,4], b);

    b = a.insertAt(2, 3);
    Assert.same([1,2,3,4], b);

    b = a.insertAt(10, 5);
    Assert.same([1,2,4,5], b);
  }

  public function testReplaceAt() {
    var a : ReadonlyArray<Int> = [1,2,4],
        b = a.replaceAt(0, 0);
    Assert.isTrue(a != b);
    Assert.same([0,2,4], b);

    b = a.replaceAt(2, 3);
    Assert.same([1,2,3], b);

    b = a.replaceAt(10, 5);
    Assert.same([1,2,4,5], b);
  }
}
