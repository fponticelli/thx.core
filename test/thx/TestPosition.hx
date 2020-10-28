package thx;

import utest.Assert.*;
import thx.Position;

class TestPosition extends utest.Test {
	public function test() {
		var pos = Position.here();
		equals("thx.test/thx/TestPosition.TestPosition?L=8#test", '$pos');
		equals("thx.TestPosition#test", pos.getClassMethodString());
		equals("thx.test/thx/TestPosition.FileNameNotModule?L=17#get", FileNameNotModule.get().toString());
	}
}

class FileNameNotModule {
	static public function get() {
		return Position.here();
	}
}
