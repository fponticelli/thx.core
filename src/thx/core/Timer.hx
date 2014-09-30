package thx.core;

#if !js
import haxe.Timer in T;
#end

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
#if !js
  static var timers = new Map<Int, haxe.Timer>();
  static var _id = 0;
#end

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
`Timer.repeat` continues to invoke `callback` until it is cancelled using the returned
cancel function.
**/
  public static function repeat(callback : Void -> Void, delayms : Int) : Void -> Void {
#if !js
    var id = _id++,
        timer = new T(delayms);
    timer.run = callback;
    timers.set(id, timer);
    return clear.bind(id);
#else
    return clear.bind(untyped __js__('setInterval')(callback, delayms));
#end
  }

/**
`Timer.delay` invokes `callback` after `delayms` milliseconds. The scheduling can be
canelled using the returned cancel function.
**/
  public static function delay(callback : Void -> Void, delayms : Int) : Void -> Void {
#if !js
    var id = _id++,
        timer = T.delay(function() {
          callback();
          clear(id);
        }, delayms);
    timers.set(id, timer);
    return clear.bind(id);
#else
    return clear.bind(untyped __js__('setTimeout')(callback, delayms));
#end
  }

/**
`Timer.immediate` works essentially like `Timer.delay` with the exception that the delay
will be the shortest allowed by the platform. How short the delay depends a lot on
the target platform.
**/
  public static function immediate(callback : Void -> Void) : Void -> Void
#if !js
    return delay(callback, 0);
#else
    return clear.bind(untyped __js__('setImmediate')(callback));
#end

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

  static #if js inline #end function clear(id) : Void {
#if !js
    var timer = timers.get(id);
    if(null != timer) {
      timers.remove(id);
      timer.stop();
    }
#else
    return untyped __js__('clearTimeout')(id);
#end
  }

#if js
  static function __init__() untyped {
    var scope : Dynamic = __js__('("undefined" !== typeof window && window) || ("undefined" !== typeof global && global) || this');
    if(!scope.setImmediate)
      scope.setImmediate = function(callback) scope.setTimeout(callback, 0);
  }
#end
}