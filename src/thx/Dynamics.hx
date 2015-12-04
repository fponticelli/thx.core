package thx;

using thx.Arrays;
import thx.Objects;
import thx.Tuple;

/**
`Dynamics` provides additional extension methods on any type.
**/
class Dynamics {
/**
Structural and recursive equality.
**/
  public static function equals<T1, T2>(a : T1, b : T2) : Bool {
    // type check
    if(!Types.sameType(a, b))
      return false;

    // quick check
    if(untyped a == b)
      return true;

    switch Type.typeof(a) {
      case TFloat, TNull, TInt, TBool:
        return false;
      case TFunction:
        return Reflect.compareMethods(a, b);
      case TClass(c):
        var ca = Type.getClassName(c),
            cb = Type.getClassName(Type.getClass(b));
        if (ca != cb)
          return false;

        // string
        if (Std.is(a, String))
          return false;

        // arrays
        if (Std.is(a, Array)) {
          var aa : Array<Dynamic> = cast a,
              ab : Array<Dynamic> = cast b;
          if (aa.length != ab.length)
            return false;
          for (i in 0...aa.length)
            if (!equals(aa[i], ab[i]))
              return false;
          return true;
        }

        // date
        if(Std.is(a, Date))
          return untyped a.getTime() == b.getTime();

        // map
        if (Maps.isMap(a)) {
          var ha : Map<Dynamic, Dynamic> = cast a,
              hb : Map<Dynamic, Dynamic> = cast b;
          var ka = Iterators.toArray(ha.keys()),
              kb = Iterators.toArray(hb.keys());
          if (ka.length != kb.length)
            return false;
          for (key in ka)
            if (!hb.exists(key) || !equals(ha.get(key), hb.get(key)))
              return false;
          return true;
        }

        // iterator or iterable
        var t = false;
        if ((t = Iterators.isIterator(a)) || Iterables.isIterable(a)) {
          var va = t ? Iterators.toArray(cast a) : Iterables.toArray(cast a),
              vb = t ? Iterators.toArray(cast b) : Iterables.toArray(cast b);
          if (va.length != vb.length)
            return false;

          for (i in 0...va.length)
            if (!equals(va[i], vb[i]))
              return false;
          return true;
        }

        // custom class with equality method
        var f = null;
        if(Reflect.hasField(a, 'equals') && Reflect.isFunction(f = Reflect.field(a, 'equals')))
          return Reflect.callMethod(a, f, [b]);

        // custom class
        var fields = Type.getInstanceFields(Type.getClass(a));
        for (field in fields) {
          var va = Reflect.field(a, field);
          if (Reflect.isFunction(va))
            continue;
          var vb = Reflect.field(b, field);
          if(!equals(va, vb))
            return false;
        }
        return true;
      case TEnum(e) :
        var ea  = Type.getEnumName(e),
            teb = Type.getEnum(cast b),
            eb  = Type.getEnumName(teb);
        if (ea != eb)
          return false;

        if (Type.enumIndex(cast a) != Type.enumIndex(cast b))
          return false;
        var pa = Type.enumParameters(cast a),
          pb = Type.enumParameters(cast b);
        for (i in 0...pa.length)
          if (!equals(pa[i], pb[i]))
            return false;
        return true;
      case TObject  :
        // anonymous object
        var fa = Reflect.fields(a),
            fb = Reflect.fields(b);
        for (field in fa) {
          fb.remove(field);
          if (!Reflect.hasField(b, field))
            return false;
          var va = Reflect.field(a, field);
          if(Reflect.isFunction(va))
            continue;
          var vb = Reflect.field(b, field);
          if(!equals(va, vb))
            return false;
        }
        if (fb.length > 0)
          return false;

        // iterator
        var t = false;
        if ((t = Iterators.isIterator(a)) || Iterables.isIterable(a)) {
          if (t && !Iterators.isIterator(b))
            return false;
          if (!t && !Iterables.isIterable(b))
            return false;


          var aa = t ? Iterators.toArray(cast a) : Iterables.toArray(cast a);
          var ab = t ? Iterators.toArray(cast b) : Iterables.toArray(cast b);
          if (aa.length != ab.length)
            return false;
          for (i in 0...aa.length)
            if (!equals(aa[i], ab[i]))
              return false;
          return true;
        }
        return true;
      case TUnknown :
        return throw "Unable to compare two unknown types";
    }
    return throw new Error('Unable to compare values: $a and $b');
  }

/**
Clone the object.

Null values, strings, dates, numbers, enums and functions are immutable so will be returned as is.
Anonymous objects will be created and each field cloned recursively.
Arrays will be recreated and each object cloned recursively.
Class instances will either be cloned, or the reference copied, depending on the value of `cloneInstances`.

@param v The object which will be cloned.
@param cloneInstances If true, class instances will be cloned using `Type.createEmptyInstance` and `Reflect.setField`. If false, class instances will be re-used, not cloned. Default is false.
**/
  public static function clone(v : Dynamic, ?cloneInstances = false) : Dynamic {
    switch(Type.typeof(v)) {
      case TNull:
        return null;
      case TInt, TFloat, TBool, TEnum(_), TUnknown, TFunction:
        return v;
      case TObject:
        return Objects.copyTo(v,{});
      case TClass(c):
        var name = Type.getClassName(c);
        switch(name) {
          case "Array":
            return (v : Array<Dynamic>).map(function(v)
              return clone(v, cloneInstances)
            );
          case "String", "Date":
            return v;
          default:
            if(cloneInstances) {
              var o = Type.createEmptyInstance(c);
              for (field in Type.getInstanceFields(c))
                Reflect.setField(o, field, clone(Reflect.field(v, field), cloneInstances));
              return o;
            } else {
              return v;
            }
        }
    }
  }

/**
Compares two runtime values trying to match values.
**/
  public static function compare(a : Dynamic, b : Dynamic) {
    if (null == a && null == b)
      return 0;
    if (null == a)
      return -1;
    if (null == b)
      return 1;
    if(!Types.sameType(a, b))
      return Strings.compare(Types.valueTypeToString(a), Types.valueTypeToString(b));
    switch(Type.typeof(a)) {
      case TInt:    return Ints.compare(a, b);
      case TFloat:  return Floats.compare(a, b);
      case TBool:   return Bools.compare(a, b);
      case TObject: return Objects.compare(a, b);
      case TClass(c):
        var name = Type.getClassName(c);
        switch(name) {
          case "Array":
            return Arrays.compare(a, b);
          case "String":
            return Strings.compare(a, b);
          case "Date":
            return Dates.compare(a, b);
          case _ if(Reflect.hasField(a, "compare")):
            return Reflect.callMethod(a, Reflect.field(a, "compare"), [b]);
          default:
            return Strings.compare(Std.string(a), Std.string(b));
        }
      case TEnum(e):
        return Enums.compare(a, b);
      default:
        return 0;
    }
  }

/**
Convert any value into a `String`.
**/
  public static function string(v : Dynamic) {
    switch Type.typeof(v) {
      case TNull:
        return "null";
      case TInt, TFloat, TBool:
        return '$v';
      case TObject:
        return Objects.string(v);
      case TClass(c):
        switch Type.getClassName(c) {
          case "Array":
            return Arrays.string(v);
          case "String":
            return v;
          case "Date":
            return (v : Date).toString();
          default:
            if(Maps.isMap(v))
              return Maps.string(v);
            else
              return Std.string(v);
        }
      case TEnum(e):
        return Enums.string(v);
      case TUnknown:
        return "<unknown>";
      case TFunction:
        return "<function>";
    }
  }
}

class DynamicsT {
  /**
  `isEmpty` returns `true` if the object doesn't have any field.
  **/
    inline public static function isEmpty<T>(o : Dynamic<T>) : Bool
      return size(o) == 0;

  /**
  `exists` returns true if `o` contains a field named `name`.
  **/
    inline public static function exists<T>(o : Dynamic<T>, name : String) : Bool
      return Reflect.hasField(o, name);

  /**
  `fields` returns an array of string containing the field names of the argument object.
  **/
    inline public static function fields<T>(o : Dynamic<T>) : Array<String>
      return Reflect.fields(o);

  /**
  Copies the values from the fields of `from` to `to`. If `to` already contains those fields, then it replace
  those values with the return value of the function `replacef`.

  If not set, `replacef` always returns the value from the `from` object.
  **/
    public static function merge<T>(to : Dynamic<T>, from : Dynamic<T>, ?replacef : String -> Dynamic -> Dynamic -> Dynamic) : Dynamic<T> {
      if(null == replacef)
        replacef = function(field : String, oldv : Dynamic, newv : Dynamic) return newv;
      for(field in Reflect.fields(from)) {
        var newv = Reflect.field(from, field);
        if(Reflect.hasField(to, field)) {
          Reflect.setField(to, field, replacef(field, Reflect.field(to, field), newv));
        } else {
          Reflect.setField(to, field, newv);
        }
      }
      return to;
    }

  /**
  `objectToMap` transforms an anonymous object into an instance of `Map<String, Dynamic>`.
  **/
    @:generic
    public static function toMap<T>(o : Dynamic<T>) : Map<String, T>
      return tuples(o).reduce(function(map : Map<String, T>, t) {
        map.set(t._0, t._1);
        return map;
      }, new Map());

  /**
  `size` returns how many fields are present in the object.
  **/
    inline public static function size<T>(o : Dynamic<T>) : Int
      return Reflect.fields(o).length;

  /**
  `values` returns an array of dynamic values containing the values of each field in the argument object.
  **/
    inline public static function values<T>(o : Dynamic<T>) : Array<Dynamic>
      return Reflect.fields(o).map(function(key) return Reflect.field(o, key));

  /**
  Converts an object into an Array<Tuple2<String, Dynamic>> where the left value (_0) of the
  tuple is the field name and the right value (_1) is the field value.
  **/
    public static function tuples<T>(o : Dynamic<T>): Array<Tuple2<String, T>>
      return Reflect.fields(o).map(function(key)
          return new Tuple2(key, Reflect.field(o, key))
      );
}
