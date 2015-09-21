/**
 * ...
 * @author Franco Ponticelli
 */

package thx;

import utest.Assert;
import thx.Timer;

class TestTimer {
  public function new() { }

  function assertTime(expected : Float, test : Float, ?pos : haxe.PosInfos) {
    var tollerance = expected * .5;
    Assert.isTrue(test >= expected - tollerance && test <= expected + tollerance, '$test is not in range of +/-$tollerance from $expected', pos);
  }

  public function testResolution() {
    var r = Timer.resolution();
    Assert.isTrue(r > 0);
  }

  public function testRepeat() {
    var done    = Assert.createAsync(1000),
        delay   = 100,
        start   = Date.now().getTime(),
        counter = 5,
        cancel  = null;
    cancel = Timer.repeat(function() {
      counter--;
      if(counter == 0) {
        var span = Date.now().getTime() - start;
        assertTime(500, span);
        cancel();
        done();
      }
    }, delay);
  }

  public function testDelay() {
    var done  = Assert.createAsync(),
        delay = 100,
        start = Date.now().getTime();
    Timer.delay(function() {
      var span = Date.now().getTime() - start;
      assertTime(delay, span);
      done();
    }, delay);
  }

  public function testCancelDelay() {
    var done  = Assert.createAsync(1000),
        delay = 100,
        stop  = 50;
    var cancel = Timer.delay(function() {
      Assert.fail('should never reach here');
    }, delay);

    Timer.delay(function() {
      cancel();
    }, stop);

    Timer.delay(function() {
      Assert.isTrue(true);
      done();
    }, stop + delay);
  }
}
