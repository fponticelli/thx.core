package thx;

import thx.Dynamics;
import thx.Tuple;
using thx.Arrays;
using thx.Strings;

/**
Helper methods for generic objects.
**/
class Objects {
/**
`isEmpty` returns `true` if the object doesn't have any field.
**/
  inline public static function isEmpty(o : {}) : Bool
    return size(o) == 0;

/**
`exists` returns true if `o` contains a field named `name`.
**/
  inline public static function exists(o : {}, name : String) : Bool
    return Reflect.hasField(o, name);

/**
`fields` returns an array of string containing the field names of the argument object.
**/
  inline public static function fields(o : {}) : Array<String>
    return Reflect.fields(o);

/**
Copies the values from the fields of `from` to `to`. If `to` already contains those fields, then it replace
those values with the return value of the function `replacef`.

If not set, `replacef` always returns the value from the `from` object.
**/
  public static function merge(to : {}, from : {}, ?replacef : String -> Dynamic -> Dynamic -> Dynamic) : {} {
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
`copyTo` copies the fields from `src` to `dst` using `Reflect.setField()` and `Dynamics.clone()`.
Anonymous objects are entered into and copied recursively.
**/
  public static function copyTo(src : { }, dst : { }, cloneInstances = false) : {} {
    for (field in Reflect.fields(src)) {
      var sv = Dynamics.clone(Reflect.field(src, field),cloneInstances);
      var dv = Reflect.field(dst, field);
      if (Types.isAnonymousObject(sv) && Types.isAnonymousObject(dv)) {
        copyTo(sv, dv);
      } else {
        Reflect.setField(dst, field, sv);
      }
    }
    return dst;
  }

/**
Clone the current object by creating a new object and using `copyTo` to clone each field.
**/
  public static function clone<T:{}>(src : T, cloneInstances = false) : T {
    return Dynamics.clone(src,cloneInstances);
  }


/**
`objectToMap` transforms an anonymous object into an instance of `Map<String, Dynamic>`.
**/
  public static function objectToMap(o : {}) : Map<String, Dynamic>
    return tuples(o).reduce(function(map : Map<String, Dynamic>, t) {
      map.set(t._0, t._1);
      return map;
    }, new Map());

/**
`size` returns how many fields are present in the object.
**/
  inline public static function size(o : {}) : Int
    return Reflect.fields(o).length;

/**
`values` returns an array of dynamic values containing the values of each field in the argument object.
**/
  inline public static function values(o : {}) : Array<Dynamic>
    return Reflect.fields(o).map(function(key) return Reflect.field(o, key));

/**
Converts an object into an Array<Tuple2<String, Dynamic>> where the left value (_0) of the
tuple is the field name and the right value (_1) is the field value.
**/
  public static function tuples(o : {}): Array<Tuple2<String, Dynamic>>
    return Reflect.fields(o).map(function(key)
        return new Tuple2(key, Reflect.field(o, key))
    );

/**
Gets a value from an object by a string path.  The path can contain object keys and array indices separated
by ".".  Returns null for a path that does not exist.

E.g. { key1: { key2: [1, 2, 3] } }.getPath("key1.key2.2") -> returns 3
**/
  public static function getPath(o : {}, path : String) : Dynamic {
    var paths = path.split(".");
    var current : Dynamic = o;
    for (currentPath in paths) {
      if(currentPath.isDigitsOnly()) {
        var index = Std.parseInt(currentPath),
            arr = Std.instance(current, Array);
        if(null == arr) return null;
        current = arr[index];
      } else if (Reflect.hasField(current, currentPath)) {
        current = Reflect.field(current, currentPath);
      } else {
        return null;
      }
    }
    return current;
  }

/**
Sets a value in an object by a string path.  The path can contain object keys and array indices separated
by ".".  Returns the original object, for optional chaining of other object methods.

Inner objects and arrays will be created as needed when traversing the path.

E.g. { key1: { key2: [1, 2, 3] } }.setPath("key1.key2.2", 4) -> returns { key1: { key2: [ 1, 2, 4 ] } }
**/
  public static function setPath<T>(o : {}, path : String, val : T) : {} {
    var paths = path.split(".");
    var current : Dynamic = o;

    for (i in 0...(paths.length - 1)) {
      var currentPath = paths[i];
      var nextPath = paths[i + 1];

      if (currentPath.isDigitsOnly()) {
        var index = Std.parseInt(currentPath);
        if (current[index] == null) {
          if (nextPath.isDigitsOnly()) {
            current[index] = [];
          } else {
            current[index] = {};
          }
        }
        current = current[index];
      } else {
        if (!Reflect.hasField(current, currentPath)) {
          if (nextPath.isDigitsOnly()) {
            Reflect.setField(current, currentPath, []);
          } else {
            Reflect.setField(current, currentPath, {});
          }
        }
        current = Reflect.field(current, currentPath);
      }
    }
    var p = paths.last();
    if (p.isDigitsOnly()) {
      var index = Std.parseInt(p);
      current[index] = val;
    } else {
      Reflect.setField(current, p, val);
    }
    return o;
  }

/**
Delete an object's property, given a string path to that property.
**/
  public static function deletePath(o : {}, path : String) : {} {
    var paths = path.split(".");

    // the last item in the list of paths is the target field
    var target = paths.pop();

    // iterate over all remaining fields to find the sub-object containing
    // the target field to be removed
    try {
      var sub = paths.reduce(function(existing, nextLayer) {
        return Reflect.field(existing, nextLayer);
      }, o);

      if (null != sub)
        Reflect.deleteField(sub, target);
    } catch (e : Dynamic) { }

    return o;
  }
}
