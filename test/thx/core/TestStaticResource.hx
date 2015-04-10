package thx.core;

import utest.Assert;

class TestStaticResource {
	public function new() {}

	public function testBasics() {
		Assert.equals(1, ResourceTest.a);
		Assert.notNull(ResourceTest.b);
		Assert.equals("thx", ResourceTest.b.s);
		Assert.isTrue(ResourceTest.c);
		Assert.equals("haxe", ResourceTest.d);
		Assert.equals("value", ResourceTest.fileJson.some);
		Assert.equals("some text\n", ResourceTest.fileText);
	}
}

@:content({ a : 1 })
@:json("test/thx/core/other-resource")
@:file("test/thx/core/resource.json")
@:resolve("&")
class ResourceTest implements StaticResource {

}
