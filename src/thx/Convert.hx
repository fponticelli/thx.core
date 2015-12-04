package thx;

import thx.Error;

class Convert {
  public static function toString(value : Dynamic) : String {
    if(null == value) return null;
    return Dynamics.string(value);
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

  public static function toDateTime(value : Dynamic) : DateTime {
    if(null == value) throw new Error('unable to convert null to DateTime');
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

  public static function toDateTimeOr(value : Dynamic, alt : DateTime) : DateTime
    return try toDateTime(value) catch(e : Error) alt;

  public static function toObject(value : Dynamic) : {} {
    if(null == value)
      return null;
    if(Reflect.isObject(value))
      return (value : {});
    return switch Types.valueTypeToString(value) {
      case "String":
        try
          haxe.Json.parse((value : String))
        catch(e : Dynamic)
          throw new Error('unable to convert string $value to Object');
      case _:
        throw new Error('unable to convert $value to Object');
    }
  }

  public static function toObjectOr(value : Dynamic, alt : {}) : {} {
    if(null == value) return alt;
    return try toObject(value) catch(e : Error) alt;
  }

  public static function toArrayString(value : Dynamic) : Array<String> {
    if(null == value) return null;
    return Std.is(value, Array) ?
      (value : Array<Dynamic>).map(toString) :
      throw new Error('unable to convert $value to Array<String>');
  }

  public static function toArrayStringOr(value : Dynamic, alt : Array<String>) : Array<String> {
    if(null == value) return alt;
    return try toArrayString(value) catch(e : Error) alt;
  }

  public static function toArrayInt(value : Dynamic) : Array<Int> {
    if(null == value) return null;
    return Std.is(value, Array) ?
      (value : Array<Dynamic>).map(toInt) :
      throw new Error('unable to convert $value to Array<Int>');
  }

  public static function toArrayIntOr(value : Dynamic, alt : Array<Int>) : Array<Int> {
    if(null == value) return alt;
    return try toArrayInt(value) catch(e : Error) alt;
  }

  public static function toArrayFloat(value : Dynamic) : Array<Float> {
    if(null == value) return null;
    return Std.is(value, Array) ?
      (value : Array<Dynamic>).map(toFloat) :
      throw new Error('unable to convert $value to Array<Float>');
  }

  public static function toArrayFloatOr(value : Dynamic, alt : Array<Float>) : Array<Float> {
    if(null == value) return alt;
    return try toArrayFloat(value) catch(e : Error) alt;
  }

  public static function toArrayBool(value : Dynamic) : Array<Bool> {
    if(null == value) return null;
    return Std.is(value, Array) ?
      (value : Array<Dynamic>).map(toBool):
      throw new Error('unable to convert $value to Array<Bool>');
  }

  public static function toArrayBoolOr(value : Dynamic, alt : Array<Bool>) : Array<Bool> {
    if(null == value) return alt;
    return try toArrayBool(value) catch(e : Error) alt;
  }

  public static function toArrayDate(value : Dynamic) : Array<Date> {
    if(null == value) return null;
    return Std.is(value, Array) ?
      (value : Array<Dynamic>).map(toDate):
      throw new Error('unable to convert $value to Array<Date>');
  }

  public static function toArrayDateOr(value : Dynamic, alt : Array<Date>) : Array<Date> {
    if(null == value) return alt;
    return try toArrayDate(value) catch(e : Error) alt;
  }

  public static function toArrayDateTime(value : Dynamic) : Array<DateTime> {
    if(null == value) return null;
    return Std.is(value, Array) ?
      (value : Array<Dynamic>).map(toDateTime):
      throw new Error('unable to convert $value to Array<DateTime>');
  }

  public static function toArrayDateTimeOr(value : Dynamic, alt : Array<DateTime>) : Array<DateTime> {
    if(null == value) return alt;
    return try toArrayDateTime(value) catch(e : Error) alt;
  }

  public static function toArrayObject(value : Dynamic) : Array<{}> {
    if(null == value) return null;
    return Std.is(value, Array) ?
      (value : Array<Dynamic>).map(toObject):
      throw new Error('unable to convert $value to Array<{}>');
  }

  public static function toArrayObjectOr(value : Dynamic, alt : Array<{}>) : Array<{}> {
    if(null == value) return alt;
    return try toArrayObject(value) catch(e : Error) alt;
  }
}
