package thx.core;

import utest.Assert;

class TestResource {
	public function new() {}

	public function testBasics() {
		Assert.equals(1, ResourceTest.a);
		Assert.notNull(ResourceTest.b);
		Assert.equals("thx", ResourceTest.b.s);
		Assert.isTrue(ResourceTest.c);
		Assert.equals("haxe", ResourceTest.d);
	}
}

@:content({ a : 1 })
@:json("test/thx/core/other-resource")
@:file("test/thx/core/resource.json")
class ResourceTest implements StaticResource {

}
