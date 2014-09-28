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