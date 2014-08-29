/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

import utest.Assert;
import thx.core.Timer;

class TestTimer {
  public function new() { }


  function assertTime(expected : Float, test : Float, ?pos : haxe.PosInfos) {
    var tollerance = expected * .2;
    Assert.isTrue(test >= expected - tollerance && test <= expected + tollerance, '$test is not in range of +/-$tollerance from $expected', pos);
  }

  public function testRepeat() {
    var done    = Assert.createAsync(600),
        delay   = 100,
        start   = Date.now().getTime(),
        counter = 5,
        id      = null;
    id = Timer.repeat(function() {
      counter--;
      if(counter == 0) {
        var span = Date.now().getTime() - start;
        assertTime(500, span);
        Timer.clear(id);
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
    var done  = Assert.createAsync(),
        delay = 100,
        stop  = 50,
        id    = null;
    id = Timer.delay(function() {
      Assert.fail('should never reach here');
    }, delay);

    Timer.delay(function() {
      Timer.clear(id);
    }, stop);

    Timer.delay(function() {
      Assert.isTrue(true);
      done();
    }, stop + delay);
  }
}