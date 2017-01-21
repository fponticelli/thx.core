package thx;

import haxe.Json;
import thx.Error;
using thx.Arrays;

class Convert {
  public static function toString(value : Dynamic) : String {
    switch Type.typeof(value) {
      case TNull:
        return null;
      case TInt, TFloat, TBool:
        return '$value';
      case TObject:
        return try Json.stringify(value) catch(e : Dynamic) throw new Error('unable to convert object to String');
      case TClass(c):
        switch Type.getClassName(c) {
          case "String":
            return value;
          case "Date":
            return (value : Date).toString();
          default:
            if(Maps.isMap(value))
              return try Json.stringify(Maps.toObject(value)) catch(e : Dynamic) throw new Error('unable to convert object to String');
            else
              return throw new Error('unable to convert $value to String');
        }
      case _:
        return throw new Error('unable to convert $value to String');
    }
  }

  public static function toStringOr(value : Dynamic, alt : String) : String
    return null == value ? alt : toString(value);

  public static function toInt(value : Dynamic) : Int {
    if(null == value) throw new Error('unable to convert null to Int');
    return switch Types.valueTypeToString(value) {
      case "Int":
        (value : Int);
      case "Float":
        Std.int((value : Int));
      case "String" if(Ints.canParse((value : String))):
        Ints.parse((value : String));
      case "Bool":
        (value : Bool) ? 1 : 0;
      case _:
        throw new Error('unable to convert $value to Int');
    }
  }

  public static function toIntOr(value : Dynamic, alt : Int) : Int
    return try toInt(value) catch(e : Error) alt;

  public static function toFloat(value : Dynamic) : Float {
    if(null == value) throw new Error('unable to convert null to Float');
    return switch Types.valueTypeToString(value) {
      case "Int", "Float":
        (value : Float);
      case "String" if(Floats.canParse((value : String))):
        Floats.parse((value : String));
      case "Date":
        (value : Date).getTime();
      case "Bool":
        (value : Bool) ? 1.0 : 0.0;
      case _:
        throw new Error('unable to convert $value to Float');
    }
  }

  public static function toFloatOr(value : Dynamic, alt : Float) : Float
    return try toFloat(value) catch(e : Error) alt;

  public static function toBool(value : Dynamic) : Bool {
    if(null == value) throw new Error('unable to convert null to Bool');
    return switch Types.valueTypeToString(value) {
      case "Int", "Float":
        (value : Float) != 0;
      case "Bool":
        (value : Bool);
      case "String" if(Bools.canParse((value : String))):
        Bools.parse((value : String));
      case _:
        throw new Error('unable to convert $value to Bool');
    }
  }

  public static function toBoolOr(value : Dynamic, alt : Bool) : Bool
    return try toBool(value) catch(e : Error) alt;

  public static function toDate(value : Dynamic) : Date {
    if(null == value) throw new Error('unable to convert null to Date');
    return switch Types.valueTypeToString(value) {
      case "Int", "Float":
        Date.fromTime((value : Float));
      case "String":
        try
          Date.fromString((value : String))
        catch(e : Dynamic)
          throw new Error('unable to convert string $value to Date');
      case "Date":
        (value : Date);
      case _:
        throw new Error('unable to convert $value to Date');
    }
  }

  public static function toDateOr(value : Dynamic, alt : Date) : Date
    return try toDate(value) catch(e : Error) alt;

  public static function toDateTime(value : Dynamic) : Null<DateTime> {
    if(null == value) return null;
    return switch Types.valueTypeToString(value) {
      case "Int", "Float":
        DateTime.fromTime((value : Float));
      case "String":
        try
          DateTime.fromString((value : String))
        catch(e : Dynamic)
          throw new Error('unable to convert string $value to DateTime');
      case "Date":
        (value : Date);
      case _:
        throw new Error('unable to convert $value to DateTime');
    }
  }

  public static function toDateTimeOr(value : Dynamic, alt : DateTime) : Null<DateTime> {
    var v = try toDateTime(value) catch(e : Error) null;
    return null == v ? alt : v;
  }

  public static function toDateTimeUtc(value : Dynamic) : Null<DateTimeUtc> {
    if(null == value) return null;
    return switch Types.valueTypeToString(value) {
      case "Int", "Float":
        DateTimeUtc.fromTime((value : Float));
      case "String":
        try
          DateTimeUtc.fromString((value : String))
        catch(e : Dynamic)
          throw new Error('unable to convert string $value to DateTimeUtc');
      case "Date":
        (value : Date);
      case _:
        throw new Error('unable to convert $value to DateTimeUtc');
    };
  }

  public static function toDateTimeUtcOr(value : Dynamic, alt : DateTimeUtc) : Null<DateTimeUtc> {
    var v = try toDateTimeUtc(value) catch(e : Error) null;
    return null == v ? alt : v;
  }

  public static function toObject(value : Dynamic) : {} {
    if(null == value)
      return null;
    if(Types.isObject(value))
      return (value : {});
    return switch Types.valueTypeToString(value) {
      case "String":
        try {
          var v = Json.parse((value : String));
  #if php
          if(null == v)
            throw new Error('unable to convert string $value to Object');
  #end
          return v;
        } catch(e : Dynamic)
          throw new Error('unable to convert string $value to Object');
      case _:
        throw new Error('unable to convert $value to Object');
    }
  }

  public static function toObjectOr(value : Dynamic, alt : {}) : {} {
    if(null == value) return alt;
    return try toObject(value) catch(e : Error) alt;
  }

  public static function toArrayString(value : Dynamic) : Array<String>
    return toArray(value, Convert.toString);

  public static function toArrayStringOr(value : Dynamic, alt : Array<String>) : Array<String> {
    if(null == value) return alt;
    return try toArrayString(value) catch(e : Error) alt;
  }

  public static function toArrayInt(value : Dynamic) : Array<Int>
    return toArray(value, toInt);

  public static function toArrayIntOr(value : Dynamic, alt : Array<Int>) : Array<Int> {
    if(null == value) return alt;
    return try toArrayInt(value) catch(e : Error) alt;
  }

  public static function toArrayFloat(value : Dynamic) : Array<Float>
    return toArray(value, toFloat);

  public static function toArrayFloatOr(value : Dynamic, alt : Array<Float>) : Array<Float> {
    if(null == value) return alt;
    return try toArrayFloat(value) catch(e : Error) alt;
  }

  public static function toArrayBool(value : Dynamic) : Array<Bool>
    return toArray(value, toBool);

  public static function toArrayBoolOr(value : Dynamic, alt : Array<Bool>) : Array<Bool> {
    if(null == value) return alt;
    return try toArrayBool(value) catch(e : Error) alt;
  }

  public static function toArrayDate(value : Dynamic) : Array<Date>
    return toArray(value, toDate);

  public static function toArrayDateOr(value : Dynamic, alt : Array<Date>) : Array<Date> {
    if(null == value) return alt;
    return try toArrayDate(value) catch(e : Error) alt;
  }

  public static function toArrayDateTime(value : Dynamic) : Array<DateTime>
    return toArray(value, toDateTime);

  public static function toArrayDateTimeOr(value : Dynamic, alt : Array<DateTime>) : Array<DateTime> {
    if(null == value) return alt;
    return try toArrayDateTime(value) catch(e : Error) alt;
  }

  public static function toArrayObject(value : Dynamic) : Array<{}>
    return toArray(value, toObject);

  public static function toArrayObjectOr(value : Dynamic, alt : Array<{}>) : Array<{}> {
    if(null == value) return alt;
    return try toArrayObject(value) catch(e : Error) alt;
  }

  public static function toArray<T>(value : Dynamic, convert : Dynamic -> T) : Array<T> {
    if(null == value) return [];
    return Std.is(value, Array) ?
      (value : Array<Dynamic>).map(convert):
      throw new Error('unable to convert $value to Array<T>');
  }

  public static function toMap<T>(value : Dynamic, convert : Dynamic -> T) : Map<String, T> {
    var obj = toObject(value);
    return Reflect.fields(obj).reduce(function (map : Map<String, T>, field : String) {
      map.set(field, convert(Reflect.field(obj, field)));
      return map;
    }, new Map());
  }
}
