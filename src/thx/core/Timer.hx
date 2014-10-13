package thx.core;

/**
`Timer` provides several meaning to delay the execution of code. At the moment it is only
implemented for platforms that have a native concept of Timer like Swf and JavaScript or c++/Neko
with OpenFL or NME.

All of the Timer methods return a function with signature Void -> Void that can be used to cancel
the timer.

```haxe
// set the execution delayed by 200ms
var cancel = Timer.delay(doSomethingLater, 200);

// cancel immediately (doSomethingLater will never be executed)
cancel();
```

Notice that calling the cancel function multiple times have no effect after the first execution.
**/
class Timer {
/**
Creates a function that delays the execution of `callback` by `delayms` every time it is
invoked. If `leading` is set to true, a first execution is guaranteed to happen as soon
as the returnd function is invoked.
**/
  public static function debounce(callback : Void -> Void, delayms : Int, leading = false) {
    var cancel = Functions.noop;
    function poll() {
      cancel();
      cancel = Timer.delay(callback, delayms);
    }
    return function() {
        if(leading) {
          leading = false;
          callback();
        }
        poll();
    }
  }

/**
The returned function executes `callback` at most once every `delayms` regardless of
how many times it is invoked in that timespance. Setting `leading` to true ensures
that the callback is invoked at the beginning of the cycle.
**/
  public static function throttle(callback : Void -> Void, delayms : Int, leading = false) {
    var waiting = false;
    function poll() {
      waiting = true;
      Timer.delay(callback, delayms);
    }
    return function() {
        if(leading) {
          leading = false;
          callback();
          return;
        }
        if(waiting)
          return;
        poll();
    };
  }

// IMPLEMENTATIONS

#if !(js || flash)
  static var timers = new Map<Int, haxe.Timer>();
  static var _id = 0;
#end

/**
`Timer.repeat` continues to invoke `callback` until it is cancelled using the returned
cancel function.
**/
  public static function repeat(callback : Void -> Void, delayms : Int) : Void -> Void {
#if js
    return clear.bind(untyped __js__('setInterval')(callback, delayms));
#elseif flash9
    return clear.bind(untyped __global__["flash.utils.setInterval"](callback, delayms));
#elseif flash
    return clear.bind(untyped _global["setInterval"](callback, delayms));
#elseif java
    var timer = new java.util.Timer();
    timer.scheduleAtFixedRate(new TimerTask(callback), haxe.Int64.ofInt(delayms), haxe.Int64.ofInt(delayms));
    return timer.cancel;
#else
    var id = _id++,
        timer = new haxe.Timer(delayms);
    timer.run = callback;
    timers.set(id, timer);
    return clear.bind(id);
#end
  }

/**
`Timer.delay` invokes `callback` after `delayms` milliseconds. The scheduling can be
canelled using the returned cancel function.
**/
  public static function delay(callback : Void -> Void, delayms : Int) : Void -> Void {
#if js
    return clear.bind(untyped __js__('setTimeout')(callback, delayms));
#elseif flash9
    return clear.bind(untyped __global__["flash.utils.setTimeout"](callback, delayms));
#elseif flash
    return clear.bind(untyped _global["setTimeout"](callback, delayms));
#elseif java
    var timer = new java.util.Timer();
    timer.scheduleAtFixedRate(new TimerTask(function() {
      timer.cancel();
      callback();
    }), haxe.Int64.ofInt(delayms), haxe.Int64.ofInt(delayms));
    return timer.cancel;
#else
    var id = _id++,
        timer = haxe.Timer.delay(function() {
          callback();
          clear(id);
        }, delayms);
    timers.set(id, timer);
    return clear.bind(id);
#end
  }

/**
`Timer.immediate` works essentially like `Timer.delay` with the exception that the delay
will be the shortest allowed by the platform. How short the delay depends a lot on
the target platform.
**/
  public static function immediate(callback : Void -> Void) : Void -> Void
#if js
    return clear.bind(untyped __js__('setImmediate')(callback));
#elseif java
    // not sure why this is needed
    return delay(callback, 1);
#else
    return delay(callback, 0);
#end

  static #if js inline #end function clear(id) : Void {
#if js
    return untyped __js__('clearTimeout')(id);
#elseif flash9
    return untyped __global__["flash.utils.clearTimeout"](id);
#elseif flash
    return untyped _global["clearTimeout"](id);
#else
    var timer = timers.get(id);
    if(null != timer) {
      timers.remove(id);
      timer.stop();
    }
#end
  }

#if js
  static function __init__() untyped {
    var scope : Dynamic = __js__('("undefined" !== typeof window && window) || ("undefined" !== typeof global && global) || this');
    if(!scope.setImmediate)
      scope.setImmediate = function(callback) scope.setTimeout(callback, 0);

    // based on Paul Irish code: http://www.paulirish.com/2011/requestanimationframe-for-smart-animating/
    var lastTime = 0,
        vendors = ['webkit', 'moz'],
        x = 0;

    while(x < vendors.length && !scope.requestAnimationFrame) {
      scope.requestAnimationFrame = scope[vendors[x]+'RequestAnimationFrame'];
      scope.cancelAnimationFrame = scope[vendors[x]+'CancelAnimationFrame'] || scope[vendors[x]+'CancelRequestAnimationFrame'];
      x++;
    }

    if (!scope.requestAnimationFrame)
      scope.requestAnimationFrame = function(callback) {
        var currTime = Date.now().getTime(),
            timeToCall = Math.max(0, 16 - (currTime - lastTime)),
            id = scope.setTimeout(function() callback(currTime + timeToCall), timeToCall);
        lastTime = currTime + timeToCall;
        return id;
      };

    if (!scope.cancelAnimationFrame)
      scope.cancelAnimationFrame = function(id) scope.clearTimeout(id);
  }
#end
}

#if java
@:nativeGen private class TimerTask extends java.util.TimerTask {
  var callback : Void -> Void;
  public function new(callback : Void -> Void) : Void {
    super();
    this.callback = callback;
  }

  override public function run()
    callback();
}
#end