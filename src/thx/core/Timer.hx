package thx.core;

#if !js
import haxe.Timer in T;
#end

class Timer {
#if !js
  static var timers = new Map<Int, haxe.Timer>();
  static var _id = 0;
  public static function repeat(callback : Void -> Void, delay : Int) : TimerID {
    var id = _id++,
        timer = new T(delay);
    timer.run = callback;
    timers.set(id, timer);
    return id;
  }

  public static function delay(callback : Void -> Void, delay : Int) : TimerID {
    var id = _id++,
        timer = T.delay(function() {
          callback();
          clear(id);
        }, delay);
    timers.set(id, timer);
    return id;
  }

  public static function immediate(callback : Void -> Void) : TimerID
    return delay(callback, 0);

  public static function clear(id : TimerID) : Void {
    var timer = timers.get(id);
    if(null != timer) {
      timers.remove(id);
      timer.stop();
    }
  }

#else
  public inline static function repeat(callback : Void -> Void, ms : Int) : TimerID
    return untyped __js__('setInterval')(callback, ms);

  public inline static function delay(callback : Void -> Void, ms : Int) : TimerID
    return untyped __js__('setTimeout')(callback, ms);

  public inline static function immediate(callback : Void -> Void) : TimerID
    return untyped __js__('setImmediate')(callback);

  public inline static function clear(id : TimerID) : Void
    return untyped __js__('clearTimeout')(id);

  static function __init__() untyped {
    var scope : Dynamic = __js__('("undefined" !== typeof window && window) || ("undefined" !== typeof global && global) || this');
    if(!scope.setImmediate)
      scope.setImmediate = function(callback) scope.setTimeout(callback, 0);
  }
#end
}

#if !js
typedef TimerID = Int;
#else
extern
class TimerID {}
#end