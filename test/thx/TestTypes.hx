package thx;

import utest.Assert;
import thx.Types;

class TestTypes extends utest.Test {
	public function testIsObject() {
		Assert.isFalse(Types.isObject("test"));
	}
}
