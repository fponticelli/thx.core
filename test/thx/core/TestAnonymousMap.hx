/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

import utest.Assert;
import thx.core.AnonymousMap;
using thx.core.Iterators;
using thx.core.Iterables;

class TestAnonymousMap {
  public function new() { }

  public function testFeatures() {
    var map = new AnonymousMap({ name : 'thx', type : 'library' });
    Assert.equals('thx', map.get('name'));
    Assert.isTrue(map.exists('type'));
    map.remove('type');
    Assert.isFalse(map.exists('type'));
    Assert.same(['name'], map.keys().toArray());
    Assert.same(['thx'], map.toArray());
  }
}