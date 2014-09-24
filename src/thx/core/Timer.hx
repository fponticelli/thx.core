package thx.core;

#if !js
import haxe.Timer in T;
#end

class Timer {
#if !js
  static var timers = new Map<Int, haxe.Timer>();
  static var _id = 0;
#end
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