package thx;

import haxe.ds.Option;
import thx.Dynamics;
import thx.Tuple;
using thx.Arrays;
using thx.Strings;

/**
Helper methods for generic objects.
**/
class Objects {
/**
Compares two objects assuming that the object with less fields will come first.

If both objects have the same number of fields, each field value is compared
using `thx.Dynamics.compare`.
**/
  public static function compare(a : {}, b : {}) {
    var v, fields;
    if ((v = Arrays.compare((fields = Reflect.fields(a)), Reflect.fields(b))) != 0)
      return v;
    for (field in fields) {
      if ((v = Dynamics.compare(Reflect.field(a, field), Reflect.field(b, field))) != 0)
        return v;
    }
    return 0;
  }

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
Merges `first` and `second` using the `combine` strategy to return a merged object. The returned
object is typed as an object containing all of the fields from both `first` and `second`.
**/
  macro public static function merge(first : ExprOf<{}>, second : ExprOf<{}>) {
    return thx.macro.Objects.mergeImpl(first, second);
  }

/**
Copies the values from the fields of `first` and `second` to a new object. If `first` and `second` contain
fields with the same name, the returned object will use the fields from `second`. Both objects passed
to this function will be unmodified.

The `combine` operation is not recursive and does a shallow merge of the two objects.
**/
  public static function combine(first : {}, second : {}) : {} {
    var to = {};
    for(field in Reflect.fields(first)) {
      Reflect.setField(to, field, Reflect.field(first, field));
    }
    for(field in Reflect.fields(second)) {
      Reflect.setField(to, field, Reflect.field(second, field));
    }
    return to;
  }

/**
Copies the values from the fields of `from` to `to`. If `to` already contains those fields, then it replaces
those values with the return value of the function `replacef`.

If not set, `replacef` always returns the value from the `from` object.
**/
  public static function assign(to : {}, from : {}, ?replacef : String -> Dynamic -> Dynamic -> Dynamic) : {} {
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
      var sv = Dynamics.clone(Reflect.field(src, field), cloneInstances);
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
    return Dynamics.clone(src, cloneInstances);
  }


/**
`objectToMap` transforms an anonymous object into an instance of `Map<String, Dynamic>`.
**/
  public static function toMap(o : {}) : Map<String, Dynamic>
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
Returns a string representation of the object containing each field and value.

The function is recursive so it might generate infinite loops if used with
circular references.
**/
  public static function string(o : {}) : String {
    return "{" +
      Reflect.fields(o)
        .map(function(key) {
          var v = Reflect.field(o, key);
          var s = if(Std.is(v, String)) {
                    Strings.quote((v : String));
                  } else {
                    Dynamics.string(v);
                  }
          return '$key : $s';
        })
        .join(", ") +
      "}";
  }

  static function stringImpl(o : {}, cache : Map<{}, Bool>) {

  }

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
Determines whether an object has fields represented by a string path.  The path
can contain object keys and array indices separated by ".".

E.g. { key1: { key2: [1, 2, 3] } }.hasPath("key1.key2.2") -> returns true
**/
  public static function hasPath(o : {}, path : String) : Bool {
    var paths = path.split(".");
    var current : Dynamic = o;

    for (currentPath in paths) {
      if(currentPath.isDigitsOnly()) {
        var index = Std.parseInt(currentPath),
            arr = Std.instance(current, Array);
        if(null == arr || arr.length <= index) return false;
        current = arr[index];
      } else if (Reflect.hasField(current, currentPath)) {
        current = Reflect.field(current, currentPath);
      } else {
        return false;
      }
    }
    return true;
  }

/**
Like `hasPath`, but will return `false` for null values, even if the key exists.

E.g. { key1 : { key2: null } }.hasPathValue("key1.key2") -> returns false
**/
  public static function hasPathValue(o : {}, path : String) : Bool
    return getPath(o, path) != null;

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
  Null-safe getPath
  **/
  public static function getPathOption(o : {}, path : String) : Option<Dynamic>
    return Options.ofValue(getPath(o, path));

  /**
  Gets a value from an object by a string path.  The path can contain object keys and array indices separated
  by ".".  Returns `alt` for a path that does not exist.
```
  E.g. { key1: { key2: [1, 2, 3] } }.getPath("key1.key2.2") -> returns 3
  E.g. { key1: { key2: [1, 2, 3] } }.getPath("key1.key2.5", 7) -> returns 7
```
  **/
    public static function getPathOr(o : {}, path : String, alt : Dynamic) : Dynamic {
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
          return alt;
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
    var paths = path.split("."),
        current : Dynamic = o;

    for (i in 0...(paths.length - 1)) {
      var currentPath = paths[i],
          nextPath = paths[i + 1];

      if (currentPath.isDigitsOnly() || currentPath == "*") {
        var index = if(currentPath == "*") {
          (current : Array<Dynamic>).length;
        } else {
          Std.parseInt(currentPath);
        }
        if (current[index] == null) {
          if (nextPath.isDigitsOnly() || nextPath == "*") {
            current[index] = [];
          } else {
            current[index] = {};
          }
        }
        current = current[index];
      } else {
        if (!Reflect.hasField(current, currentPath)) {
          if (nextPath.isDigitsOnly() || nextPath == "*") {
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
    } else if(p == "*") {
      (current : Array<Dynamic>).push(val);
    } else {
      Reflect.setField(current, p, val);
    }
    return o;
  }

/**
Delete an object's property, given a string path to that property.

E.g. { foo : 'bar' }.removePath('foo') -> returns {}
**/
  public static function removePath(o : {}, path : String) : {} {
    var paths = path.split(".");

    // the last item in the list of paths is the target field
    var target = paths.pop();

    // iterate over all remaining fields to find the sub-object containing
    // the target field to be removed
    try {
      var sub = paths.reduce(function(existing : Dynamic, nextPath) {
        if (nextPath == "*") {
          return (existing : Array<Dynamic>).pop();
        } else if (nextPath.isDigitsOnly()) {
          var current : Dynamic = existing;
          var index = Std.parseInt(nextPath);
          return current[index];
        } else {
          return Reflect.field(existing, nextPath);
        }
      }, o);

      if (null != sub)
        Reflect.deleteField(sub, target);
    } catch (e : Dynamic) { }

    return o;
  }
}
