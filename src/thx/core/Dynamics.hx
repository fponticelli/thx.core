package thx.core;

import thx.core.Objects;

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
              for (field in Reflect.fields(v))
                Reflect.setField(o, field, clone(Reflect.field(v, field), cloneInstances));
              return o;
            } else {
              return v;
            }
        }
    }
  }
}