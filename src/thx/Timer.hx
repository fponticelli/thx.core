package thx;

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

Note that calling the cancel function multiple times have no effect after the first execution.
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
// #elseif java
//     var executorService = java.util.concurrent.Executors.newSingleThreadScheduledExecutor();
//     var handler = executorService.scheduleAtFixedRate(new TimerTask(callback), haxe.Int64.ofInt(delayms), haxe.Int64.ofInt(delayms), java.util.concurrent.TimeUnit.MILLISECONDS);
//     return handler.cancel.bind(true);
#elseif !lime
    return throw "platform does not support delays (Timer.repeat)";
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
// #elseif java
//     var executorService = java.util.concurrent.Executors.newSingleThreadScheduledExecutor();
//     var handler = executorService.schedule(new TimerTask(callback), haxe.Int64.ofInt(delayms), java.util.concurrent.TimeUnit.MILLISECONDS);
//     return handler.cancel.bind(true);
#elseif !lime
    return throw "platform does not support delays (Timer.delay)";
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
Invokes `callback` at every frame using native implementation where available. A delta time
in milliseconds is passed since the latest time callback was invoked.
**/
  public static function frame(callback : Float -> Void) {
#if js
    var cancelled = false,
        f = Functions.noop,
        current = time(),
        next;
    f = function() {
          if(cancelled) return;
          next = time();
          callback(next - current);
          current = next;
          untyped __js__("requestAnimationFrame")(f);
        };

    untyped __js__("requestAnimationFrame")(f);
    return function() cancelled = true;
#elseif openfl
    var current = time(),
        next,
        listener = function(_) {
          next = time();
          callback(next - current);
          current = next;
        };
    openfl.Lib.current.addEventListener(openfl.events.Event.ENTER_FRAME, listener);
    return function()
      openfl.Lib.current.removeEventListener(openfl.events.Event.ENTER_FRAME, listener);
#elseif flash9
    var current = time(),
        next,
        listener = function(_) {
          next = time();
          callback(next - current);
          current = next;
        };
    flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, listener);
    return function()
      flash.Lib.current.removeEventListener(flash.events.Event.ENTER_FRAME, listener);
#else
    var current = time(),
        next,
        listener = function() {
          next = time();
          callback(next - current);
          current = next;
        };
    return repeat(listener, FRAME_RATE);
#end
  }

/**
Delays `callback` untile the next frame using native implementation where available.
**/
  public static function nextFrame(callback : Void -> Void) {
#if js
    var id = untyped __js__("requestAnimationFrame")(callback);
    return function() untyped __js__("cancelAnimationFrame")(id);
#elseif openfl
    var listener = null,
        cancel = function() openfl.Lib.current.removeEventListener(openfl.events.Event.ENTER_FRAME, listener);
    listener = function(_) {
      cancel();
      callback();
    };
    openfl.Lib.current.addEventListener(openfl.events.Event.ENTER_FRAME, listener);
    return cancel;
#elseif flash9
    var listener = null,
        cancel = function() flash.Lib.current.removeEventListener(flash.events.Event.ENTER_FRAME, listener);
    listener = function(_) {
      cancel();
      callback();
    };
    flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, listener);
    return cancel;
#else
  return delay(callback, FRAME_RATE);
#end
  }

  static var FRAME_RATE = Math.round(1000 / 60);

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
#elseif !lime
    return throw "platform does not support delays (Timer.clear)";
#else
    var timer = timers.get(id);
    if(null != timer) {
      timers.remove(id);
      timer.stop();
    }
#end
  }

/**
Returns a time value in milliseconds. Where supported, the decimal value represents microseconds.

Note that the initial value might change from platform to platform so only delta measurements make sense.
**/
  inline public static function time() : Float
#if js
    return untyped __js__("performance").now();
#elseif flash
    return flash.Lib.getTimer();
#elseif (cpp || neko || eval)
    return haxe.Timer.stamp() * 1000.0;
#elseif cs
    return (cs.system.Environment.TickCount : Float);
#elseif java
    return cast(java.lang.System.nanoTime(), Float) / 1000000.0;
#elseif php
    return untyped __php__('microtime(true) * 1000.0');
#elseif python
    return python.lib.Time.clock() * 1000;
#else
    return throw 'Timer.time() is not implemented in this target';
#end

  static var _resolution : Null<Float>;
  public static function resolution() : Float {
    if(null != _resolution)
      return _resolution;
    var start = time(),
        end, loop = 0.0;
    do {
      loop++;
      end = Timer.time();
    } while(end - start == 0);
    return _resolution = end - start;
  }

#if js
  static function __init__() untyped {
    // Polyfills
    // SCOPE
    var scope : Dynamic = __js__('("undefined" !== typeof window && window) || ("undefined" !== typeof global && global) || Function("return this")()');

    // setImmediate
    if(!scope.setImmediate)
      scope.setImmediate = function(callback) scope.setTimeout(callback, 0);

    // rAF
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

    // performance.now /  High Resolution Timer
    if(__js__("typeof")(scope.performance) == "undefined")
      scope.performance = {};

    if(__js__("typeof")(scope.performance.now) == "undefined") {
      var nowOffset = Date.now().getTime();

      if (scope.performance.timing && scope.performance.timing.navigationStart)
        nowOffset = scope.performance.timing.navigationStart;

      scope.performance.now = function now()
        return Date.now() - nowOffset;
    }
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

  @:overload override public function run()
    callback();
}
#end
