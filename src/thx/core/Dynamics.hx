package thx.core;

class Dynamics {
  public static function same<T1, T2>(a : T1, b : T2) : Bool {
    // quick check
    if(untyped a == b)
      return true;

    // type check
    if(!Types.sameType(a, b))
      return false;

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
            if (!same(aa[i], ab[i]))
              return false;
          return true;
        }

        // date
        if(Std.is(a, Date))
          return untyped a.getTime() == b.getTime();

        // map
        if (Std.is(a, Map)) {
          var ha : Map<Dynamic, Dynamic> = cast a,
              hb : Map<Dynamic, Dynamic> = cast b;
          var ka = Iterators.toArray(ha.keys()),
              kb = Iterators.toArray(hb.keys());
          if (ka.length != kb.length)
            return false;
          for (key in ka)
            if (!hb.exists(key) || !same(ha.get(key), hb.get(key)))
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
            if (!same(va[i], vb[i]))
              return false;
          return true;
        }

        // custom class
        var fields = Type.getInstanceFields(Type.getClass(a));
        for (field in fields) {
          var va = Reflect.field(a, field);
          if (Reflect.isFunction(va))
            continue;
          var vb = Reflect.field(b, field);
          if(!same(va, vb))
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
          if (!same(pa[i], pb[i]))
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
          if(!same(va, vb))
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
            if (!same(aa[i], ab[i]))
              return false;
          return true;
        }
        return true;
      case TUnknown :
        return throw "Unable to compare two unknown types";
    }
    return throw new Error('Unable to compare values: $a and $b');
  }
}