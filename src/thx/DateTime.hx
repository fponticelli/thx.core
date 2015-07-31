package thx;

using haxe.Int64;
using thx.Int64s;
import thx.DateTimeUtc.*;

@:access(thx.DateTimeUtc)
abstract DateTime(Array<Int64>) {
  static public function localOffset() : Time {
// Date.getTime() in C# is broken hence the special case
#if cs
      var now = cs.system.DateTime.Now;
      return new Time(now.ToUniversalTime().Ticks - now.ToLocalTime().Ticks);
#else
    var now = DateTimeUtc.now(),
        local = new Date(now.year, now.month - 1, now.day, now.hour, now.minute, now.second),
        delta = local.getTime() - Math.ffloor(now.toFloat() / 1000) * 1000;

    return new Time(Int64s.fromFloat(delta) * ticksPerMillisecondI64);
#end
  }

  public var utc(get, never) : DateTimeUtc;
  public var offset(get, never) : Time;

  inline function new(parts : Array<Int64>)
    this = parts;

  @:to inline function get_utc() : DateTimeUtc
    return new DateTimeUtc(this[0]);

  @:to inline function get_offset() : Time
    return new Time(this[1]);
}
