package thx.core;

import thx.core.Tuple;
using thx.core.Arrays;

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
}