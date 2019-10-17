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

  public static function deflate(o: {}, ?flattenArrays: Bool = true): {} {
    function f(v: Dynamic): Either<Dynamic, Map<String, Dynamic>> {
      if(Std.is(v, Array)) {
        if(flattenArrays) {
          if(v.length == 0) {
            return Left([]);
          } else {
            var a: Array<Dynamic> = v;
            return Right(Arrays.reducei(a, function(map: Map<String, Dynamic>, value, i) {
              switch f(value) {
                case Left(v):
                  map.set('$i', v);
                case Right(m):
                  for(k in m.keys()) {
                    map.set('$i.$k', m.get(k));
                  }
              }
              return map;
            }, new Map()));
          }
        } else {
          return Left(v);
        }
      } else if(Types.isAnonymousObject(v)) {
        return Right(Arrays.reduce(Reflect.fields(v), function(map: Map<String, Dynamic>, key: String) {
          switch f(Reflect.field(v, key)) {
            case Left(v):
              map.set('$key', v);
            case Right(m):
              if(Maps.isEmpty(m)) {
                map.set('$key', {});
              } else {
                for(k in m.keys()) {
                  map.set('$key.$k', m.get(k));
                }
              }
          }
          return map;
        }, new Map()));
      } else {
        return Left(v);
      }
    }
    return switch f(o) {
      case Left(v):
        v;
      case Right(m):
        Maps.toObject(m);
    };
  }

public static function inflate(o: {}) {
  return Arrays.reduce(Reflect.fields(o), function(acc, field) {
    return setPath(acc, field, Reflect.field(o, field));
  }, {});
}

/**
Shallow, typed merge of two anonymous objects.
**/
  macro public static function merge(first : ExprOf<{}>, second : ExprOf<{}>) {
    haxe.macro.Context.warning('use thx.Objects.shallowMerge or thx.Objects.deepMerge instead', haxe.macro.Context.currentPos()); // macro-time @:deprecation
    return thx.macro.Objects.shallowMergeImpl(first, second);
  }

/**
Shallow, typed merge of two anonymous objects.
**/
  macro public static function shallowMerge(first: ExprOf<{}>, second: ExprOf<{}>) {
    return thx.macro.Objects.shallowMergeImpl(first, second);
  }

/**
Shallow, untyped merge of two anonymous objects.
**/
  @:deprecated('use thx.Objects.shallowCombine or thx.Objects.deepCombine instead')
  public static function combine(first : {}, second : {}) : {} {
    return shallowCombine(first, second);
  }

/**
Shallow, untyped merge of two anonymous objects.
**/
  public static function shallowCombine(first: {}, second: {}) : {} {
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
Deep, typed merge of two objects.
**/
  /* TODO: placeholder for future macro-based deepMergeImpl
  macro public static function deepMerge(first: ExprOf<{}>, second: ExprOf<{}>) {
    return thx.macro.Objects.deepMergeImpl(first, second);
  }
  */

/**
Deep, untyped merge of two objects.
**/
  public static function deepCombine(first: {}, second: {}) : {} {
    return copyTo(second, first, true);
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
    path = normalizePath(path);
    var paths = path.split(".");
    var current : Dynamic = o;

    for (currentPath in paths) {
      if(currentPath.isDigitsOnly()) {
        var index = Std.parseInt(currentPath),
            arr = Std.downcast(current, Array);
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
E.g. { key1: { key2: [1, 2, 3] } }.getPath("key1.key2[2]") -> returns 3
**/
  public static function getPath(o : {}, path : String) : Dynamic {
    path = normalizePath(path);
    var paths = path.split(".");
    var current : Dynamic = o;
    for (currentPath in paths) {
      if (current == null) {
        return null;
      } else if(currentPath.isDigitsOnly()) {
        var index = Std.parseInt(currentPath),
            arr = Std.downcast(current, Array);
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
Null-safe `getPath` that attempts to parse the result using the provided parse
function. `thx.fp.Dynamics` has several functions that match this pattern.
**/
  public static function parsePath<T>(o : {}, path : String, parse : Dynamic -> Validation.VNel<String, T>) : Validation.VNel<String, T>
    return Options.toSuccessNel(getPathOption(o, path), 'Object does not contain path $path')
      .flatMapV(parse);

  /**
  Gets a value from an object by a string path.  The path can contain object keys and array indices separated
  by ".".  Returns `alt` for a path that does not exist.
```
  E.g. { key1: { key2: [1, 2, 3] } }.getPath("key1.key2.2") -> returns 3
  E.g. { key1: { key2: [1, 2, 3] } }.getPath("key1.key2.5", 7) -> returns 7
```
  **/
    public static function getPathOr(o : {}, path : String, alt : Dynamic) : Dynamic {
      return Options.getOrElse(getPathOption(o, path), alt);
    }

/**
Sets a value in an object by a string path.  The path can contain object keys and array indices separated
by ".".  Returns the original object, for optional chaining of other object methods.

Inner objects and arrays will be created as needed when traversing the path.

E.g. { key1: { key2: [1, 2, 3] } }.setPath("key1.key2.2", 4) -> returns { key1: { key2: [ 1, 2, 4 ] } }
**/
  public static function setPath<T>(o : {}, path : String, val : T) : {} {
    path = normalizePath(path);
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
    path = normalizePath(path);
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

  static inline function normalizePath(path : String) : String {
    return ~/\[(\d+)\]/g.replace(path, ".$1"); // Normalize [x] array access to .x (where x is an integer)
  }

/*
Create a copy of the object with the field `field` replaced by `value`.
*/
  macro public static function with<T : {}>(o : haxe.macro.Expr.ExprOf<T>, field : haxe.macro.Expr, value: haxe.macro.Expr) {
    var matchField = haxe.macro.ExprTools.toString(field);
    var obj = { expr : switch haxe.macro.Context.typeof(o) {
      case TAnonymous(a):
        var t = a.get();
        buildFromAnonymous(matchField, t.fields, value, field.pos);
      case TType(tr, _):
        var t = tr.get();
        switch t {
          case { type : TAnonymous(a) }:
            var t = a.get();
            buildFromAnonymous(matchField, t.fields, value, field.pos);
          case _:
            null;
        }
      case e:
        // trace(e);
        haxe.macro.Context.error("Objects.with() only works with anonymous objects", o.pos);
        null;
    }, pos : o.pos };

    return macro {
      var o = $o;
      $obj;
    };
  }
#if macro
  static function buildFromAnonymous(matchField, fields, value, pos) {
    var found = false;
    var e = haxe.macro.Expr.ExprDef.EObjectDecl(fields.map(function(field)#if (haxe_ver >= 4.0) :haxe.macro.Expr.ObjectField #end {
      var fieldName = field.name;
      if(fieldName == matchField) {
        found = true;
        return { field: field.name, expr: value };
      } else {
        return { field: field.name, expr: macro o.$fieldName };
      }
    }));
    if(!found) {
      haxe.macro.Context.error('object does not contain field `$matchField`', pos);
    }
    return e;
  }
#end
}
