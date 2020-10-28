/**
 * ...
 * @author Franco Ponticelli
 */

package thx;

import utest.Assert;
import thx.Timer;

class TestTimer extends utest.Test {
	function assertTime(expected:Float, test:Float, ?pos:haxe.PosInfos) {
		var tollerance = expected * .5;
		Assert.isTrue(test >= expected - tollerance && test <= expected + tollerance, '$test is not in range of +/-$tollerance from $expected', pos);
	}

	public function testResolution() {
		var r = Timer.resolution();
		Assert.isTrue(r > 0);
	}

	public function testRepeat(async:utest.Async) {
		async.setTimeout(120);
		var delay = 20,
			start = Date.now().getTime(),
			counter = 5,
			cancel = null;
		cancel = Timer.repeat(function() {
			counter--;
			if (counter == 0) {
				var span = Date.now().getTime() - start;
				assertTime(100, span);
				cancel();
				async.done();
			}
		}, delay);
	}

	public function testDelay(async:utest.Async) {
		var delay = 100, start = Date.now().getTime();
		Timer.delay(function() {
			var span = Date.now().getTime() - start;
			assertTime(delay, span);
			async.done();
		}, delay);
	}

	public function testCancelDelay(async:utest.Async) {
		var delay = 100, stop = 50;
		var cancel = Timer.delay(function() {
			Assert.fail('should never reach here');
		}, delay);

		Timer.delay(function() {
			cancel();
		}, stop);

		Timer.delay(function() {
			Assert.isTrue(true);
			async.done();
		}, stop + delay);
	}
}
