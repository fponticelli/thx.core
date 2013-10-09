/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

import utest.Assert;
import thx.core.Procedure;

class TestProcedure
{
	public function new() { }

	public function testBasics0()
	{
		var count = 0,
			p : Procedure<Void -> Void> = function() { count++; };

		Assert.equals(0, p.getArity());
		p.apply([]);
		Assert.equals(1, count);
		var f : Void -> Void = p;
		f();
		Assert.equals(2, count);
		p.getFunction()();
		Assert.equals(3, count);
	}

	public function testBasics1()
	{
		var count = 0,
			p : Procedure<Int -> Void> = function(v : Int) { count += 1; };

		Assert.equals(1, p.getArity());
		p.apply([1]);
		Assert.equals(1, count);
		var f : Int -> Void = p;
		f(1);
		Assert.equals(2, count);
		p.getFunction()(1);
		Assert.equals(3, count);
	}

	public function testToFunction()
	{
		var p : Procedure<Void -> Void> = function() { };
		Assert.raises(
			function() var f : Int -> Void = p
		);
	}
}