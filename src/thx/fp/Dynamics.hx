package thx.fp;

import haxe.ds.Option;
import thx.Options;
import thx.Monoid;
import thx.Nel;
import thx.Validation;
import thx.Validation.*;
import thx.Unit;
import thx.Ints;
import thx.Floats;
import thx.fp.Dynamics;
import thx.fp.Functions.flip;
import thx.fp.Writer;

using thx.Arrays;
using thx.Functions;
using thx.Iterators;
using thx.Maps;
using thx.Options;
using thx.Objects;

class Dynamics {
  public static function parseInt(v: Dynamic): VNel<String, Int>
    return switch Type.typeof(v) {
      case TInt :   successNel(cast v);
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "String" if (Ints.canParse(v)) : successNel(Ints.parse(cast v));
          case other: failureNel('Cannot parse an integer value from $v (type resolved to $other)');
        };

      case other: failureNel('Cannot parse an integer value from $v (type resolved to $other)');
    };

  public static function parseFloat(v: Dynamic): VNel<String, Float>
    return switch Type.typeof(v) {
      case TInt :   successNel(cast v);
      case TFloat : successNel(cast v);
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "String" if (Floats.canParse(v)) : successNel(Floats.parse(cast v));
          case other: failureNel('Cannot parse a floating-point value from $v (type resolved to $other)');
        };
      case other: failureNel('Cannot parse a floating-point value from $v (type resolved to $other)');
    };

  public static function parseString(v: Dynamic): VNel<String, String>
    return switch Type.typeof(v) {
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "String": successNel(cast v);
          case other: failureNel('$v is not a String value (type resolved to $other)');
        };
      case other: failureNel('$v is not a String value (type resolved to $other)');
    };

  public static function parseBool(v: Dynamic): VNel<String, Bool>
    return switch Type.typeof(v) {
      case TBool: successNel(cast v);
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "String" if (Bools.canParse(v)) : successNel(Bools.parse(cast v));
          case other: failureNel('Cannot parse a boolean value from $v (type resolved to $other)');
        };
      case other: failureNel('Cannot parse a boolean value from $v (type resolved to $other)');
    };

  public static function parseProperty<E, A>(ob: {}, name: String, f: Dynamic -> VNel<E, A>, err: String -> E): VNel<E, A> 
    return nnNel(ob.getPath(name), err('Property "$name" was not found.')).flatMapV(f);

  // This demands that the parser for the field value be able to accept
  // null values, which is not the usual way of things.
  public static function parseNullableProperty<E, A>(ob: {}, name: String, f: Null<Dynamic> -> VNel<E, A>): VNel<E, A> {
    return f(ob.getPath(name));
  }

  public static function parseOptionalProperty<E, A>(ob: {}, name: String, f: Dynamic -> VNel<E, A>): VNel<E, Option<A>> {
    var property = ob.getPath(name);
    return if (property != null) f(property).map(function(a) return Some(a)) else successNel(None);
  }

  public static function parseArray<E, A>(v: Dynamic, f: Dynamic -> VNel<E, A>, err: String -> E): VNel<E, Array<A>>
    return switch Type.typeof(v) {
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "Array": (v: Array<Dynamic>).traverseValidation(f, Nel.semigroup());
          case other: failureNel(err('$v is not array-valued (type resolved to $other)'));
        };
      case other: failureNel(err('$v is not array-valued (type resolved to $other)'));
    };

  public static function parseArrayIndexed<E, A>(v: Dynamic, f: Dynamic -> Int -> VNel<E, A>, err: String -> E): VNel<E, Array<A>>
    return switch Type.typeof(v) {
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "Array": (v: Array<Dynamic>).traverseValidationIndexed(f, Nel.semigroup());
          case other: failureNel(err('$v is not array-valued (type resolved to $other)'));
        };
      case other: failureNel(err('$v is not array-valued (type resolved to $other)'));
    };

  public static function parseMap<E, K, V>(v: Dynamic, f: String -> Dynamic -> VNel<E, Tuple<K, V>>, keyOrder: Ord<K>, err: String -> E): VNel<E, thx.fp.Map<K, V>> {
    return if (Reflect.isObject(v)) {
      Reflect.fields(v).traverseValidation(
        function(field: String) return f(field, Reflect.getProperty(v, field)), 
        Nel.semigroup()
      ).flatMapV(
        function(tuples) return Arrays.toMap(tuples, keyOrder).leftMap(
          function(collidingKeys) return collidingKeys.map(
            function(key) return err('Key ${key} occurred multiple types in in object $v')
          )
        )
      );
    } else {
      failureNel(err('$v is not object-valued (type resolved to ${Type.typeof(v)})'));
    };
  }

}
