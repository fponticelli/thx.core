/**
 * ...
 * @author Franco Ponticelli
 */

package thx;

import utest.Assert;
import thx.AnonymousMap;
using thx.Iterators;
using thx.Iterables;
using thx.Options;

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

  public function testGetOption() {
    var map = new AnonymousMap({ key1 : 1 });

    Assert.same(map.getOption("key1").get(), 1);
    Assert.same(map.getOption("key2").toBool(), false);
  }
}
