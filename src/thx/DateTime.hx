package thx;

using haxe.Int64;

abstract DateTime(Array<Int64>) {
  public var utc(get, never) : DateTimeUtc;
  public var offset(get, never) : Time;

  inline function new(parts : Array<Int64>)
    this = parts;

  @:to inline function get_utc() : DateTimeUtc
    return new DateTimeUtc(this[0]);

  @:to inline function get_offset() : Time
    return new Time(this[1]);
}
